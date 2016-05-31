.PHONY: build
build:
	xcodebuild build -scheme "Coding Challenge 3" | xcpretty -c

bin/cc3:
	make build

.PHONY: challenges
challenges: bin/Challenge bin/Challenge42 bin/Challenge1000 bin/Challenge1234

bin/Challenge: bin/cc3 Test\ Files/Challenge.cc3
	bin/cc3 --compile "Test Files/Challenge.cc3"
	mv Challenge bin/

bin/Challenge42: bin/cc3 Test\ Files/Challenge42.cc3
	bin/cc3 --compile "Test Files/Challenge42.cc3"
	mv Challenge42 bin/

bin/Challenge1000: bin/cc3 Test\ Files/Challenge1000.cc3
	bin/cc3 --compile "Test Files/Challenge1000.cc3"
	mv Challenge1000 bin/

bin/Challenge1234: bin/cc3 Test\ Files/Challenge1234.cc3
	bin/cc3 --compile "Test Files/Challenge1234.cc3"
	mv Challenge1234 bin/

.PHONY: clean
clean:
	rm -rf bin/
