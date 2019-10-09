#![feature(start)]
use std::env;

#[no_mangle]
pub extern fn fibo(n: u32) -> u32 {
  if n <= 1 { return 1 }
  fibo(n - 1) + fibo(n - 2)
}

#[start]
pub fn main(_i: isize, _n: *const *const u8) -> isize {
  println!("{}", _i);
  let number = env::args().last().unwrap_or("2".to_string()).parse().unwrap_or(2);
  let result = fibo(number);
  println!("{}", result);
  0
}