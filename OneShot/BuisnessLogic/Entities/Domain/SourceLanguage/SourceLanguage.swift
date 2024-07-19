//
//  SourceLanguage.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 19.07.2024.
//

import Foundation

enum SourceLanguage: String, CaseIterable {
    case bg, cs, da, de, el, en, es, et, fi, fr, hu, id, it, ja, ko, lt, lv, nb, nl, pl, pt, ro, sk, sl, sv, tr, uk, zh
}

// MARK: - Title
extension SourceLanguage {
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
}

// MARK: - Abbreviation
extension SourceLanguage {
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
