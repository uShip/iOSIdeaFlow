//
//  IdeaFlowEventDetailsViewController.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/15/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import UIKit

class IdeaFlowEventDetailsViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.lightGrayColor()
        
        startDate.text = ""
        endDate.text = ""
        textView.text = ""
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if let event = IdeaFlowEvent.MR_findFirstByAttribute("identifier", withValue: eventIdentifier)
        {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .ShortStyle
            startDate.text = dateFormatter.stringFromDate(event.startTimeStamp)
            
            if event.notes.count > 0
            {
                if let note = event.notes.allObjects[0] as? IdeaFlowNote
                {
                    textView.text = note.noteContent
                }
            }
        }
    }
    
    var eventIdentifier:String?
    
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    @IBAction func saveEventDetails(sender: AnyObject)
    {
        let event = IdeaFlowEvent.MR_findFirstByAttribute("identifier", withValue: eventIdentifier)
        IdeaFlowNote.createNote(event, noteContent: textView.text)
    }

}
