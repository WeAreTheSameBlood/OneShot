//
//  APIConstants.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 19.07.2024.
//

enum APIConstants {
#warning("API_KEY")
    static let API_KEY = "API_KEY"
    static let API_URL = "https://api-free.deepl.com/v2/translate"
    
    enum RequestParam {
        static let httpMethod = "POST"
        static let contentType = "application/json"
        static let authorization = "DeepL-Auth-Key \(APIConstants.API_KEY)"
    }
    
    enum HTTPHeader {
        static let contentType = "Content-Type"
        static let authorization = "Authorization"
    }
}
