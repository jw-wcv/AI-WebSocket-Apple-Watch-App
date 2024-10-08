import SwiftUI

struct ContentView: View {
    @ObservedObject var webSocketManager = WebSocketManager.shared
    @State private var isPresentingTextInput = false
    @State private var inputText: String = ""

    var body: some View {
        VStack {
            Text("WebSocket Feed")
                .font(.headline)
                .padding()

            ScrollView {
                ForEach(webSocketManager.messages, id: \.self) { message in
                    Text(message)
                        .padding()
                }
            }

            Button("Send Message") {
                isPresentingTextInput = true
            }
            .padding()
            Button("Dictate Message") {
                            // Publish a notification to trigger dictation
                            NotificationCenter.default.post(name: NSNotification.Name("PresentDictation"), object: nil)
                        }
            .padding()
        }
        .sheet(isPresented: $isPresentingTextInput) {
            TextInputView(onSend: { text in
                self.webSocketManager.sendMessage(text)
            })
        }
    }
}

struct TextInputView: View {
    var onSend: (String) -> Void

    var body: some View {
        // This Button simulates triggering text input, in reality, you would use presentTextInputController from WKInterfaceController to get text input
        Button("Dictate Message") {
            // Simulate text input, in practice, call a function that presents the text input controller for dictation or scribble input
            onSend("Simulated message")
        }
    }
}
