//
//  IdeaFlowEvent+Stuff.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension IdeaFlowEvent
{
    enum EventType: String
    {
        case Productivity = "Productivity"
        case Troubleshooting = "Troubleshooting"
        case Learning = "Learning"
        case Rework = "Rework"
        case Unknown = "Unknown"
        
        func intValue() -> Int32
        {
            switch (self)
            {
            case .Productivity:
                return 0
            case .Troubleshooting:
                return 1
            case .Learning:
                return 2
            case .Rework:
                return 3
            case .Unknown:
                return 4
            }
        }
    }
    
    func eventTypeName() -> String
    {
        switch eventType.integerValue
        {
        case 0:
            return EventType.Productivity.rawValue
        case 1:
            return EventType.Troubleshooting.rawValue
        case 2:
            return EventType.Learning.rawValue
        case 3:
            return EventType.Rework.rawValue
        default:
            return EventType.Unknown.rawValue
        }
    }
    
    func eventTypeColor() -> UIColor
    {
        switch eventType.integerValue
        {
        case 0:
            return UIColor.lightGrayColor()
        case 1:
            return UIColor.redColor()
        case 2:
            return UIColor.purpleColor()
        case 3:
            return UIColor.orangeColor()
        default:
            return UIColor.magentaColor()
        }
    }
}