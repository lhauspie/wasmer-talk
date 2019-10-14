#include <stdio.h>
#include <string.h>
#include "include/wasmer.hh"
#include <assert.h>
#include <stdint.h>


void print_wasmer_error() {
    int error_len = wasmer_last_error_length();
    printf("Error len: `%d`\n", error_len);
    char *error_str = static_cast<char *>(malloc(error_len));
    wasmer_last_error_message(error_str, error_len);
    printf("Error str: `%s`\n", error_str);
}

int main() {
    // Create a new func to hold the parameter and signature
    // of our `printf` host function
    wasmer_value_tag params_sig[] = {wasmer_value_tag::WASM_I32, wasmer_value_tag::WASM_I32};
    wasmer_value_tag returns_sig[] = {wasmer_value_tag::WASM_I32};
    wasmer_import_func_t *func = wasmer_import_func_new((void (*)(void *)) printf,
                                                        params_sig, (sizeof(params_sig)/sizeof(*params_sig)),
                                                        returns_sig, (sizeof(returns_sig)/sizeof(*returns_sig)));

    // Create module name for our imports
    // represented in bytes for UTF-8 compatability
    const char *module_name = "env";
    wasmer_byte_array module_name_bytes = { .bytes = (const uint8_t *) module_name,
                                            .bytes_len = (const uint32_t) strlen(module_name) };

    // Define a function import
    const char *import_name = "_printf";
    wasmer_byte_array import_name_bytes = { .bytes = (const uint8_t *) import_name,
                                            .bytes_len = (const uint32_t) strlen(import_name) };
    wasmer_import_t func_import = { .module_name = module_name_bytes,
                                    .import_name = import_name_bytes,
                                    .tag = wasmer_import_export_kind::WASM_FUNCTION,
                                    .value = {.func = func} };

    // Define a memory import
    const char *import_memory_name = "memory";
    wasmer_byte_array import_memory_name_bytes = { .bytes = (const uint8_t *) import_memory_name,
                                                   .bytes_len = (const uint32_t) strlen(import_memory_name) };
    wasmer_memory_t *memory = NULL;
    wasmer_limit_option_t max = { .has_some = true,
                                  .some = 256 };
    wasmer_limits_t descriptor = { .min = 256,
                                   .max = max };
    wasmer_result_t memory_result = wasmer_memory_new(&memory, descriptor);
    if (memory_result != wasmer_result_t::WASMER_OK) {
        print_wasmer_error();
    }
    assert(memory_result == wasmer_result_t::WASMER_OK);

    wasmer_import_t memory_import = { .module_name = module_name_bytes,
                                      .import_name = import_memory_name_bytes,
                                      .tag = wasmer_import_export_kind::WASM_MEMORY,
                                      .value = {.memory = memory} };

    // Define an array containing our imports
    wasmer_import_t imports[] = {func_import, memory_import};

    // Read the Wasm file bytes.
    FILE *file = fopen("../../target/fibo_rust_js.wasm", "r");
    fseek(file, 0, SEEK_END);
    size_t len = ftell(file);
    uint8_t *bytes = static_cast<uint8_t *>(malloc(len));
    fseek(file, 0, SEEK_SET);
    fread(bytes, 1, len, file);
    fclose(file);

    // Instantiate!
    wasmer_instance_t *instance = NULL;
    wasmer_result_t instantiation_result = wasmer_instantiate(&instance, bytes, len, imports, (sizeof(imports)/sizeof(*imports)));
    if (instantiation_result != wasmer_result_t::WASMER_OK) {
        print_wasmer_error();
    }
    assert(instantiation_result == wasmer_result_t::WASMER_OK);

    // Let's call a function.
    // Start by preparing the arguments.

    // Value of argument #1 is `11i32`.
    wasmer_value_t argument;
    argument.tag = wasmer_value_tag::WASM_I32;
    argument.value.I32 = 11;

    // Prepare the arguments.
    wasmer_value_t arguments[] = {argument};

    // Prepare the return value.
    wasmer_value_t result;
    wasmer_value_t results[] = {result};

    // Call the `sum` function with the prepared arguments and the return value.
    wasmer_result_t call_result = wasmer_instance_call(instance, "fibo", arguments, 1, results, 1);
    if (call_result != wasmer_result_t::WASMER_OK) {
        print_wasmer_error();
    }
    assert(call_result == wasmer_result_t::WASMER_OK);

    // Let's display the result.
    printf("F(%d) = %d\n", arguments[0].value.I32, results[0].value.I32);
    assert(results[0].value.I32 == 144);

    wasmer_instance_destroy(instance);
    return 0;
}