import SwiftUI

struct ImageView: View {
  let url: URL
  let queue: OperationQueue

  @State private var image = Image(systemName: "photo")
  @State private var operations: [Operation] = []

  var body: some View {
    image
      .resizable()
      .aspectRatio(contentMode: .fit)
      .task {
        tiltShiftImage()
      }
      .onDisappear {
        operations.forEach { $0.cancel() }
      }
  }

  init(in queue: OperationQueue, for url: URL) {
    self.url = url
    self.queue = queue
  }

  private func tiltShiftImage() {
    let downloadOp = NetworkImageOperation(url: url)
    let tiltShiftOp = TiltShiftOperation()
    tiltShiftOp.addDependency(downloadOp)

    operations = [downloadOp, tiltShiftOp]
    tiltShiftOp.onImageProcessed = { uiImage in
      if let uiImage {
        image = Image(uiImage: uiImage)
      }
    }

    queue.addOperation(downloadOp)
    queue.addOperation(tiltShiftOp)
  }
}

struct ImageView_Previews: PreviewProvider {
  static var previews: some View {
    ImageView(in: OperationQueue(), for: URL(string: "https://wolverine.raywenderlich.com/books/con/image-from-rawpixel-id-466780-jpeg.jpg")!)
  }
}
