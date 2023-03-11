import SwiftUI

struct TableView: View {
  @State private var images = Array(repeating: Image(systemName: "photo"), count: 10)
  private let queue = OperationQueue()
  private let columns = [GridItem(.flexible())]

  var body: some View {
    ScrollView {
      LazyVGrid(columns: columns) {
        ForEach(0 ..< 10) { rowNumber in
          ImageView(for: rowNumber, in: queue)
            .padding()
        }
      }
    }
  }
}

struct TableView_Previews: PreviewProvider {
  static var previews: some View {
    TableView()
  }
}
