//
//  IdeaFlowEvent+Stuff.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation

enum IdeaFlowEventType: String
{
    case Productivity = "Productivity"
    case Troubleshooting = "Troubleshooting"
    case Learning = "Learning"
    case Rework = "Rework"
    case Unknown = "Unknown"
}

extension IdeaFlowEvent
{
    func eventTypeName() -> String
    {
        switch eventType.integerValue
        {
        case 0:
            return IdeaFlowEventType.Productivity.rawValue
        case 1:
            return IdeaFlowEventType.Troubleshooting.rawValue
        case 2:
            return IdeaFlowEventType.Learning.rawValue
        case 3:
            return IdeaFlowEventType.Rework.rawValue
        default:
            return IdeaFlowEventType.Unknown.rawValue
        }
    }
}