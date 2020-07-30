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

import UIKit

extension UIAlertController {
  private static func createAlert(withMessage message: String, showCancelButton: Bool, presentingViewController: UIViewController? = nil, completion: (() -> Void)? = nil) {
    guard let presentingViewController = presentingViewController ?? UIApplication.shared.keyWindow?.rootViewController else { return }

    let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
    alert.addOKButton()
    if showCancelButton {
      alert.addCancelButton()
    }

    presentingViewController.present(alert, animated: true, completion: completion)
  }

  /// Presents an alert dialog with an OK button and no title.
  ///
  /// - Parameters:
  ///   - message: The message which you wish to display.
  ///   - presentingViewController: The UIViewController which should present the alert dialog.
  ///   - completion: The optional completion handler to call once the alert has been presented.
  static func ok(withMessage message: String, presentingViewController: UIViewController? = nil, completion: (() -> Void)? = nil) {
    createAlert(withMessage: message, showCancelButton: false, presentingViewController: presentingViewController, completion: completion)
  }

  /// Presents an alert dialog with both an OK and a Cancel button.
  ///
  /// - Parameters:
  ///   - message: The message which you wish to display.
  ///   - presentingViewController: The UIViewController which should present the alert dialog.
  ///   - completion: The optional completion handler to call once the alert has been presented.
  static func cancel(withMessage message: String, presentingViewController: UIViewController? = nil, completion: (() -> Void)? = nil) {
    createAlert(withMessage: message, showCancelButton: true, presentingViewController: presentingViewController, completion: completion)
  }

  /// Adds a cancel button to the alert controller.
  ///
  /// - Parameter handler: A block to execute when the user presses the cancel button.
  func addCancelButton(_ handler: ((UIAlertAction?) -> Void)? = nil) {
    let cancel = NSLocalizedString("Cancel", comment: "The cancel button")
    addAction(UIAlertAction(title: cancel, style: .cancel, handler: handler))
  }

  /// Adds an OK button to the alert controller.
  ///
  /// - Parameter handler: A block to execute when the user presses the OK button.
  func addOKButton(_ handler: ((UIAlertAction?) -> Void)? = nil) {
    let ok = NSLocalizedString("OK", comment: "The OK button")
    addAction(UIAlertAction(title: ok, style: .default, handler: handler))
  }
}

