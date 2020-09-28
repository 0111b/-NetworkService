import Foundation

struct LocationFetchRequest: DataFetchRequest {
  typealias FetchData = HTTPTransport.Response
  typealias FetchError = DataFetchError

  let fetcher: LocationRequestFetcher
  let location: HTTPLocation
  let config: RequestConfig

  func run(completion: @escaping FetchCompletion) -> Cancellable {
    fetcher.execute(with: location,
                    config: config,
                    completion: completion)
  }
}

protocol LocationRequestFetcher {
  @discardableResult
  func execute(with location: HTTPLocation,
               config: RequestConfig,
               completion: @escaping (HTTPTransport.Result) -> Void)
  -> Cancellable
}
