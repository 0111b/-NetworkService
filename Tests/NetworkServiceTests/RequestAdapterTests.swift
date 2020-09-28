import XCTest
@testable import NetworkService

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

final class RequestAdapterTests: XCTestCase {
  var request: URLRequest!
  var config: RequestAdapter!

  override func setUpWithError() throws {
    request = URLRequest(url: URL(string: "http://google.com")!)
    config = RequestAdapter()
  }

  func testInitialState() {
    XCTAssertTrue(config.modifiers.isEmpty)
  }

  func testAppend() {
    _ = config.append({ _ in })
    XCTAssertEqual(config.modifiers.count, 1)
  }

  func testApply() {
    var isUpdateCalled = false
    _ = config.append({ _ in
      isUpdateCalled = true
    })
    config.apply(to: &request)
    XCTAssertTrue(isUpdateCalled)
  }

  #if !os(Linux)

  func testAllowsExpensiveNetworkAccess() {
    _ = config.allowsExpensiveNetworkAccess(true)
    config.apply(to: &request)
    XCTAssertEqual(request.allowsExpensiveNetworkAccess, true)
    _ = config.allowsExpensiveNetworkAccess(false)
    config.apply(to: &request)
    XCTAssertEqual(request.allowsExpensiveNetworkAccess, false)
  }

  func testAllowsConstrainedNetworkAccess() {
    _ = config.allowsConstrainedNetworkAccess(true)
    config.apply(to: &request)
    XCTAssertEqual(request.allowsConstrainedNetworkAccess, true)
    _ = config.allowsConstrainedNetworkAccess(false)
    config.apply(to: &request)
    XCTAssertEqual(request.allowsConstrainedNetworkAccess, false)
  }

  #endif

  func testAllowsCellularAccess() {
    _ = config.allowsCellularAccess(true)
    config.apply(to: &request)
    XCTAssertEqual(request.allowsCellularAccess, true)
    _ = config.allowsCellularAccess(false)
    config.apply(to: &request)
    XCTAssertEqual(request.allowsCellularAccess, false)
  }

  func testCachePolicy() {
    _ = config.cachePolicy(.returnCacheDataDontLoad)
    config.apply(to: &request)
    XCTAssertEqual(request.cachePolicy, .returnCacheDataDontLoad)
    _ = config.cachePolicy(.useProtocolCachePolicy)
    config.apply(to: &request)
    XCTAssertEqual(request.cachePolicy, .useProtocolCachePolicy)
  }

  func testTimeoutInterval() {
    _ = config.timeoutInterval(42)
    config.apply(to: &request)
    XCTAssertEqual(request.timeoutInterval, 42)
  }

  func testNetworkServiceType() {
    _ = config.networkServiceType(.video)
    config.apply(to: &request)
    XCTAssertEqual(request.networkServiceType, .video)
  }

  func testHttpShouldHandleCookies() {
    _ = config.httpShouldHandleCookies(true)
    config.apply(to: &request)
    XCTAssertEqual(request.httpShouldHandleCookies, true)
    _ = config.httpShouldHandleCookies(false)
    config.apply(to: &request)
    XCTAssertEqual(request.httpShouldHandleCookies, false)
  }

  func testHttpShouldUsePipelining() {
    _ = config.httpShouldUsePipelining(true)
    config.apply(to: &request)
    XCTAssertEqual(request.httpShouldUsePipelining, true)
    _ = config.httpShouldUsePipelining(false)
    config.apply(to: &request)
    XCTAssertEqual(request.httpShouldUsePipelining, false)
  }
}
