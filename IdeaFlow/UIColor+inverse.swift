//
//  UIColor+inverse.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    func inverseColor() -> UIColor
    {
        var r:CGFloat = 0.0;
        var g:CGFloat = 0.0;
        var b:CGFloat = 0.0;
        var a:CGFloat = 0.0;
        
        if self.getRed(&r, green: &g, blue: &b, alpha: &a)
        {
            return UIColor(red: 1.0-r, green: 1.0 - g, blue: 1.0 - b, alpha: a)
        }
        return self
    }
}