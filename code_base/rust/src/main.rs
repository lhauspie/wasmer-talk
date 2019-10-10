use std::env;

#[no_mangle]
pub extern fn fibo(n: u32) -> u32 {
  if n <= 1 { return 1 }
  fibo(n - 1) + fibo(n - 2)
}

pub fn main() {
  let number = env::args().last().unwrap_or("2".to_string()).parse().unwrap_or(2);
  let result = fibo(number);
  println!("{}", result);
}