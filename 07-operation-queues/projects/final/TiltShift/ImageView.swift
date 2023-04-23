import SwiftUI

struct ImageView: View {
  let rowNumber: Int
  let queue: OperationQueue
  @State private var image = Image(systemName: "photo")

  init(in queue: OperationQueue, for rowNumber: Int) {
    self.rowNumber = rowNumber
    self.queue = queue
  }

  var body: some View {
    ZStack {
      image
        .resizable()
        .frame(width: 293, height: 293)
        .task {
          tiltShiftImage()
        }
    }
  }

  private func tiltShiftImage() {
    print("Filtering")
    let op = TiltShiftOperation(image: UIImage(named: "\(rowNumber).png")!)

    op.completionBlock = {
      if let outputImage = op.outputImage {
        DispatchQueue.main.async {
          print("Updating image")
          image = Image(uiImage: outputImage)
        }
      }
    }

    queue.addOperation(op)
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(in: OperationQueue(), for: Int.random(in: 0 ..< 10))
  }
}
