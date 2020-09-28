import Foundation

public final class HTTPLocation {
  var urlPath: String
  var method: HTTP.Method
  var queryItems: HTTP.QueryItems
  var body: HTTP.Body
  var httpHeaders: HTTP.Headers

  public init(urlPath: String,
              method: HTTP.Method = .get,
              queryItems: HTTP.QueryItems = [:],
              body: HTTP.Body = .empty,
              httpHeaders: HTTP.Headers? = nil) {
    self.urlPath = urlPath
    self.method = method
    self.queryItems = queryItems
    self.body = body
    self.httpHeaders = httpHeaders ?? [:]
  }

  public func auth(token: String) -> Self {
    httpHeaders["Authorization"] = "Bearer \(token)"
    return self
  }

  public func accept(_ contentType: ContentType) -> Self {
    httpHeaders["Accept"] = contentType.rawValue
    return self
  }

  public func contenType(_ contentType: ContentType) -> Self {
    httpHeaders["Content-Type"] = contentType.rawValue
    return self
  }

  public func WWWForm(values: [String: Any]) -> Self {
    method = .post
    body = .form(values)
    return self.contenType(.wwwForm)
  }

  public enum ContentType: String {
    case json = "application/json"
    case wwwForm = "application/x-www-form-urlencoded;charset=UTF-8"
  }
}
