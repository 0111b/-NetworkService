import XCTest
@testable import NetworkService

final class NetworkService: XCTestCase {

    func testFoo() throws {
      let config  = RequestConfig().allowsCellularAccess(true)
      XCTAssertEqual(config.updates.count, 1)
    }
}
