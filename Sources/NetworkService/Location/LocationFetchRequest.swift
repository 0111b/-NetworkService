import Foundation

struct LocationFetchRequest: DataFetchRequest {
  typealias FetchData = HTTPTransport.Response
  typealias FetchError = DataFetchError

  let fetcher: LocationRequestFetcher
  let location: HTTPLocation
  let adapter: RequestAdapter

  func run(completion: @escaping FetchCompletion) -> Cancellable {
    fetcher.execute(with: location,
                    adapter: adapter,
                    completion: completion)
  }
}

protocol LocationRequestFetcher {
  @discardableResult
  func execute(with location: HTTPLocation,
               adapter: RequestAdapter,
               completion: @escaping (HTTPTransport.Result) -> Void)
  -> Cancellable
}
