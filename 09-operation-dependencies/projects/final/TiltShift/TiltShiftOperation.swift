import SwiftUI

final class TiltShiftOperation: Operation {
  /// Callback which will be run *on the main thread*
  /// when the operation completes.
  var onImageProcessed: ((UIImage?) -> Void)?

  private static let context = CIContext()

  var outputImage: UIImage?

  private let inputImage: UIImage?

  init(image: UIImage? = nil) {
    inputImage = image
    super.init()
  }

  override func main() {
    let dependencyImage = dependencies
      .compactMap { ($0 as? ImageDataProvider)?.image }
      .first

    guard
      let inputImage = inputImage ?? dependencyImage,
      let filter = TiltShiftFilter(image: inputImage, radius: 3),
      let output = filter.outputImage
    else {
      return
    }

    let fromRect = CGRect(origin: .zero, size: inputImage.size)
    guard let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect) else {
      print("No image generated")
      return
    }

    outputImage = UIImage(cgImage: cgImage)

    if let onImageProcessed {
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        onImageProcessed(outputImage)
      }
    }
  }
}

extension TiltShiftOperation: ImageDataProvider {
  var image: UIImage? { return outputImage }
}
