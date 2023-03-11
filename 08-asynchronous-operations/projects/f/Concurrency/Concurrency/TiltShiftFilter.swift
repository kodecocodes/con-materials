/// Copyright (c) 2019 Razeware LLC
/// 
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
/// 
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
/// 
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
/// 
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

/*
 * Filters setup as per Apple's instructions here:
 * https://developer.apple.com/library/archive/documentation/GraphicsImaging/Conceptual/CoreImaging/ci_filer_recipes/ci_filter_recipes.html#//apple_ref/doc/uid/TP30001185-CH4-SW17
 */

import UIKit
import CoreGraphics

public class TiltShiftFilter: CIFilter {
  private static let defaultRadius = 10.0

  public var inputImage: CIImage?
  public var inputRadius: Double = defaultRadius

  override public var name: String {
    get { return "TiltShiftFilter" }
    set { }
  }

  override public func setDefaults() {
    super.setDefaults()
    inputRadius = TiltShiftFilter.defaultRadius
  }

  override public var inputKeys: [String] {
    get { return [kCIInputImageKey, kCIInputRadiusKey] }
  }

  private func ciImage(from filterName: String, parameters: [String: Any]) -> CIImage? {
    guard let filtered = CIFilter(name: filterName, parameters: parameters) else {
      return nil
    }

    return filtered.outputImage
  }

  override public var outputImage: CIImage? {
    guard let inputImage = inputImage else {
      return nil
    }

    let clamped = inputImage.clampedToExtent()
    let blurredImage = clamped.applyingGaussianBlur(sigma: inputRadius)

    var gradientParameters = [
      "inputPoint0": CIVector(x: 0, y: 0.75 * inputImage.extent.height),
      "inputColor0": CIColor(red: 0, green: 1, blue: 0, alpha: 1),
      "inputPoint1": CIVector(x: 0, y: 0.5 * inputImage.extent.height),
      "inputColor1": CIColor(red: 0, green: 1, blue: 0, alpha: 0)
    ];

    guard let gradientImage = ciImage(from: "CILinearGradient", parameters: gradientParameters) else {
      return nil
    }

    gradientParameters["inputPoint0"] = CIVector(x: 0, y: 0.25 * inputImage.extent.height)

    guard let backgroundGradientImage = ciImage(from: "CILinearGradient", parameters: gradientParameters) else {
      return nil
    }

    let maskParameters = [
      kCIInputImageKey: gradientImage,
      kCIInputBackgroundImageKey: backgroundGradientImage
    ]

    guard let maskImage = ciImage(from: "CIAdditionCompositing", parameters: maskParameters) else {
      return nil
    }

    let combinedParameters = [
      kCIInputImageKey: blurredImage,
      kCIInputBackgroundImageKey: clamped,
      kCIInputMaskImageKey: maskImage
    ]

    return ciImage(from: "CIBlendWithMask", parameters: combinedParameters)
  }

  convenience init?(image: UIImage, radius: Double = TiltShiftFilter.defaultRadius) {
    guard let backing = image.ciImage ?? CIImage(image: image) else {
      return nil
    }

    self.init()

    inputImage = backing
    inputRadius = radius
  }
}
