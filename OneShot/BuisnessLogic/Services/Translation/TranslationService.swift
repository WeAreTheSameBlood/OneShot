//
//  TranslationService.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 18.07.2024.
//

import SwiftUI
import Combine

final class TranslationService: ObservableObject {
    // MARK: - Properties
    @Published var translatedText: String = ""
    private var cancellables = Set<AnyCancellable>()
    
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
        guard let url = URL(string: APIConstants.API_URL) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = APIConstants.RequestParam.httpMethod
        request.addValue(
            APIConstants.RequestParam.contentType,
            forHTTPHeaderField: APIConstants.HTTPHeader.contentType
        )
        request.addValue(
            APIConstants.RequestParam.authorization,
            forHTTPHeaderField: APIConstants.HTTPHeader.authorization
        )

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
                    debugPrint("Translation error: \(error)")
                    
                case .finished: break
                }
            }, receiveValue: { [weak self] (response) in
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
