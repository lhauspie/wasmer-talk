extern crate wasmer_runtime;

use std::str;

use wasmer_runtime::{
    imports,
    instantiate,
    error,
    func,
    Memory,
    units::Pages,
    Func,
    Ctx,
    wasm::MemoryDescriptor,
};

// Make sure that the compiled wasm-sample-app is accessible at this path.
static WASM: &'static [u8] = include_bytes!("../../../target/fibo_cpp_js.wasm");

fn main() -> error::Result<()> {
    let descriptor = MemoryDescriptor::new(Pages(256), Some(Pages(256)), false).unwrap();
    let memory = Memory::new(descriptor)?;

    let import_object = imports! {
       "env" => {
            // "_echo" => func!(echo),
            "_printf" => func!(printf),
            "memory" => memory,
        },
    };

    let instance = instantiate(WASM, &import_object)?;
    let fibo: Func<i32, i32> = instance.func("__Z4fiboj")?;

    println!("F({}) = {}", 11, fibo.call(11)?);

    Ok(())
}

// fn echo(_ctx: &mut Ctx, val: u32) {
//   print!("{}", val);
// }

// Let's define our "printf" function.
//
// The declaration must start with "extern" or "extern "C"".
fn printf(_ctx: &mut Ctx, ptr: u32, len: u32) -> i32 {
    // Get a slice that maps to the memory currently used by the webassembly
    // instance.
    //
    // Webassembly only supports a single memory for now,
    // but in the near future, it'll support multiple.
    //
    // Therefore, we don't assume you always just want to access first
    // memory and force you to specify the first memory.
    let memory = _ctx.memory(0);

    // Get a subslice that corresponds to the memory used by the string.
    let str_vec: Vec<_> = memory.view()[ptr as usize..(ptr + len) as usize].iter().map(|cell| cell.get()).collect();

    // Convert the subslice to a `&str`.
    let string = str::from_utf8(&str_vec).unwrap();

    // Print it!
    println!("{}", string);

    return 0;
}