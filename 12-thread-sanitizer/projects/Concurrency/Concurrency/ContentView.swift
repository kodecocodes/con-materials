import SwiftUI

struct ContentView: View {
  @State private var counter = 0

  @State private var lazyName = "Foo bar"

  var body: some View {
    VStack {
      Text("HI")
    }
    .padding()
    .task {
      count()
    }
  }

  private func count() {
    DispatchQueue.global().async {
      lazyName = "blob"
    }

    print(lazyName)
    print("Counting")
    let queue = DispatchQueue(label: "q")

    queue.async {
      print("Queue start")
      for _ in 1 ... 100_000 {
        // Thread.sleep(forTimeInterval: 0.1)
        counter += 1
      }

      print("queue done")
    }

    DispatchQueue.main.async {
      print("Main start")
      for _ in 1 ... 100_000 {
        counter += 1
      }

      print("Main done")
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
