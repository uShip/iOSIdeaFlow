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
    func populate(event: IdeaFlowEvent)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .MediumStyle
        
        var endDateString = ""
        if let endDate = event.endTimeStamp
        {
            endDateString = "- \(dateFormatter.stringFromDate(endDate))"
        }
        
        textLabel?.text = "\(event.eventTypeName())"
        detailTextLabel?.text = "\(dateFormatter.stringFromDate(event.startTimeStamp))\(endDateString)"
        
        backgroundColor = event.eventTypeColor()
        textLabel?.textColor = backgroundColor?.inverseColor()
        detailTextLabel?.textColor = backgroundColor?.inverseColor()
    }
}