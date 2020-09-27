import Foundation

struct LocationFetchRequest: DataFetchRequest {
  typealias FetchData = HTTPTransport.Response
  typealias FetchError = DataFetchError

  let fetcher: NetworkRequestFetcher
  let location: HTTPLocation

  func run(completion: @escaping FetchCompletion) -> Cancellable {
    fetcher.execute(with: location, completion: completion)
  }
}

protocol NetworkRequestFetcher {
  @discardableResult
  func execute(with location: HTTPLocation,
               completion: @escaping (HTTPTransport.Result) -> Void)
  -> Cancellable
}
