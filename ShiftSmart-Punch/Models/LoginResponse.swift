//
//  LoginResponse.swift
//  ShiftSmart-Punch
//
//  Created by Rohit Mahenderker on 2025-03-11.
//
// Responsible for the Login 

import Foundation

struct LoginResponse: Codable {
    let token: String 
    let user: User
}
