//
//  MBCountry.swift
//  MedBook
//
//  Created by Shlok Tyagi on 30/12/23.
//

import Foundation

struct MBCountry: Codable{
    
    let name: String
    let region: String

    enum CodingKeys: String, CodingKey {
        case region
        case name = "country"
    }
}
