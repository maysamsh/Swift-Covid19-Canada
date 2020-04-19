//
//  String+Ext.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-09.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

extension String {
    var numericalChars: String {
        get {
            return self.filter("0123456789.".contains)
        }
    }
    
    var intConversion: Int? {
        return Int(self.numericalChars)
    }
    
    var doubleConvrsion: Double? {
        return Double(self.numericalChars)
    }
}
