//
//  BookResult.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import Foundation

struct MBBookResult: Codable {
    
    let numFound, start: Int
    let numFoundExact: Bool
    let books: [MBBook]
    let bookResultNumFound: Int
    let q: String
    let offset: Int

    enum CodingKeys: String, CodingKey {
        case numFound, start, numFoundExact
        case books = "docs"
        case bookResultNumFound = "num_found"
        case q, offset
    }
    
}
