import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public typealias HTTPFetchRequest = AnyFetchRequest<HTTPTransport.Response, DataFetchError>
public typealias JSONFetchRequest<Response: Decodable> = AnyFetchRequest<Response, DataFetchError>

public final class NetworkService {

  public init(baseURL: String,
              transport: HTTPTransport = URLSession.shared) {
    self.baseURL = baseURL
    self.transport = transport
  }

  let baseURL: String
  let transport: HTTPTransport

  public func request(_ location: @autoclosure () -> HTTPLocation,
                      config: RequestConfig = RequestConfig()) -> HTTPFetchRequest {
    LocationFetchRequest(fetcher: self, location: location(), config: config).eraseToAny()
  }

  public func request<Object: Decodable>(_ location: @autoclosure () -> HTTPLocation,
                                         config: RequestConfig = RequestConfig(),
                                         decode object: Object.Type,
                                         decoder: JSONDecoder = HTTP.defaultDecoder) -> JSONFetchRequest<Object> {
    request(location(), config: config).decode(object: object, decoder: decoder)
  }
}

extension NetworkService: LocationRequestFetcher {
  @discardableResult
  func execute(with location: HTTPLocation,
               config: RequestConfig,
               completion: @escaping (HTTPTransport.Result) -> Void)
  -> Cancellable {
    let fail: () -> Cancellable = {
      completion(.failure(.badRequest))
      return EmptyCancellable()
    }

    guard var components = URLComponents(string: baseURL) else {
      return fail()
    }
    components.path = location.urlPath
    components.queryItems = location.queryItems
      .map(URLQueryItem.init(name:value:))
    guard let url = components.url else { return fail() }
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = location.method.rawValue
    urlRequest.httpBody = location.body.data
    urlRequest.allHTTPHeaderFields = location.httpHeaders
    config.apply(to: &urlRequest)
    return transport.obtain(request: urlRequest, completion: completion)
  }
}
