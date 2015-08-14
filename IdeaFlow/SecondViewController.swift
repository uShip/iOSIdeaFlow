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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Fix the silly thing where the first table cells were hidden under the nav bar
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        
        // Configure the fetch results controller so we can grab core data stuffs
        fetchResultsController = IdeaFlowEvent.MR_fetchAllGroupedBy(nil, withPredicate: nil, sortedBy: "startTimeStamp", ascending: true)
        
        
        performFetch()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("eventAdded"), name: "New Event", object: nil)
    }

    func performFetch() {
        var error:NSError?
        fetchResultsController?.performFetch(&error)
        if let error = error
        {
            println("\(error)")
        }
    }
    
    func eventAdded() {
        performFetch()
        tableView.reloadData()
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IdeaFlowEventCell") as? IdeaFlowEventCell
        
        let ideaFlowEvent = fetchResultsController?.objectAtIndexPath(indexPath) as! IdeaFlowEvent
        
        cell?.populate(ideaFlowEvent)
        
        return cell!
    }
}

