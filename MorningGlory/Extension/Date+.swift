//
//  Date+.swift
//  MorningGlory
//
//  Created by 최대성 on 9/13/24.
//

import Foundation

extension Date {
    
    func getDates() -> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}
