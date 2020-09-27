import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public protocol URLRequestConvertible {
  var urlRequest: URLRequest { get }
}

public protocol Cancellable {
  func cancel()
}

public final class EmptyCancellable: Cancellable {
  public init() {}
  public func cancel() {}
}

public protocol HTTPTransport {
  typealias Response = (data: Data, response: HTTPURLResponse)
  typealias Result = Swift.Result<Response, DataFetchError>

  func obtain(request: URLRequestConvertible,
              completion: @escaping (HTTPTransport.Result) -> Void) -> Cancellable
}

extension HTTPTransport {
  public func obtain<Object>(request: URLRequestConvertible,
                             decode object: Object.Type,
                             decoder: JSONDecoder = HTTP.defaultDecoder,
                             completion: @escaping (Swift.Result<Object, DataFetchError>) -> Void) -> Cancellable
  where Object: Decodable {
    obtain(request: request) { result in
      switch result {
      case let .failure(error):
        completion(.failure(error))
      case let .success(ans):
        completion(decoder.decode(object: Object.self, from: ans.data))
      }
    }
  }
}
