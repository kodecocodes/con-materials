import SwiftUI

struct Cell: View {
  let url: URL
  @State private var image = Image(systemName: "photo")

  var body: some View {
    image
      .resizable()
      .frame(width: 100, height: 100)
      .task {
        download()
      }
  }

  private func download() {
    guard
      let data = try? Data(contentsOf: url),
      let uiImage = UIImage(data: data)
    else {
      return
    }

    image = Image(uiImage: uiImage)
  }
}
