//
//  Site.swift
//  ShiftSmart-Punch
//
//  Created by Rohit Mahenderker on 2025-03-16.
//


import Foundation

struct Site: Codable {
    let id: String
    let siteId: Int
    let name: String
    let location: Location

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case siteId
        case name
        case location
    }
}

struct Location: Codable {
    let address: String
    let coordinates: [Double]
}
