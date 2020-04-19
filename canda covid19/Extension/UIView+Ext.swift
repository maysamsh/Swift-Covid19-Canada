//
//  UIView+Ext.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-19.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

    func takeScreenshot() -> UIImage? {

        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)

        drawHierarchy(in: self.bounds, afterScreenUpdates: true)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
    }
}

