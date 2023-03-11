import SwiftUI

struct ContentView: View {
  var body: some View {
    NavigationStack {
      NavigationLink("Show Tilt Shift") {
        ExampleView()
      }

      NavigationLink("Show Table") {

      }
      .padding()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
