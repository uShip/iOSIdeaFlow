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
    var menuController : MenuController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.menuController = MenuController(presenter: self)
        
        let button = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("addButtonTapped"))
        self.navigationItem.setRightBarButtonItem(button, animated: false)
    }
    
    deinit
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    private func _observeNotifications()
    {
        //Event Lifecycle
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("eventAdded"), name: IdeaFlowEvent.Notifications.EventAdded.rawValue, object: nil)
        notificationCenter.addObserver(self, selector: Selector("eventsDeleted"), name: IdeaFlowEvent.Notifications.AllEventsDeleted.rawValue, object: nil)
        
        //Menu Items
        _observeMenuControllerEvent(.ShowMenu, selector: Selector("didShowMenu"))
        _observeMenuControllerEvent(.DismissMenu, selector: Selector("didDismissMenu"))
        _observeMenuControllerItemSelectedEvent(.Troubleshooting)
        _observeMenuControllerItemSelectedEvent(.Rework)
        _observeMenuControllerItemSelectedEvent(.Learning)
        _observeMenuControllerItemSelectedEvent(.Productivity)
        _observeMenuControllerItemSelectedEvent(.AddDemoEvents)
        _observeMenuControllerItemSelectedEvent(.DeleteAll)
        _observeMenuControllerItemSelectedEvent(.Cancel)
    }
    
    private func _observeMenuControllerItemSelectedEvent(menuItem: MenuControllerItem)
    {
        _observeMenuControllerEvent(.MenuItemSelected(menuItem: menuItem), selector: Selector("didSelect\(menuItem.rawValue)"))
    }
    
    private func _observeMenuControllerEvent(event: MenuControllerEvent, selector: Selector)
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: selector, name: event.toString(), object: nil)
    }
    
    func addButtonTapped()
    {
        menuController?.presentMenu()
    }
    
    func addEvent(eventType: IdeaFlowEvent.EventType)
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        IdeaFlowEvent.addNewEvent(eventType)
    }
    
    func createDemoEvents()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        IdeaFlowEvent.deleteAllEvents()
        IdeaFlowEvent.createDemoEvents()
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