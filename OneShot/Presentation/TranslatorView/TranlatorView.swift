//
//  TranlatorView.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 01.07.2024.
//

import SwiftUI

struct TranslatorView: View {
    // MARK: - Properties
    @StateObject private var viewModel = TranslatorViewModel()
    @Binding var isFirstResponder: Bool
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            LanguageInputView(
                selectedLanguage: $viewModel.inputLanguage,
                text: $viewModel.inputText,
                placeholder: viewModel.inputPlaceholder.randomElement()!,
                onCommit: viewModel.doTranslation,
                isFirstResponder: $isFirstResponder
            )
            
            if !viewModel.translatedText.isEmpty {
                Divider()
                    .frame(height: 0.5)
                    .padding(.horizontal)
                
                LanguageInputView(
                    selectedLanguage: $viewModel.outputLanguage,
                    text: $viewModel.translatedText,
                    placeholder: viewModel.translatedText,
                    onCommit: { },
                    isFirstResponder: .constant(false)
                )
            }
        }
        .background(Colors.App.background)
        .cornerRadius(Constants.cornerRadius)
        .onAppear {
            DispatchQueue.main.async { isFirstResponder = true }
        }
    }
}

#Preview {
    TranslatorView(isFirstResponder: .constant(true))
        .frame(width: 400 , height: 90)
}

// MARK: - Constants
private enum Constants {
    static let padding: CGFloat = 5
    static let cornerRadius: CGFloat = 15
}
