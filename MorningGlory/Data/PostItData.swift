//
//  PostItData.swift
//  MorningGlory
//
//  Created by 최대성 on 9/16/24.
//
import SwiftUI

enum PostItColor {
    static let pink = PostItItem(background: Color(hex: "#b782c4").opacity(0.7), time: "05:30")
    static let yellow = PostItItem(background: Color(hex: "#f7cf76").opacity(0.7), time: "06:30")
    static let green = PostItItem(background: Color(hex: "#52db9b").opacity(0.7), time: "07:30")
}

struct PostItItem {
    let background: Color
    let time: String
}
