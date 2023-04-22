import SwiftUI

struct ImageView: View {
  let rowNumber: Int
  let queue: OperationQueue

  @State private var image = Image(systemName: "photo")

  var body: some View {
    image
      .resizable()
      .frame(width: 293, height: 293)
      .task {
        tiltShiftImage()
      }
  }

  init(for rowNumber: Int, in queue: OperationQueue) {
    self.rowNumber = rowNumber
    self.queue = queue
  }

  private func tiltShiftImage() {
    let uiImage = UIImage(named: "\(rowNumber).png")!
    let op = TiltShiftOperation(for: uiImage)

    op.completionBlock = {
      if let outputImage = op.outputImage {
        DispatchQueue.main.async {
          image = Image(uiImage: outputImage)
        }
      }
    }

    queue.addOperation(op)
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(for: Int.random(in: 0 ..< 10), in: OperationQueue())
  }
}
