import SwiftUI

struct Cell: View {
  let url: URL
  @State private var image = Image(systemName: "photo")

  var body: some View {
    image
      .resizable()
      .frame(width: 100, height: 100)
      .task {
        downloadWithGlobalQueue()
      }
  }

  private func downloadWithUrlSession() {
    URLSession.shared.dataTask(with: url) { data, _, _ in
      guard let data, let uiImage = UIImage(data: data) else {
        return
      }

      DispatchQueue.main.async {
        image = Image(uiImage: uiImage)
      }
    }
    .resume()
  }

  private func downloadWithGlobalQueue() {
    DispatchQueue.global(qos: .utility).async {
      guard
        let data = try? Data(contentsOf: url),
        let uiImage = UIImage(data: data) else {
        return
      }

      DispatchQueue.main.async {
        image = Image(uiImage: uiImage)
      }
    }
  }
}
