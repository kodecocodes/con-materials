import Foundation

extension Notification.Name {
  static let coreDataEntity = Notification.Name("coreDataEntity")

  func post(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
    center.post(name: self, object: object, userInfo: userInfo)
  }

  @discardableResult
  func onPost(center: NotificationCenter = NotificationCenter.default, object: Any? = nil, queue: OperationQueue? = nil, using: @escaping (Notification) -> Void) -> NSObjectProtocol {
      return center.addObserver(forName: self, object: object, queue: queue, using: using)
  }
}
