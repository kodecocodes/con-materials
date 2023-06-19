import SwiftUI

struct ContentView: View {
  @State private var counter = 0

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
    let queue = DispatchQueue(label: "q")

    var count = 0

    queue.async {
      for _ in 1...100_000 {
        // Thread.sleep(forTimeInterval: 0.1)
        count += 1
      }
    }

    DispatchQueue.main.async {
      for _ in 1...100_000 {
        count += 1
      }

      counter = count
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
