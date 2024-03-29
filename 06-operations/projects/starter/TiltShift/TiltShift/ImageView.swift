import SwiftUI

struct ImageView: View {
  @State private var image = Image(systemName: "photo")
  let rowNumber: Int

  var body: some View {
    image
      .resizable()
      .frame(width: 293, height: 293)
      .task {
        tiltShiftImage()
      }
  }

  private func tiltShiftImage() {

  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(rowNumber: Int.random(in: 0 ..< 10))
  }
}
