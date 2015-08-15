//
//  TabBarController.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import MagicalRecord

class TabBarController : UITabBarController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addButtonTapped"))
        self.navigationItem.setRightBarButtonItem(button, animated: false)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("eventAdded"), name: IdeaFlowEvent.Notifications.EventAdded.rawValue, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("eventsDeleted"), name: IdeaFlowEvent.Notifications.AllEventsDeleted.rawValue, object: nil)
    }
    
    func addButtonTapped()
    {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        
        alert.addAction(UIAlertAction(title: "Troubleshooting", style: UIAlertActionStyle.Default, handler: { [weak self] (action) -> Void in
            self?.createEvent(.Troubleshooting)
        }))
        
        alert.addAction(UIAlertAction(title: "Learning", style: .Default, handler: { [weak self] (action) -> Void in
            self?.createEvent(.Learning)
        }))
        
        alert.addAction(UIAlertAction(title: "Rework", style: .Default, handler: { [weak self] (action) -> Void in
            self?.createEvent(.Rework)
        }))
        
        alert.addAction(UIAlertAction(title: "Delete All", style: .Destructive, handler: { [weak self] (action) -> Void in
            self?.deleteAllEvents()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func createEvent(eventType: IdeaFlowEvent.EventType)
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        IdeaFlowEvent.createNewEvent(eventType)
    }
    
    func deleteAllEvents()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        IdeaFlowEvent.deleteAllEvents()
    }

    
    func eventAdded()
    {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
    
    func eventsDeleted()
    {
        MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
    }
}