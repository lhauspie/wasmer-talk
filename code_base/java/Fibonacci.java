public class Fibonacci {

    public static void main(final String... args) {
        System.out.println(fibo(Integer.parseInt(args[0])));
    }

    public static int fibo(final int i) {
        if (i <= 1) {
            return 1;
        }
        return fibo(i - 1) + fibo(i - 2);
    }

}