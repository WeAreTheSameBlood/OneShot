//
//  TranslationService.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 18.07.2024.
//

import SwiftUI
import Combine

enum SourceLanguage: String, CaseIterable {
    case bg, cs, da, de, el, en, es, et, fi, fr, hu, id, it, ja, ko, lt, lv, nb, nl, pl, pt, ro, sk, sl, sv, tr, uk, zh

    var title: String {
        switch self {
        case .bg: return "Bulgarian"
        case .cs: return "Czech"
        case .da: return "Danish"
        case .de: return "German"
        case .el: return "Greek"
        case .en: return "English"
        case .es: return "Spanish"
        case .et: return "Estonian"
        case .fi: return "Finnish"
        case .fr: return "French"
        case .hu: return "Hungarian"
        case .id: return "Indonesian"
        case .it: return "Italian"
        case .ja: return "Japanese"
        case .ko: return "Korean"
        case .lt: return "Lithuanian"
        case .lv: return "Latvian"
        case .nb: return "Norwegian"
        case .nl: return "Dutch"
        case .pl: return "Polish"
        case .pt: return "Portuguese"
        case .ro: return "Romanian"
        case .sk: return "Slovak"
        case .sl: return "Slovenian"
        case .sv: return "Swedish"
        case .tr: return "Turkish"
        case .uk: return "Ukrainian"
        case .zh: return "Chinese"
        }
    }

    var abbreviation: String {
        switch self {
        case .bg: return "BG"
        case .cs: return "CS"
        case .da: return "DA"
        case .de: return "DE"
        case .el: return "EL"
        case .en: return "ENG"
        case .es: return "ES"
        case .et: return "ET"
        case .fi: return "FI"
        case .fr: return "FR"
        case .hu: return "HU"
        case .id: return "ID"
        case .it: return "ITA"
        case .ja: return "JA"
        case .ko: return "KO"
        case .lt: return "LT"
        case .lv: return "LV"
        case .nb: return "NB"
        case .nl: return "NL"
        case .pl: return "PL"
        case .pt: return "PT"
        case .ro: return "RO"
        case .sk: return "SK"
        case .sl: return "SL"
        case .sv: return "SV"
        case .tr: return "TR"
        case .uk: return "UKR"
        case .zh: return "ZH"
        }
    }
}

final class TranslationService: ObservableObject {
    // MARK: - Properties
    @Published var translatedText: String = ""
    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "api_key"
    
    // MARK: - Funcs
    func translateText(
        _ text: String,
        from sourceLanguage: SourceLanguage,
        to targetLanguage: SourceLanguage
    ) {
        makeRequest(
            text: text,
            sourceLanguage: sourceLanguage.rawValue,
            targetLanguage: targetLanguage.rawValue
        )
    }
    
    func reverseTranslateText(
        _ text: String,
        from targetLanguage: SourceLanguage,
        to sourceLanguage: SourceLanguage
    ) {
        makeRequest(
            text: text,
            sourceLanguage: targetLanguage.rawValue,
            targetLanguage: sourceLanguage.rawValue
        )
    }
}

// MARK: - Private
private extension TranslationService {
    func makeRequest(
        text: String,
        sourceLanguage: String,
        targetLanguage: String
    ) {
        guard let url = URL(string: "https://api-free.deepl.com/v2/translate") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("DeepL-Auth-Key \(apiKey)", forHTTPHeaderField: "Authorization")

        let requestBody: [String: Any] = [
            "text": [text],
            "source_lang": sourceLanguage,
            "target_lang": targetLanguage
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)

        URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: TranslationResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error):
                    print("Translation error: \(error)")
                    
                case .finished: break
                }
            }, receiveValue: { [weak self] response in
                self?.translatedText = response.translations.first?.text ?? ""
            })
            .store(in: &cancellables)
    }
}

struct TranslationResponse: Decodable {
    struct Translation: Decodable {
        let text: String
    }
    let translations: [Translation]
}
