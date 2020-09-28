import XCTest
@testable import NetworkService

final class HTTPLocationTests: XCTestCase {
  
  var location: HTTPLocation!
  
  override func setUpWithError() throws {
    location = HTTPLocation(urlPath: "/")
  }
  
  func testAuth() {
    _ = location.auth(token: "token")
    XCTAssertEqual(location.httpHeaders["Authorization"], "Bearer token")
  }

  func testAccept() {
    _ = location.accept(.json)
    XCTAssertEqual(location.httpHeaders["Accept"], "application/json")
  }

  func testContentType() {
    _ = location.contenType(.json)
    XCTAssertEqual(location.httpHeaders["Content-Type"], "application/json")
  }

  func testWWWForm() {
    _ = location.WWWForm(values: ["key": "value"])
    XCTAssertEqual(location.method, .post)
    XCTAssertEqual(location.httpHeaders["Content-Type"], "application/x-www-form-urlencoded;charset=UTF-8")
    if case let .form(values) = location.body {
      XCTAssertEqual(values as? [String: String], ["key": "value"])
    } else {
      XCTFail("Invalid body \(location.body)")
    }
  }
}
