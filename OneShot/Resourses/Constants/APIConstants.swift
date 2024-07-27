//
//  APIConstants.swift
//  OneShot
//
//  Created by Andrii Hlybchenko on 19.07.2024.
//

enum APIConstants {
    static let API_KEY = "84e0c0b4-f4dd-42d3-930c-01c7fe2ca71d:fx"
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
