import SwiftUI

struct ImageView: View {
  let rowNumber: Int
  @State private var image = Image(systemName: "photo")

  var body: some View {
    image
      .resizable()
      .frame(width: 293, height: 293)
      .task {
        tiltShiftImage()
      }
  }

  private func tiltShiftImage() {
    let uiImage = UIImage(named: "\(rowNumber).png")!

    print("Filtering row \(rowNumber + 1)")

    let op = TiltShiftOperation(for: uiImage)
    op.start()

    if let outputImage = op.outputImage {
      image = Image(uiImage: outputImage)
    }

    print("Done")
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(rowNumber: Int.random(in: 0 ..< 10))
  }
}
