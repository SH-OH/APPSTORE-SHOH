//
//  Date+Extensions.swift
//  KAKAOBANK-SHOH
//
//  Created by Oh Sangho on 2020/09/20.
//  Copyright © 2020 SH-OH. All rights reserved.
//

import Foundation

extension Date {
    var ago: String? {
        let component = Calendar.current.dateComponents([.year, .month, .weekday,
                                                         .day, .hour, .minute, .second],
                                                        from: Date(),
                                                        to: self)
        var ago: String?
        (0..<7).forEach { (index) in
            if let year = component.year, year < 0 {
                ago = "\(abs(year))년 전"
                return
            }
            if let month = component.month, month < 0 {
                ago = "\(abs(month))개월 전"
                return
            }
            if let week = component.weekday, week < 0 {
                ago = "\(abs(week))주 전"
                return
            }
            if let day = component.day, day < 0 {
                ago = "\(abs(day))일 전"
                return
            }
            if let hour = component.hour, hour < 0 {
                ago = "\(abs(hour))시간 전"
                return
            }
            if let minute = component.minute, minute < 0 {
                ago = "\(abs(minute))분 전"
                return
            }
            if let second = component.second, second < 0 {
                ago = "방금 전"
                return
            }
        }
        return ago
    }
}
