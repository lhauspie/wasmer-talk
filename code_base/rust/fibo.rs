fn fibo(n: u64) -> u64 {
  if n <= 1 { return 1 }
  fibo(n - 1) + fibo(n - 2)
}

fn main() {
  println!("{}", fibo(8));
}
