//
//  IdeaFlowNote+Stuff.swift
//  IdeaFlow
//
//  Created by Matt Hayes on 8/15/15.
//  Copyright (c) 2015 uShip. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

extension IdeaFlowNote
{
    class func createNote(event: IdeaFlowEvent, noteContent: String)
    {
        let predicate = NSPredicate(format: "event.identifier = '%@'", event.identifier)
        IdeaFlowNote.MR_deleteAllMatchingPredicate(predicate)
        print("\(IdeaFlowNote.MR_countOfEntities())")
        
        let note = IdeaFlowNote.MR_createEntity()
        note.timeStamp = NSDate()
        note.noteContent = noteContent
        note.event = event
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
}