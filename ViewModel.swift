import SwiftUI

class ViewModel: ObservableObject {
    static let shared = ViewModel()
    @Published var text: String = ""
    
    func updateText(_ newText: String) {
        text = newText
    }
}
