//
//  LoginResponse.swift
//  ShiftSmart-Punch
//
//  Created by Rohit Mahenderker on 2025-03-11.
//


import Foundation

struct LoginResponse: Codable {
    let token: String
    let user: User
}
