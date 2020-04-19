//
//  XYMarker.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-15.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation
import UIKit
import Charts

public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueFormatter
    fileprivate var yFormatter = NumberFormatter()
    
    public init(color: UIColor, font: UIFont, textColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 1
        super.init(color: color, font: font, textColor: textColor, insets: insets)
    }
    
    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let string = ""
            + "\(Int(entry.y).formattedWithSeparator) - "
            + "("
            + xAxisValueFormatter.stringForValue(entry.x, axis: XAxis())
            + ")"
            
        setLabel(string)
    }
    
}
