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
import CoreData

final class MainViewController: UIViewController {
  private let passActualObject = false

  @IBOutlet private weak var textField: UITextField!
  @IBOutlet private weak var progressView: UIProgressView!
  @IBOutlet private weak var label: UILabel!

  private let ws = CharacterSet.whitespacesAndNewlines
  private let formatter = NumberFormatter()

  var managedObjectContext: NSManagedObjectContext!

  private func doItTheRightWay(note: Notification) {
    guard let objectId = note.userInfo?["objectID"] as? NSManagedObjectID else {
        return
    }

    managedObjectContext.perform {
      guard let entity = self.managedObjectContext.object(with: objectId) as? Number else { return }

      let display = entity.display

      DispatchQueue.main.async {
        self.label.isHidden = false
        self.label.text = display
      }
    }
  }

  private func doItTheWrongWay(note: Notification) {
    guard let entity = note.userInfo?["object"] as? Number else {
      return
    }

    managedObjectContext.perform {
      let display = entity.display

      DispatchQueue.main.async {
        self.label.isHidden = false
        self.label.text = display
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.formatter.numberStyle = .spellOut

    let callback = passActualObject ? doItTheWrongWay : doItTheRightWay
    Notification.Name.coreDataEntity.onPost(using: callback)
  }

  @IBAction private func onCreateTapped() {
    guard let text = self.textField.text?.trimmingCharacters(in: self.ws),
      text.count > 0,
      let max = Int32(text),
      max > 0 else {
        let message = "Please enter a number between 1 and \(Int32.max)"
        UIAlertController.ok(withMessage: message, presentingViewController: self)

        return
    }

    self.progressView.progress = 0
    self.progressView.isHidden = false

    let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    childContext.parent = managedObjectContext

    childContext.perform { [weak self] in
      guard let self = self else { return }

      let deleteRequest = NSBatchDeleteRequest(fetchRequest: Number.fetchRequest())
      _ = try? childContext.execute(deleteRequest)

      for num in 1...max {
        let entity = Number(context: childContext)
        entity.value = num
        entity.display = self.formatter.string(from: NSNumber(value: num))

        DispatchQueue.main.async {
          self.progressView.progress = Float(num) / Float(max)
        }
      }
      
      do {
        try childContext.save()
      } catch {
        DispatchQueue.main.async {
          UIAlertController.ok(withMessage: "Failed to save core data")
        }
        return
      }

      DispatchQueue.main.async {
        self.progressView.isHidden = true
      }

      let random = Int.random(in: 1...Int(max))

      let fetchRequest: NSFetchRequest<Number> = Number.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "%K == %d", #keyPath(Number.value), random)

      guard let entities = try? childContext.fetch(fetchRequest),
        let entity = entities.first else {
          DispatchQueue.main.async {
            UIAlertController.ok(withMessage: "Failed to retrieve core data object")
          }

          return
      }

      var userInfo: [String: Any] = [:]

      if self.passActualObject {
        userInfo["object"] = entity
      } else {
        userInfo["objectID"] = entity.objectID
      }
      
      Notification.Name.coreDataEntity.post(userInfo: userInfo)
    }
  }
}

