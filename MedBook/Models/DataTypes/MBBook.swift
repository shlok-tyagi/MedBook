//
//  Book.swift
//  MedBook
//
//  Created by Shlok Tyagi on 29/12/23.
//

import Foundation

struct MBBook: Codable {
    
    let title: String
    let ratingsCount: Int?
    let ratingsAverage: Double?
    let authorNames: [String]?
    let imageID: Int?

    enum CodingKeys: String, CodingKey {
        case title
        case ratingsAverage = "ratings_average"
        case ratingsCount = "ratings_count"
        case authorNames = "author_name"
        case imageID = "cover_i"
    }
}
