import SwiftUI

typealias ImageOperationCompletion = ((Data?, URLResponse?, Error?) -> Void)?

final class NetworkImageOperation: AsyncOperation {
  var image: Image?

  private let url: URL
  private let completion: ImageOperationCompletion

  init(url: URL,completion: ImageOperationCompletion = nil) {
    self.url = url
    self.completion = completion

    super.init()
  }

  convenience init?(string: String, completion: ImageOperationCompletion = nil) {
    guard let url = URL(string: string) else { return nil }
    self.init(url: url, completion: completion)
  }

  override func main() {
    URLSession.shared.dataTask(with: url) {
      [weak self] data, response, error in

      guard let self else { return }

      defer { self.state = .finished }

      if let completion = self.completion {
        completion(data, response, error)
        return
      }

      guard
        error == nil,
        let data = data,
        let uiImage = UIImage(data: data)
      else {
        return

      }

      self.image = Image(uiImage: uiImage)
    }.resume()
  }
}
