import SwiftUI

struct TableView: View {
  @State private var urls: [URL] = []

  private let queue = OperationQueue()
  private let columns = [GridItem(.flexible())]

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(urls, id: \.self) { url in
          ImageView(in: queue, for: url)
            .padding()
        }
      }
    }
    .task { 
      loadPhotoUrls()
    }
  }

  private func loadPhotoUrls() {
    guard
      let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
      let contents = try? Data(contentsOf: plist),
      let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
      let serialUrls = serial as? [String]
    else {
      print("Something went horribly wrong!")
      return
    }

    urls = serialUrls.compactMap(URL.init)
  }
}

struct TableView_Previews: PreviewProvider {
  static var previews: some View {
    TableView()
  }
}
