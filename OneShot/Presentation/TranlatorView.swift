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

struct LanguageInputView: View {
    // MARK: - Properties
    @Binding var selectedLanguage: SourceLanguage
    var placeholder: String
    @Binding var text: String
    var onCommit: () -> Void
    
    // MARK: - Body
    var body: some View {
        HStack {
            Menu {
                ForEach(SourceLanguage.allCases, id: \.self) { (language) in
                    Button { selectedLanguage = language } label: {
                        Text(language.title).tag(language)
                    }
                }
            } label: {
                Text(selectedLanguage.abbreviation)
                    .foregroundColor(.gray)
                    .padding(.horizontal, Constants.padding)
                    .font(.system(size: 16))
                    .frame(minWidth: 40)
                    .cornerRadius(5)
            }
            .padding(.trailing, Constants.padding)
            .frame(maxWidth: 70)

            TextField(placeholder, text: $text, onCommit: onCommit)
                .padding(Constants.padding)
                .foregroundColor(.white)
                .font(.system(size: 16))
                .textFieldStyle(PlainTextFieldStyle())
        }
        .padding(Constants.padding)
        .padding(.horizontal)
    }
}


// MARK: - Constants
private enum Constants {
    static let padding: CGFloat = 5
    static let cornerRadius: CGFloat = 15
}
