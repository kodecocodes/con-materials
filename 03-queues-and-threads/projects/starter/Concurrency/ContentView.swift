import SwiftUI

struct ContentView: View {
  @State private var imageDetails: [ImageDetail] = []
  private let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(imageDetails, id: \.self) {
          Cell(url: $0.url)
        }
      }
    }
    .padding()
    .edgesIgnoringSafeArea(.bottom)
    .task { loadImageDetails() }
  }

  private func loadImageDetails() {
    guard let plist = Bundle.main.url(forResource: "Photos", withExtension: "plist"),
          let contents = try? Data(contentsOf: plist),
          let serial = try? PropertyListSerialization.propertyList(from: contents, format: nil),
          let serialUrls = serial as? [String] else {
      print("Something went horribly wrong!")
      return
    }

    imageDetails = serialUrls.compactMap {
      guard let url = URL(string: $0) else {
        return nil
      }

      return ImageDetail(url: url)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

