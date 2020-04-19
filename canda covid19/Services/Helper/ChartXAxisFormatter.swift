//
//  ChartXAxisFormatter.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-08.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation
import Charts

class ChartXAxisFormatter: NSObject, IAxisValueFormatter {
    var rawData: [CSVDecodable] = []
    
    init(with data: [CSVDecodable]) {
        self.rawData = data
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        guard rawData.count > 0 else {return " "}
        return StringFormatter.getDayMonth(from: rawData[Int(value)].date)
    }
}
