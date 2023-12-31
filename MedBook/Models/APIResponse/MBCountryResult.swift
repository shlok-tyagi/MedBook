//
//  MBCountryResult.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import Foundation

struct MBCountryResult: Codable {
    
    let status: String
    let statusCode: Int
    let version, access: String
    let data: [String: MBCountry]

    enum CodingKeys: String, CodingKey {
        case status
        case statusCode = "status-code"
        case version, access, data
    }
    
}
