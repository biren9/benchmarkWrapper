import XCTest

import BenchmarkWrapperTests

var tests = [XCTestCaseEntry]()
tests += BenchmarkWrapperTests.allTests()
XCTMain(tests)
