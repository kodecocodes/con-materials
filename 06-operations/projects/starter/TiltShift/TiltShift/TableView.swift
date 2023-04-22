import SwiftUI

struct TableView: View {
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
