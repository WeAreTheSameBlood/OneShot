//
//  LanguageInputView.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 19.07.2024.
//

import SwiftUI

struct LanguageInputView: View {
    // MARK: - Properties
    @Binding var selectedLanguage: SourceLanguage
    @Binding var text: String
    var placeholder: String
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
}
