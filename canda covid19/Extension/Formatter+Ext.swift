//
//  Formatter.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-02.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
