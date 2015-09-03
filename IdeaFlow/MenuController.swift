//
//  MenuController.swift
//  IdeaFlow
//
//  Created by Matthew Hayes on 9/2/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import UIKit

class MenuController
{
    var presenter: UIViewController?
    init(presenter: UIViewController)
    {
        self.presenter = presenter
    }
    
    func presentMenu()
    {
        presenter!.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Private Inner Workings
 
    private var _alertController: UIAlertController?
    private var alertController: UIAlertController!
    {
        get
        {
            if _alertController == nil
            {
                _alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
                _populateMenu()
            }
            return _alertController
        }
    }
    
    private func _populateMenu()
    {
        _addMenuItem(.Productivity)
        _addMenuItem(.Troubleshooting)
        _addMenuItem(.Learning)
        _addMenuItem(.Rework)
        _addMenuItem(.AddDemoEvents)
        _addMenuItem(.DeleteAll, style: .Destructive)
        _addMenuItem(.Cancel, style: .Cancel)
    }
    
    private func _addMenuItem(menuItem: MenuControllerItem, style: UIAlertActionStyle = .Default)
    {
        alertController?.addAction(UIAlertAction(title: menuItem.rawValue, style: UIAlertActionStyle.Default, handler: { [weak self] (action) -> Void in
            
            self?._menuItemSelected(menuItem)
            
        }))
    }
    
    private func _menuItemSelected(menuItem: MenuControllerItem)
    {
        let notificationCenter = NSNotificationCenter.defaultCenter()
        
        let notificationName = MenuControllerEvent.MenuItemSelected(menuItem: menuItem).toString()
        
        notificationCenter.postNotificationName(notificationName, object: self)
    }
}