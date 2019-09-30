compile:
	g++ fibo/fibo.cpp -o fibo_cpp.exe
	rustc fibo/fibo.rs -o fibo_rust.exe

clean:
	rm -rf fibo_*.exe
