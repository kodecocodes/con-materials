import SwiftUI
import CoreData

struct ContentView: View {
  @State private var count = "100000"
  @State private var display = ""
  @State private var alert: AlertMessage? = nil
  @State private var progress = 0.0
  @Environment(\.managedObjectContext) private var viewContext

  private let passActualObject = true
  private let formatter = NumberFormatter()

  var body: some View {
    VStack {
      HStack {
        Text("Items to create")
        TextField("", text: $count)
          .keyboardType(.numberPad)
          .border(.secondary)
      }

      if progress > 0 {
        ProgressView(value: progress)
      }

      Button("Generate", action: onGenerateTapped)

      Text(display)
    }
    .padding()
    .alert(item: $alert) { message in
      Alert(title: Text(message.message), dismissButton: .cancel())
    }
    .task {
      formatter.numberStyle = .spellOut

      let callback = passActualObject ? doItTheWrongWay : doItTheRightWay
      Notification.Name.coreDataEntity.onPost(using: callback)
    }
  }

  private func doItTheWrongWay(note: Notification) {
    guard let entity = note.userInfo?["object"] as? Number else {
      return
    }

    viewContext.perform {
      let message = entity.display ?? "This would crash."

      DispatchQueue.main.async {
        display = message
      }
    }
  }

  private func doItTheRightWay(note: Notification) {
    guard let objectId = note.userInfo?["objectID"] as? NSManagedObjectID else {
      return
    }

    viewContext.perform {
      guard
        let entity = viewContext.object(with: objectId) as? Number,
        let displayMessage = entity.display
      else {
        return
      }

      DispatchQueue.main.async {
        display = displayMessage
      }
    }
  }

  private func onGenerateTapped() {
    let text = count.trimmingCharacters(in: .whitespaces)

    guard !text.isEmpty, let max = Int32(text), max > 0 else {
      alert = AlertMessage(message: "Please enter a positive integer value.")
      return
    }

    PersistenceController.shared.container.performBackgroundTask { context in
      let deleteRequest = NSBatchDeleteRequest(fetchRequest: Number.fetchRequest())
      _ = try? context.execute(deleteRequest)

      for num in 1...max {
        let entity = Number(context: context)
        entity.value = num
        entity.display = formatter.string(from: NSNumber(value: num))

        DispatchQueue.main.async {
          progress = Double(num) / Double(max)
        }
      }

      do {
        try context.save()
      } catch {
        DispatchQueue.main.async {
          alert = AlertMessage(message: "Failed to save core data.")
        }

        return
      }

      DispatchQueue.main.async {
        progress = 0
      }

      let random = Int.random(in: 1 ... Int(max))

      let request = Number.fetchRequest()
      request.predicate = NSPredicate(format: "%K == %d", #keyPath(Number.value), random)
      request.fetchLimit = 1

      guard
        let entities = try? context.fetch(request),
        let entity = entities.first
      else {
        DispatchQueue.main.async {
          alert = AlertMessage(message: "Failed to retrieve core data object")
        }

        return
      }

      var userInfo: [String: Any] = [:]

      if passActualObject {
        userInfo["object"] = entity
      } else {
        userInfo["objectID"] = entity.objectID
      }

      Notification.Name.coreDataEntity.post(userInfo: userInfo)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
