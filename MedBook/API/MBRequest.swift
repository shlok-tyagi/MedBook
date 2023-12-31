//
//  MBRequest.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import Foundation

enum MBRequestBaseURL: String{
    case openlibrary = "https://openlibrary.org/search.json"
    case country = "https://api.first.org/data/v1/countries"
}

class MBRequest{
    
    private let baseURL: MBRequestBaseURL
    
    private let queryParameters: [URLQueryItem]

    private var urlString: String{
        
        var string = baseURL.rawValue
        
        if !queryParameters.isEmpty{
            string += "?"
            let argumentString = queryParameters.compactMap({
                guard let value = $0.value else {return nil}
                return "\($0.name)=\(value)"
            }).joined(separator: "&")
            string += argumentString
        }
        
        return string
    }
    
    public var url: URL?{
        return URL(string: urlString)
    }
    
    public let httpMethod = "GET"
    
    init(baseURL: MBRequestBaseURL,
         queryParameters: [URLQueryItem]) {
        self.baseURL = baseURL
        self.queryParameters = queryParameters
    }
    
}

