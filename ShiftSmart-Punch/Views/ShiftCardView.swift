//
//  ShiftCardView.swift
//  ShiftSmart-Punch
//
//  Created by Rohit Mahenderker on 2025-03-16.
//


import SwiftUI

struct ShiftCardView: View {
    let shift: Shift
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(shift.site.name) // Display site name
                    .font(.headline)
                
                HStack {
                    Image(systemName: "mappin.and.ellipse")
                    Text(shift.site.location.address) // Display address
                }
                .foregroundColor(.gray)
                
                Text("\(shift.startTime) - \(shift.endTime)")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Text("\(shift.totalHours) hrs")
                .padding(8)
                .background(Circle().fill(Color.gray.opacity(0.3)))
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}
