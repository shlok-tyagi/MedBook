//
//  MBQueryParams.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import Foundation

class MBQueryParams{
    private let title: String
    private let limit: Int
    private let offset: Int
    
    init(title: String,
         limit: Int,
         offset: Int) {
        
        /// add encoding for whitespaces and special charaters
        self.title = NSString(string: title).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        self.limit = limit
        self.offset = offset
    }
    
    public var queryItems: [URLQueryItem]{
        return [URLQueryItem(name: "title", value: title),
                URLQueryItem(name: "limit", value: "\(limit)"),
                URLQueryItem(name: "offset", value: "\(offset)")
        ]
    }
    
}
