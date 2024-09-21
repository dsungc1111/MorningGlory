//
//  PostItData.swift
//  MorningGlory
//
//  Created by 최대성 on 9/16/24.
//
import SwiftUI

enum PostItColor {
    static let pink = PostItItem(background: Color.pink.opacity(0.2), time: "05:30")
    static let yellow = PostItItem(background: Color.yellow.opacity(0.2), time: "06:30")
    static let orange = PostItItem(background: Color.orange.opacity(0.2), time: "07:30")
}

struct PostItItem {
    let background: Color
    let time: String
}
