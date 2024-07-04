# Custom HTTPClient Documentation

## Overview
This documentation provides an overview of how to use the custom-made `HTTPClient` in your SwiftUI project. The `HTTPClient` simplifies making HTTP requests by providing a convenient and configurable interface.

## Installation

1. **Add HTTPClient to your project:**
   Include the `HTTPClient` and its related classes (`DefaultClientConfiguration`, `HTTPRequest`, etc.) in your project files.

2. **Import the necessary modules:**
   Make sure to import `SwiftUI` and any other required modules.

## Usage Example

The example below demonstrates how to use the custom `HTTPClient` within a SwiftUI `ViewModel` to perform an asynchronous HTTP POST request.

### ViewModel Implementation

```swift
import SwiftUI

class ViewModel: ObservableObject {
  
  private let client: HTTPClient
  
  init() {
    // Initialize the HTTPClient with the server URL
    self.client = HTTPClient(configuration: DefaultClientConfiguration(serverURL: URL(string: "your-url-path")!))
  }
  
  func testMethod() async {
    // Define the request parameters
    let parameters: [String: Any] = ["id": UUID().uuidString] // other properties
    
    // Create an HTTPRequest with method, path, body parameters, and decoding key path
    let request = HTTPRequest(method: .post, path: "path/feature", bodyParameters: parameters, decodingKeyPath: "user")
    
    do {
      // Send the request and handle the response
      let response = try await client.sendRequest(request)
      // Process the response as needed
    } catch {
      // Handle any errors
      print(error.localizedDescription)
    }
  }
}
```

### Key Components

#### HTTPClient

The `HTTPClient` class is responsible for sending HTTP requests and receiving responses. It is initialized with a configuration object that sets up the server URL and other necessary configurations.

#### DefaultClientConfiguration

This class holds the configuration details for the `HTTPClient`, including the server URL. You can customize it to include other configuration options as needed.

#### HTTPRequest

The `HTTPRequest` class encapsulates all the details of an HTTP request, including the HTTP method (e.g., GET, POST), the request path, body parameters, and the decoding key path for parsing the response.

### Detailed Steps

1. **Initialization:**
   - The `ViewModel` initializes the `HTTPClient` with a `DefaultClientConfiguration` that includes the server URL.

2. **Creating a Request:**
   - The `testMethod` function prepares a dictionary of parameters for the request body.
   - An `HTTPRequest` object is created with the required HTTP method, path, body parameters, and decoding key path.

3. **Sending the Request:**
   - The `client.sendRequest(request)` method is called to send the request asynchronously.
   - The response is handled within a `do-catch` block to manage any potential errors.

## Conclusion

This example demonstrates the basic setup and usage of a custom `HTTPClient` in a SwiftUI application. By following these steps, you can easily integrate HTTP request capabilities into your SwiftUI projects, allowing for smooth and efficient data handling and network communication.
