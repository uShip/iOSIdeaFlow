//
//  AppDelegate.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import UIKit
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        MagicalRecord.setupAutoMigratingCoreDataStack()
        return true
    }

    func applicationWillTerminate(application: UIApplication)
    {
        MagicalRecord.cleanUp()
    }


}

