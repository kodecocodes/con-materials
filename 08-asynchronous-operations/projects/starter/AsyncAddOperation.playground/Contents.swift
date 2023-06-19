/// Copyright (c) 2023 Kodeco, Inc.
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
/// This project and source code may use libraries or frameworks that are
/// released under various Open-Source licenses. Use of those libraries and
/// frameworks are governed by their own individual licenses.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class AsyncOperation: Operation {

}
/*:
 AsyncSumOperation simply adds two numbers together asynchronously and assigns the result. It sleeps for two seconds just so that you can
 see the random ordering of the operation.  Nothing guarantees that an operation will complete in the order it was added.

 - important:
 Notice that `self.state` is being set to `.finished`. What would happen if you left this line out?
 */
class AsyncSumOperation: AsyncOperation {
  let rhs: Int
  let lhs: Int
  var result: Int?

  init(lhs: Int, rhs: Int) {
    self.lhs = lhs
    self.rhs = rhs

    super.init()
  }

  override func main() {
    DispatchQueue.global().async {
      Thread.sleep(forTimeInterval: 2)
      self.result = self.lhs + self.rhs
      self.state = .finished
    }
  }
}

//: Now that you've got an `AsyncOperation` base class and a `AsyncSumOperation` subclass, run it through a small test.
let queue = OperationQueue()
let pairs = [(2, 3), (5, 3), (1, 7), (12, 34), (99, 99)]

pairs.forEach { pair in
  let op = AsyncSumOperation(lhs: pair.0, rhs: pair.1)
  op.completionBlock = {
    guard let result = op.result else { return }
    print("\(pair.0) + \(pair.1) = \(result)")
  }

  queue.addOperation(op)
}

//: This prevents the playground from finishing prematurely.  Never do this on a main UI thread!
queue.waitUntilAllOperationsAreFinished()
