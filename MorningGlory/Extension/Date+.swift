//
//  Date+.swift
//  MorningGlory
//
//  Created by 최대성 on 9/13/24.
//

import Foundation

extension Date {
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
    
    func getDates() -> [Date] {
        
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: calendar.dateComponents([.year, .month], from: self))!
        let range = calendar.range(of: .day, in: .month, for: self)!
        
        
        return range.compactMap { day -> Date in
            
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
    
    static func getWakeUpTime(from date: Date) -> Date {
        Date.dateFormatter.dateFormat = "HH:mm:ss"
        let timeString = Date.dateFormatter.string(from: date)
        
        let stringToDate = Date.dateFormatter.date(from: timeString) ?? Date()
        
        return stringToDate
    }
    
    static func todayDate(from date: Date) -> Date {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeString = Date.dateFormatter.string(from: date)
        
        let stringToDate = Date.dateFormatter.date(from: timeString) ?? Date()
        
        return stringToDate
    }
    
    
}
