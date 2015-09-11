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
        
        _observeNotifications()
    }
    
    deinit
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.removeObserver(self)
    }
    
    private func _observeNotifications()
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserverForIdeaFlowEvents(self, selector: Selector("didReceiveIdeaFlowEvent:"))
        notificationCenter.addObserverForMenuControllerEvents(self, selector: Selector("didReceiveMenuControllerEvent:"))
    }
    
    func didReceiveIdeaFlowEvent(notification: NSNotification)
    {
        if let event = notification.convertToIdeaFlowEventNotification()
        {
            switch event
            {
            case .AllEventsDeleted:
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            case .EventAdded:
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            case .SelectedDateChanged:
                break
            }
        }
    }
    
    func didReceiveMenuControllerEvent(notification: NSNotification)
    {
        if let menuControllerEvent = notification.convertToMenuControllerEvent()
        {
            switch menuControllerEvent
            {
            case let .MenuItemSelected(menuItem: menuItem):
                switch menuItem
                {
                case .Troubleshooting:
                    addEvent(.Troubleshooting)
                case .Rework:
                    addEvent(.Rework)
                case .Productivity:
                    addEvent(.Productivity)
                case .Learning:
                    addEvent(.Learning)
                case .Pause:
                    addEvent(.Pause)
                case .DeleteAll:
                    deleteAllEvents()
                case .AddDemoEvents:
                    createDemoEvents()
                case .ExportAll:
                    exportAllEvents()
                default:
                    break
                }
            default:
                break
            }
        }
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
    
    func exportAllEvents()
    {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        IdeaFlowDataExporter().exportAll { [weak self] () -> () in
            MBProgressHUD.hideAllHUDsForView(self?.view, animated: true)
        }
    }
}