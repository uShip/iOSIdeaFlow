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
        
        var endDateString = ""
        if let endDate = event.endTimeStamp
        {
            endDateString = "- \(dateFormatter.stringFromDate(endDate))"
        }
        
        var startDateString = ""
        if let startDate = event.startTimeStamp
        {
            startDateString = "\(dateFormatter.stringFromDate(startDate))"
        }
        
        textLabel?.text = "\(event.eventTypeName())"
        detailTextLabel?.text = "\(startDateString)\(endDateString)"
        
        backgroundColor = event.eventTypeColor()
        textLabel?.textColor = backgroundColor?.inverseColor()
        detailTextLabel?.textColor = backgroundColor?.inverseColor()
    }
}