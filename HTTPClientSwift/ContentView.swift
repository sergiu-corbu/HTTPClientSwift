//
//  ContentView.swift
//  HTTPClientSwift
//
//  Created by Sergiu Corbu
//

import SwiftUI

//Usage Example

class ViewModel: ObservableObject {
  
  private let client: HTTPClient
  
  init() {
    self.client = HTTPClient(configuration: DefaultClientConfiguration(serverURL: URL(string: "your-url-path")!))
  }
  
  func testMethod() async {
    let parameters: [String: Any] = ["id": UUID().uuidString] // other properties
    let request = HTTPRequest(method: .post, path: "path/feature", bodyParameters: parameters, decodingKeyPath: "user")
    
    do {
      let _ = try await client.sendRequest(request)
      // ...
    } catch {
      print(error.localizedDescription)
    }
  }
}

struct ContentView: View {
  
  
  @StateObject private var viewModel = ViewModel()
  
  var body: some View {
    VStack {
      Button(action: {
        Task {
          await viewModel.testMethod()
        }
      }, label: {
        Text("Execute test method")
      })
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
