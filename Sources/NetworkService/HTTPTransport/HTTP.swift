import Foundation

public enum HTTP {

  public static var defaultDecoder: JSONDecoder {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
  }

  /// HTTP method definitions.
  ///
  /// See [spec](https://tools.ietf.org/html/rfc7231#section-4.3)
  public enum Method: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
  }

  public typealias QueryItems = [String: String]
  public typealias Headers = [String: String]

  public enum Body {
    case empty
    case data(Data)
    case string(String)
    case form([String: Any])

    public var data: Data? {
      switch self {
      case .empty: return nil
      case .data(let data): return data
      case .string(let string): return string.data(using: .utf8)
      case .form(let params): return params
        .compactMap { key, value in
          guard let key = Body.urlEncode(key),
                let value = Body.urlEncode("\(value)")
          else { return nil }
          return "\(key)=\(value)" }
        .joined(separator: "&")
        .data(using: .utf8)
      }
    }

    static func urlEncode(_ string: String) -> String? {
      string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
    }
  }

}
