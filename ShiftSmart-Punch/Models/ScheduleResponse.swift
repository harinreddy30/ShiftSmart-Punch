//
//  ScheduleResponse.swift
//  ShiftSmart-Punch
//
//  Created by Rohit Mahenderker on 2025-03-16.
//


import Foundation

struct ScheduleResponse: Codable {
    let schedule: [Shift]  // ✅ Matches JSON structure
}

