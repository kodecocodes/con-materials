import SwiftUI

struct TableView: View {
  var body: some View {
    List {
      ForEach(0 ..< 10) { rowNumber in
        ImageView(rowNumber: rowNumber)
          .padding()
      }
    }.listStyle(.plain)
  }
}

struct TableView_Previews: PreviewProvider {
  static var previews: some View {
    TableView()
  }
}
