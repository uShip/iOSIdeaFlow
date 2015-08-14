//
//  TabBarController.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import UIKit

class TabBarController : UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addButtonTapped"))
        self.navigationItem.setRightBarButtonItem(button, animated: false)
    }
    
    func addButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Troubleshooting", style: .Default, handler: { [weak self] (action) -> Void in
            self?.createNewEvent(IdeaFlowEventType.Troubleshooting)
        }))
        alert.addAction(UIAlertAction(title: "Learning", style: .Default, handler: { [weak self] (action) -> Void in
            self?.createNewEvent(IdeaFlowEventType.Learning)
        }))
        alert.addAction(UIAlertAction(title: "Rework", style: .Default, handler: { [weak self] (action) -> Void in
            self?.createNewEvent(IdeaFlowEventType.Rework)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func createNewEvent(eventType: IdeaFlowEventType) {
        let newEvent = IdeaFlowEvent.MR_createEntity()
        newEvent.timeStamp = NSDate()
        switch (eventType) {
            case .Productivity:
                newEvent.eventType = NSNumber(int: 0)
            case .Troubleshooting:
                newEvent.eventType = NSNumber(int: 1)
            case .Learning:
                newEvent.eventType = NSNumber(int: 2)
            case .Rework:
                newEvent.eventType = NSNumber(int: 3)
            case .Unknown:
                newEvent.eventType = NSNumber(int: 4)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName("New Event", object: self)
    }
}