//
//  Array+Ext.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-14.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

extension Array {
    func getLastTwo() -> [Element]? {
        if self.count < 2 { return nil }
        return [self[self.count-2], self.last!]
    }
    
    func getLast(number: Int) -> [Element] {
        guard self.count >= number, number > 0 else {
            return self
        }
        
        let itemsToDrop = self.count - number
        let _array =  Array(self.dropFirst(itemsToDrop))
        return _array
    }
}


