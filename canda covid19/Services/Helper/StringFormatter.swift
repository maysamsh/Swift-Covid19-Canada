//
//  StringFormatter.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-03.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

struct StringFormatter {
    static func getDayMonth(from date: String) -> String {
        guard let _date = getDate(from: date) else { return "-" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL dd"
        return dateFormatter.string(from: _date) 
    }
    
    static func getDate(from date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
        return dateFormatter.date(from: date)
    }
}
