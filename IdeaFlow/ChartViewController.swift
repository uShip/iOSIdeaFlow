//
//  ChartViewController.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController
{
    @IBOutlet weak var previousDate: UIButton!
    @IBOutlet weak var currentDate: UILabel!
    @IBOutlet weak var nextDate: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        refreshDateLabel()
        
        let longPresser = UILongPressGestureRecognizer(target: self, action: Selector("onLongPress:"))
        self.view.addGestureRecognizer(longPresser)
    }
    
    func onLongPress(gestureRecognizer: UILongPressGestureRecognizer)
    {
        print("\(__FUNCTION__)")
    }
    
    
    @IBAction func goToNextDay(sender: AnyObject)
    {
        IdeaFlowEvent.setSelectedDayWithOffset(1)
        refreshDateLabel()
    }
    
    @IBAction func goToPreviousDay(sender: AnyObject)
    {
        IdeaFlowEvent.setSelectedDayWithOffset(-1)
        refreshDateLabel()
    }
    
    func refreshDateLabel()
    {
        let selectedDate = IdeaFlowEvent.getSelectedDate()
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .ShortStyle
        dateFormatter.timeStyle = .NoStyle
        
        currentDate.text = dateFormatter.stringFromDate(selectedDate)
    }
}