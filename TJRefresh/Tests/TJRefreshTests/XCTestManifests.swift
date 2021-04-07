import XCTest

#if !canImport(ObjectiveC)
func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(TJRefreshTests.allTests),
    ]
}
#endif
