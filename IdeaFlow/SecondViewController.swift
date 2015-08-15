//
//  SecondViewController.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/14/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import UIKit
import CoreData

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet var tableView: UITableView!
    
    var fetchResultsController:NSFetchedResultsController?
    
    deinit
    {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: IdeaFlowEvent.Notifications.EventAdded.rawValue, object: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        fetchResultsController = IdeaFlowEvent.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "startTimeStamp", ascending: true)
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: Selector("eventAdded"), name: IdeaFlowEvent.Notifications.EventAdded.rawValue, object: nil)
        notificationCenter.addObserver(self, selector: Selector("eventsDeleted"), name: IdeaFlowEvent.Notifications.AllEventsDeleted.rawValue, object: nil)
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
        fetchResultsController?.performFetch(&error)
        if let error = error
        {
            println("\(error)")
        }
    }
    
    func eventAdded()
    {
        refresh()
    }
    
    func eventsDeleted()
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
                if let sectionInfo = sections[section] as? NSFetchedResultsSectionInfo
                {
                    return sectionInfo.numberOfObjects
                }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destination = segue.destinationViewController as? IdeaFlowEventDetailsViewController, cell = sender as? IdeaFlowEventCell
        {
            destination.eventIdentifier = cell.eventIdentifier
        }
    }
}

