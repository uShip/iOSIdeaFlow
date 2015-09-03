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
        }
    }
}

enum MenuControllerItem: String
{
    case Troubleshooting = "Troubleshooting"
    case Rework = "Rework"
    case Learning = "Learning"
    case Productivity = "Productivity"
    case AddDemoEvents = "Add Demo Events"
    case DeleteAll = "Delete All"
    case Cancel = "Cancel"
}