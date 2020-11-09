build:
	swift build

test:
	swift test

format:
	swift-format format -i -r Sources Tests


.PHONY: format build test
