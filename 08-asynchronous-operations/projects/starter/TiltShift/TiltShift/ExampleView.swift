import SwiftUI

struct ExampleView: View {
  @State private var working = true
  @State private var failed = false
  @State private var image: Image?

  var body: some View {
    VStack {
      Image("dark_road_small")
        .resizable()
        .frame(width: 293, height: 293)
        .padding()

      if let image {
        image
          .resizable()
          .frame(width: 293, height: 293)
      } else if working {
        ProgressView("Tilt shifting...")
      } else if failed {
        Text("Failed to generate tilt shift image.")
      }
    }
    .task {
      tiltShift()
    }
  }

  private func tiltShift() {
    let uiImage = UIImage(named: "dark_road_small")!

    guard let filter = TiltShiftFilter(image: uiImage, radius: 3),
      let output = filter.outputImage else {
        failed = true
        return
    }

    let context = CIContext()

    guard let cgImage = context.createCGImage(output, from: CGRect(origin: .zero, size: uiImage.size)) else {
      failed = true
      return
    }

    image = Image(uiImage: UIImage(cgImage: cgImage))
  }
}

struct ExampleView_Previews: PreviewProvider {
  static var previews: some View {
    ExampleView()
  }
}
