//
//  Int-Double+Ext.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-13.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

protocol StringRepresentable {
    init?(_ string: String?)
}

extension Double: StringRepresentable {
    init?(_ string: String?) {
        if let _string = string {
            if _string.numericalChars.isEmpty {
                return nil
            }else{
                self.init(_string)
            }
        } else {
            return nil
        }
    }
    
}

extension Int: StringRepresentable {
    init?(_ string: String?) {
        if let _string = string {
            if _string.numericalChars.isEmpty {
                return nil
            }else{
                if let _double = Double(_string) {
                    self.init(_double)
                } else {
                    return nil
                }
            }
        } else {
            return nil
        }
    }
    
}
