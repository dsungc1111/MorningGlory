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
    
    static func dateToString(from date: Date) -> String {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        let timeString = Date.dateFormatter.string(from: date)
        return timeString
    }
    
    static func messageTime(writeDate: Date, currentDate: Date) -> String {
        
        let targetDate = writeDate
        
        let difference = currentDate.timeIntervalSince(targetDate)
        
        let minutes = Int(difference / 60)
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        
        if minutes < 1 {
            return "방금 전"
        } else if minutes < 60 {
            return "\(minutes)분 전"
        } else if hours < 24 {
            return "\(hours)시간 전"
        } else if days < 7 {
            return "\(days)일 전"
        } else {
            return "\(weeks)주 전"
        }
        
    }
    
    
}


final class ReuseDateformatter {
    
    static let shared = ReuseDateformatter()
    
    private init() {}
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
      formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
    
    func getDateString(date: Date) -> String {
        Self.dateFormatter.dateFormat = "yyyy년 MM월 dd일"
        return Self.dateFormatter.string(from: date)
    }
    func getDate(dateString: String) -> Date {
        Self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return Self.dateFormatter.date(from: dateString) ?? Date()
    }
    func changeStringForm(dateString: String) -> String {
        let changedDate = getDate(dateString: dateString)
        let changedStringForm = getDateString(date: changedDate)
        return changedStringForm
    }
    
    func messageTime(dateString: String, currentDate: Date) -> String {
        
        let targetDate = getDate(dateString: dateString)
        
        let difference = currentDate.timeIntervalSince(targetDate)
        
        let minutes = Int(difference / 60)
        let hours = minutes / 60
        let days = hours / 24
        let weeks = days / 7
        
        if minutes < 1 {
            return "방금 전"
        } else if minutes < 60 {
            return "\(minutes)분 전"
        } else if hours < 24 {
            return "\(hours)시간 전"
        } else if days < 7 {
            return "\(days)일 전"
        } else {
            return "\(weeks)주 전"
        }
        
    }
    
    
}
