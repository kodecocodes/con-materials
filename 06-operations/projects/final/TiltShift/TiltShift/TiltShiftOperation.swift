//
//  TiltShiftOperation.swift
//  TiltShift
//
//  Created by Marin Bencevic on 05.06.2023..
//  Copyright © 2023 Kodeco, Inc. All rights reserved.
//

import Foundation
import SwiftUI

final class TiltShiftOperation: Operation {
  private static let context = CIContext()
  var outputImage: UIImage?

  private let inputImage: UIImage

  init(image: UIImage) {
    inputImage = image
    super.init()
  }

  override func main() {
    guard
      let filter = TiltShiftFilter(image: inputImage, radius: 3),
      let output = filter.outputImage
    else {
      print("Failed to generate tilt shift image")
      return
    }

    let fromRect = CGRect(origin: .zero, size: inputImage.size)
    guard let cgImage = TiltShiftOperation.context.createCGImage(output, from: fromRect) else {
      print("No image generated")
      return
    }

    outputImage = UIImage(cgImage: cgImage)
  }
}


