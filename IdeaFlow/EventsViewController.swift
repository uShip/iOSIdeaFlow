//
//  EventsViewController.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import UIKit
import CoreData

class EventsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    
    var fetchResultsController:NSFetchedResultsController?
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchResultsController = IdeaFlowEvent.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "startTimeStamp", ascending: true)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserverForIdeaFlowEvents(self, selector: Selector("didReceiveIdeaFlowEvent:"))
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        refresh()
    }
    
    func refresh()
    {
        performFetch()
        tableView.reloadData()
    }

    func performFetch()
    {
        var error:NSError?
        do {
            try fetchResultsController?.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        if let error = error
        {
            print("\(error)")
        }
    }
    
    func didReceiveIdeaFlowEvent(notification: NSNotification)
    {
        refresh()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {
        return fetchResultsController?.sections?.count ?? 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let sections = fetchResultsController?.sections
        {
            if sections.count > section
            {
                let sectionInfo = sections[section]
                return sectionInfo.numberOfObjects
            }
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("IdeaFlowEventCell") as? IdeaFlowEventCell
        
        let ideaFlowEvent = fetchResultsController?.objectAtIndexPath(indexPath) as! IdeaFlowEvent
        
        cell?.populate(ideaFlowEvent)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if editingStyle == UITableViewCellEditingStyle.Delete
        {
            let ideaFlowEvent = fetchResultsController?.objectAtIndexPath(indexPath) as! IdeaFlowEvent
            ideaFlowEvent.MR_deleteEntity()
            performFetch()
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let destination = segue.destinationViewController as? IdeaFlowEventDetailsViewController, cell = sender as? IdeaFlowEventCell
        {
            destination.eventIdentifier = cell.eventIdentifier
        }
    }
}

