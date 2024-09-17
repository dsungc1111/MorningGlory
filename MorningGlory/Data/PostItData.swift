//
//  PostItData.swift
//  MorningGlory
//
//  Created by 최대성 on 9/16/24.
//
import SwiftUI

enum PostItColor {
    static let pink = PostItItem(background: "#FCC8C8", foldColor: "#FF8D8D", time: "05:30")
    static let yellow = PostItItem(background: "#F2F5D5", foldColor: "#FCEB00", time: "06:30")
    static let orange = PostItItem(background: "FFD9AA", foldColor: "FDBD70", time: "07:30")
}

struct PostItItem {
    let background: String
    let foldColor: String
    let time: String
}
