//
//  IdeaFlowEventCell.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import UIKit

class IdeaFlowEventCell: UITableViewCell
{
    var eventIdentifier:String?
    
    func populate(event: IdeaFlowEvent)
    {
        eventIdentifier = event.identifier
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        
        let startDateString = "\(dateFormatter.stringFromDate(event.startTimeStamp))"
        
        textLabel?.text = "\(event.eventTypeName())"
        detailTextLabel?.text = "\(startDateString)"
        
        backgroundColor = event.eventTypeColor()
        textLabel?.textColor = backgroundColor?.inverseColor()
        detailTextLabel?.textColor = backgroundColor?.inverseColor()
    }
}