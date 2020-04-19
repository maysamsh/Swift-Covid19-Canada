//
//  ProvinceUID.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-14.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

struct ProvinceUID {
    let id: Int
    let englishName: String
    let franceName: String
    let cases: Int
}

extension ProvinceUID: Equatable, Comparable, Hashable {
    static func < (lhs: ProvinceUID, rhs: ProvinceUID) -> Bool {
        return lhs.englishName < rhs.englishName
    }
    
    static func == (lhs: ProvinceUID, rhs: ProvinceUID) -> Bool{
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

