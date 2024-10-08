//
//  WebSocketManager.swift
//  AI-W Watch App
//
//  Created by JIM WEGLIN on 2/29/24.
//

import Foundation
import SwiftUI
import Combine

class WebSocketManager: ObservableObject {
    static let shared = WebSocketManager()
    private var webSocketTask: URLSessionWebSocketTask?
    
    // Add a published property to trigger updates in the UI if needed
    @Published var receivedMessage: String?
    @Published var messages: [String] = []

    func connect() {
        guard let url = URL(string: "wss://demo.piesocket.com") else {
            print("WebSocket: Unable to create URL")
            return
        }
        
        self.webSocketTask = URLSession.shared.webSocketTask(with: url)
        self.webSocketTask?.resume()
        self.receiveMessage()
    }
    
    func sendMessage(_ text: String) {
        let message = URLSessionWebSocketTask.Message.string(text)
        webSocketTask?.send(message) { error in
            if let error = error {
                print("WebSocket sending error: \(error)")
            }
        }
    }

    
    private func receiveMessage() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receiving error: \(error)")
                self?.connect() // Attempt to reconnect on failure
            case .success(let message):
                switch message {
                case .string(let text):
                    DispatchQueue.main.async {
                        self?.receivedMessage = text
                        self?.messages.append(text)
                    }
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    fatalError("Unknown message received from WebSocket")
                }
                self?.receiveMessage()
            }
        }
    }
    
    deinit {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
}
