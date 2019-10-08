#[no_mangle]
pub extern fn fibo(n: u32) -> u32 {
  if n <= 1 { return 1 }
  fibo(n - 1) + fibo(n - 2)
}

fn main() {
  println!("{}", fibo(8));
}
