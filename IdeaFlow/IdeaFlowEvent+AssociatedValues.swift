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
        case Pause = "Pause"
        case Unknown = "Unknown"
        
        init(int: Int32)
        {
            switch int
            {
            case 1:
                self = .Productivity
            case 2:
                self = .Troubleshooting
            case 3:
                self = .Learning
            case 4:
                self = .Rework
            case 5:
                self = .Pause
            default:
                self = .Unknown
            }
        }
        
        func intValue() -> Int32
        {
            switch (self)
            {
            case .Unknown:
                return 0
            case .Productivity:
                return 1
            case .Troubleshooting:
                return 2
            case .Learning:
                return 3
            case .Rework:
                return 4
            case .Pause:
                return 5
            }
        }
    }
    
    func eventTypeName() -> String
    {
        return EventType(int: eventType.intValue).rawValue
    }
    
    func eventTypeColor() -> UIColor
    {
        switch EventType(int: eventType.intValue)
        {
        case .Productivity:
            return UIColor.lightGrayColor()
        case .Troubleshooting:
            return UIColor.redColor()
        case .Learning:
            return UIColor.blueColor()
        case .Rework:
            return UIColor.orangeColor()
        case .Pause:
            return UIColor.blackColor()
        default:
            return UIColor.magentaColor()
        }
    }
}