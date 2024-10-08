import WatchKit
import SwiftUI

class HostingController: WKHostingController<ContentView> {
    override var body: ContentView {
        return ContentView()
    }
    
    override func willActivate() {
        super.willActivate()
        // Register to listen for the dictation notification
        NotificationCenter.default.addObserver(self, selector: #selector(presentDictation), name: NSNotification.Name("PresentDictation"), object: nil)
    }

    override func didDeactivate() {
        super.didDeactivate()
        // Stop listening to avoid memory leaks
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("PresentDictation"), object: nil)
    }

    @objc func presentDictation() {
        presentTextInputController(withSuggestions: nil, allowedInputMode: .plain) { [weak self] (results) in
            guard let self = self, let results = results, let response = results.first as? String else { return }
            // Use the response from dictation
            DispatchQueue.main.async {
                // Assuming you have a way to update your ViewModel or pass this data back to your SwiftUI view
                ViewModel.shared.updateText(response)
            }
        }
    }
}
