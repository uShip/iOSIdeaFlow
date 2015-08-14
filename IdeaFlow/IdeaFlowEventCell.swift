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
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .ShortStyle
        
        self.textLabel?.text = "\(event.eventTypeName()) - \(dateFormatter.stringFromDate(event.timeStamp))"
    }
}