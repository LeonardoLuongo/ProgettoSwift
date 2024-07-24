import SwiftUI
import UIKit

struct AttributedTextView: UIViewRepresentable {
    @Binding var selectedSentence: Sentence?
    var text: NSAttributedString
    var sentences: [Sentence]
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = .black
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        
        let tapGesture = UITapGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleTapGesture(_:)))
        textView.addGestureRecognizer(tapGesture)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
        // Force layout to ensure the text is rendered correctly
        uiView.layoutIfNeeded()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: AttributedTextView
        
        init(_ parent: AttributedTextView) {
            self.parent = parent
        }
        
        @objc func handleTapGesture(_ gesture: UITapGestureRecognizer) {
            guard let textView = gesture.view as? UITextView else { return }
            let layoutManager = textView.layoutManager
            var location = gesture.location(in: textView)
            location.x -= textView.textContainerInset.left
            location.y -= textView.textContainerInset.top
            
            let characterIndex = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            
            for sentence in parent.sentences {
                if let range = parent.text.string.range(of: sentence.getText()),
                   NSLocationInRange(characterIndex, NSRange(range, in: parent.text.string)) {
                    parent.selectedSentence = sentence
                    break
                }
            }
        }
    }
}
