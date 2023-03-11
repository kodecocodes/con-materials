import SwiftUI

struct TableView: View {
  @State private var images = Array(repeating: Image(systemName: "photo"), count: 10)

  var body: some View {
    ScrollView {
      ForEach(0 ..< 10) { rowNumber in
        ImageView(rowNumber: rowNumber)
          .padding()
      }
    }
  }
}

struct TableView_Previews: PreviewProvider {
  static var previews: some View {
    TableView()
  }
}
