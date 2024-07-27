//
//  TranslatorViewModel.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 27.07.2024.
//

import SwiftUI
import Combine

final class TranslatorViewModel: ObservableObject {
    // MARK: - Properties
    @Published var inputLanguage: SourceLanguage = .uk
    @Published var outputLanguage: SourceLanguage = .en
    @Published var inputPlaceholder = [
        "Your word", "Input text",
        "Cucumber", "Investigation",
        "Bizarre", "Mind control"
    ]
    @Published var inputText = String()
    @Published var translatedText = String()
    
    // MARK: - Cancellables
    var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Services
    private var translationService: any TranslationService
    
    // MARK: - Init
    init(
        translationService: any TranslationService = TranslationServiceImpl()
    ) {
        self.translationService = translationService
        setupBindings()
    }
}

// MARK: - Translation
extension TranslatorViewModel {
    func doTranslation() {
        if !inputText.isEmpty {
            translationService.doTranslation(
                inputText,
                from: inputLanguage,
                to: outputLanguage
            )
        }
    }
}

// MARK: - Private
private extension TranslatorViewModel {
    func setupBindings() {
        translationService.eventPublisher
            .sink { [unowned self] (event) in
                switch event {
                case .translated(let result):
                    self.translatedText = result
                }
            }.store(in: &cancellables)
    }
}
