//
//  IdeaFlowEvent+Notifications.swift
//  IdeaFlow
//
//  Created by Matthew Hayes on 9/4/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import Foundation

extension IdeaFlowEvent
{
    enum Notification : String
    {
        case EventAdded = "Event Added"
        case AllEventsDeleted = "All Events Deleted"
        case SelectedDateChanged = "Selected Date Changed"
        
        func notification(sender: AnyObject? = nil) -> NSNotification
        {
            return NSNotification(name: self.rawValue, object: sender)
        }
    }
}

extension NSNotificationCenter
{
    func addObserverForIdeaFlowEvents(observer: AnyObject, selector: Selector)
    {
        addObserver(observer, selector: selector, name: IdeaFlowEvent.Notification.EventAdded.rawValue, object: nil)
        addObserver(observer, selector: selector, name: IdeaFlowEvent.Notification.AllEventsDeleted.rawValue, object: nil)
        addObserver(observer, selector: selector, name: IdeaFlowEvent.Notification.SelectedDateChanged.rawValue, object: nil)
    }
}

extension NSNotification
{
    func convertToIdeaFlowEventNotification() -> IdeaFlowEvent.Notification?
    {
        switch name
        {
        case IdeaFlowEvent.Notification.EventAdded.rawValue:
            return .EventAdded
        case IdeaFlowEvent.Notification.AllEventsDeleted.rawValue:
            return .AllEventsDeleted
        default:
            return nil
        }
    }
}