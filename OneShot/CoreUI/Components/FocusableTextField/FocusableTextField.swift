//
//  FocusableTextField.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 27.07.2024.
//

import SwiftUI
import AppKit

struct FocusableTextField: NSViewRepresentable {
    // MARK: - Properties
    @Binding var text: String
    var placeholder: String
    var onCommit: () -> Void
    @Binding var isFirstResponder: Bool
    
    // MARK: - Coordinator
    class Coordinator: NSObject, NSTextFieldDelegate {
        var parent: FocusableTextField
        
        init(_ parent: FocusableTextField) {
            self.parent = parent
        }
        
        func controlTextDidChange(_ obj: Notification) {
            guard let textField = obj.object as? NSTextField else { return }
            parent.text = textField.stringValue
        }
        
        func controlTextDidEndEditing(_ obj: Notification) {
            parent.onCommit()
        }
    }
}

// MARK: - Funcs
extension FocusableTextField {
    func makeCoordinator() -> Coordinator { Coordinator(self) }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.placeholderString = placeholder
        textField.delegate = context.coordinator
        textField.focusRingType = .none
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {
        nsView.stringValue = text
        if isFirstResponder {
            DispatchQueue.main.async {
                nsView.window?.makeFirstResponder(nsView)
                isFirstResponder = false
            }
        }
    }
}
