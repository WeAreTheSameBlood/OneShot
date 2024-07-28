//
//  TranslationResponse.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 27.07.2024.
//

import Foundation

struct TranslationResponse: Decodable {
    let translations: [Translation]
    
    struct Translation: Decodable {
        let text: String
    }
}
