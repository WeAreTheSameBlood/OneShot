//
//  TranlatorView.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 01.07.2024.
//

import SwiftUI

struct TranslatorView: View {
    // MARK: - Properties
    @State private var inputLanguage: SourceLanguage = .uk
    @State private var outputLanguage: SourceLanguage = .it
    @State private var inputPlaceholder = ["Your word", "Input text", "Cucumber", "Investigation", "Bizarre", "Mind control"]
    @State private var inputText: String = ""
    @ObservedObject private var translationService = TranslationService()
    private var timer = Timer.publish(every: 2.0, on: .main, in: .common).autoconnect()
    @State private var lastEditDate = Date()

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            LanguageInputView(
                selectedLanguage: $inputLanguage,
                placeholder: inputPlaceholder.randomElement()!,
                text: $inputText,
                onCommit: translateText
            )
            
            if !translationService.translatedText.isEmpty {
                Divider()
                    .frame(height: 0.5)
                    .padding(.horizontal)
                
                LanguageInputView(
                    selectedLanguage: $outputLanguage,
                    placeholder: translationService.translatedText,
                    text: $translationService.translatedText,
                    onCommit: reverseTranslate
                )
            }
        }
        .background(Colors.App.background)
        .cornerRadius(Constants.cornerRadius)
        .onChange(of: inputText) { (newValue) in
            lastEditDate = Date()
            if newValue.last == " " || newValue.last == "," || newValue.last == "." {
                translateText()
            }
        }
        .onReceive(timer) { _ in
            if Date().timeIntervalSince(lastEditDate) >= 2 {
                translateText()
            }
        }
    }
    
    func translateText() {
        translationService.translateText(inputText, from: inputLanguage, to: outputLanguage)
    }
    
    func reverseTranslate() {
        translationService.reverseTranslateText(translationService.translatedText, from: outputLanguage, to: inputLanguage)
    }
}

#Preview {
    TranslatorView()
        .frame(width: 400 , height: 90)
}

// MARK: - Constants
private enum Constants {
    static let padding: CGFloat = 5
    static let cornerRadius: CGFloat = 15
}
