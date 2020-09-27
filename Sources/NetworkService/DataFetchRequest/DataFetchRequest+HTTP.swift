import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension DataFetchRequest where FetchData == HTTPTransport.Response, FetchError == DataFetchError {
  public func decode<Object>(object: Object.Type, decoder: JSONDecoder = HTTP.defaultDecoder) -> AnyFetchRequest<Query, Object, FetchError>
  where Object: Decodable {
    let decode: (HTTPTransport.Response) -> Result<Object, FetchError> = { response in
      decoder.decode(object: Object.self, from: response.data)
    }
    return flatMap(decode)
  }

  public func check(statusCode validate: @escaping (Int) -> Bool) -> AnyFetchRequest<Query, FetchData, FetchError> {
    flatMap { value in
      validate(value.response.statusCode) ? .success(value) : .failure(.invalidStatusCode)
    }
  }
}
