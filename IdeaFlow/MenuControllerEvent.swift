//
//  MenuControllerEvent.swift
//  IdeaFlow
//
//  Created by Matthew Hayes on 9/2/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import Foundation

enum MenuControllerEvent
{
    case ShowMenu
    case DismissMenu
    case MenuItemSelected(menuItem: MenuControllerItem)
    case UndefinedDefault
    
    func toString() -> String
    {
        switch self
        {
        case .ShowMenu:
            return "Show Menu"
        case .DismissMenu:
            return "Dismiss Menu"
        case let .MenuItemSelected(menuItem: menuItem):
            return "Menu Item Selected - \(menuItem.rawValue)"
        case .UndefinedDefault:
            return "UndefinedDefault"
        }
    }
    
    func notificationName() -> String
    {
        let prefix = "MenuControllerEvent "
        switch self
        {
        case .MenuItemSelected(menuItem: _):
            return "\(prefix)Menu Item Selected - \(self.toString())"
        default:
            return "\(prefix)\(self.toString())"
        }
        
    }
    
    func notification(sender sender: AnyObject?) -> NSNotification
    {
        var userInfo: [String:AnyObject]?
        
        switch self
        {
        case let .MenuItemSelected(menuItem: menuItem):
            userInfo = ["menuItem" : menuItem.rawValue]
        default:
            userInfo = nil
        }
        
        return NSNotification(name: notificationName(), object: sender, userInfo: userInfo)
    }
}

enum MenuControllerItem: String
{
    case Troubleshooting = "Troubleshooting"
    case Rework = "Rework"
    case Learning = "Learning"
    case Productivity = "Productivity"
    case Pause = "Pause"
    case AddDemoEvents = "Add Demo Events"
    case DeleteAll = "Delete All"
    case Cancel = "Cancel"
}

extension NSNotificationCenter
{
    func addObserverForMenuControllerEvents(observer: AnyObject, selector: Selector)
    {
        _observeMenuControllerEvent(observer, event:.ShowMenu, selector: selector)
        _observeMenuControllerEvent(observer, event:.DismissMenu, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.Troubleshooting, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.Rework, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.Learning, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.Productivity, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.Pause, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.AddDemoEvents, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.DeleteAll, selector: selector)
        _observeMenuControllerItemSelectedEvent(observer, menuItem:.Cancel, selector: selector)
    }
    
    private func _observeMenuControllerItemSelectedEvent(observer: AnyObject, menuItem: MenuControllerItem, selector: Selector)
    {
        _observeMenuControllerEvent(observer, event:.MenuItemSelected(menuItem: menuItem), selector: selector)
    }
    
    private func _observeMenuControllerEvent(observer: AnyObject, event: MenuControllerEvent, selector: Selector)
    {
        let notification = event.notification(sender: nil)
        print(notification)
        addObserver(observer, selector: selector, name: notification.name, object: nil)
    }
}

extension NSNotification
{
    func convertToMenuControllerEvent() -> MenuControllerEvent?
    {
        switch name
        {
        case MenuControllerEvent.ShowMenu.notificationName():
            return MenuControllerEvent.ShowMenu
        case MenuControllerEvent.DismissMenu.notificationName():
            return MenuControllerEvent.DismissMenu
        default:
            if let rawMenuItem = userInfo?["menuItem"] as? String,
                menuItem = MenuControllerItem(rawValue: rawMenuItem)
            {
                return MenuControllerEvent.MenuItemSelected(menuItem: menuItem)
            }
            else
            {
                return nil
            }
        }
    }
}