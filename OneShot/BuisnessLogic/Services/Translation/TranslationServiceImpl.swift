//
//  TranslationService.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 18.07.2024.
//

import SwiftUI
import Combine

enum TranslationServiceEvents {
    case translated(_: String)
}

protocol TranslationService: ObservableObject {
    // MARK: - Publisher
    var eventPublisher: AnyPublisher<TranslationServiceEvents, Never> { get }
    
    // MARK: - Funcs
    func doTranslation(
        _ text: String,
        from sourceLanguage: SourceLanguage,
        to targetLanguage: SourceLanguage
    )
}

final class TranslationServiceImpl: TranslationService {
    // MARK: - Publisher
    private(set) lazy var eventPublisher = eventSubject.eraseToAnyPublisher()
    private let eventSubject = PassthroughSubject<TranslationServiceEvents, Never>()
    
    // MARK: - Cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Funcs
    func doTranslation(
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
}

// MARK: - Private
private extension TranslationServiceImpl {
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
                    self.eventSubject.send(.translated("Translation error"))
                    
                case .finished: break
                }
            }, receiveValue: { [weak self] (response) in
                self?.eventSubject.send(
                    .translated(response.translations.first?.text ?? "Result text is empty")
                )
            })
            .store(in: &cancellables)
    }
}
