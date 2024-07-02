//
//  TranlatorView.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 01.07.2024.
//

import SwiftUI

struct TranlatorView: View {
    // MARK: - Properties
    @State private var inputLanguage: String = "UKR"
    @State private var outputLanguage: String = "ITA"
    @State private var inputPlaceholder = ["Your word", "Input text", "Cucumber", "Investigation", "Bizzare", "Mind control"]
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(inputLanguage)
                    .foregroundColor(.white)
                    .padding(.horizontal, Constants.padding)
                    .font(.system(size: 16))
                    .frame(minWidth: 40)
                
                TextField(inputPlaceholder.randomElement()!, text: $inputText, onCommit: translateText)
                    .padding(Constants.padding)
                    .foregroundColor(.white)
                    .font(.system(size: 16))
                    .textFieldStyle(PlainTextFieldStyle())
            }
            .padding(Constants.padding)
            .padding(.horizontal)
            
            if !translatedText.isEmpty {
                Divider()
                    .frame(height: 0.5)
                    .padding(.horizontal)
                
                HStack {
                    Text(outputLanguage)
                        .foregroundColor(.white)
                        .padding(.horizontal, Constants.padding)
                        .font(.system(size: 16))
                        .frame(minWidth: 40)
                    
                    TextField(translatedText, text: $translatedText, onCommit: reverseTranslate)
                        .padding(Constants.padding)
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(Constants.padding)
                .padding(.horizontal)
            }
        }
        .background(Colors.App.background)
        .cornerRadius(Constants.cornerRadius)
    }
}

// MARK: - Private
private extension TranlatorView {
    func translateText() {
        translatedText = "Translated: \(inputText)"
    }
    
    func reverseTranslate() {
        inputText = "Reversed: \(translatedText)"
    }
}

#Preview {
    TranlatorView()
        .frame(width: 400 , height: 90)
}

// MARK: - Constants
private enum Constants {
    static let padding: CGFloat = 5
    static let cornerRadius: CGFloat = 15
}
