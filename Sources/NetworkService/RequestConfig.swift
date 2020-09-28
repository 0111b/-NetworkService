import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public final class RequestConfig {
  typealias Update = (inout URLRequest) -> Void

  var updates = [Update]()

  func append(_ update: @escaping Update) -> Self {
    updates.append(update)
    return self
  }

  func apply(to request: inout URLRequest) {
    updates.forEach { update in
      update(&request)
    }
  }

  // MARK: - Public

  public init() {}

  #if !os(Linux)
  public func allowsExpensiveNetworkAccess(_ value: Bool) -> Self {
    append { $0.allowsExpensiveNetworkAccess = value }
  }

  public func allowsConstrainedNetworkAccess(_ value: Bool) -> Self {
    append { $0.allowsConstrainedNetworkAccess = value }
  }
  #endif

  public func allowsCellularAccess(_ value: Bool) -> Self {
    append { $0.allowsCellularAccess = value }
  }

  public func cachePolicy(_ value: URLRequest.CachePolicy) -> Self {
    append { $0.cachePolicy = value }
  }

  public func timeoutInterval(_ value: TimeInterval) -> Self {
    append { $0.timeoutInterval = value }
  }

  public func networkServiceType(_ value: URLRequest.NetworkServiceType) -> Self {
    append { $0.networkServiceType = value }
  }

  public func httpShouldHandleCookies(_ value: Bool) -> Self {
    append { $0.httpShouldHandleCookies = value }
  }
  public func httpShouldUsePipelining(_ value: Bool) -> Self {
    append { $0.httpShouldUsePipelining = value }
  }

}
