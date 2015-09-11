//
//  IdeaFlowDataExporter.swift
//  IdeaFlow
//
//  Created by Matthew Hayes on 9/10/15.
//  Copyright © 2015 uShip. All rights reserved.
//

import Foundation
import UIKit

private extension Int {
    func format(f: String) -> String
    {
        return NSString(format: "%\(f)d", self) as String
    }
}

class IdeaFlowDataExporter
{
    var fileHandles = [String:NSFileHandle]()
    
    private func _getOrCreateHandleForFile(atPath filePath: String) -> NSFileHandle?
    {
        var fileHandle = fileHandles["\(filePath)"]
        if fileHandle == nil
        {
            fileHandle = _createAndRememberHandleForFile(atPath: filePath)
        }
        return fileHandle
    }
    
    private func _getPathForFileHandle(fileHandle: NSFileHandle?) -> String?
    {
        if let fileHandle = fileHandle
        {
            for (key,handle) in fileHandles
            {
                if handle == fileHandle
                {
                    return key
                }
            }
        }
        return nil
    }
    
    func exportAll(completion: (() -> Void)?)
    {
        if let dates = IdeaFlowEvent.getDatesThatHaveEvents()
        {
            for date in dates
            {
                let filePath = _filePathForDay(date)
                _ = _getOrCreateHandleForFile(atPath: filePath)
                _createFileIfNecessary(filePath)
            }
            
            for (_, fileHandle) in fileHandles
            {
                _truncateExistingFile(withHandle: fileHandle)
            }
            
            //export each date.  dates that fall on the same day will append to the same file
            for date in dates
            {
                _exportDate(date, completion:nil)
            }
            
            for (_,fileHandle) in fileHandles
            {
                fileHandle.closeFile()
            }
        }
        completion?()
    }
    
    private func _exportDate(date: NSDate, completion: (() -> Void)?)
    {
        let filePath = _filePathForDay(date)
        let fileHandle = _getOrCreateHandleForFile(atPath: filePath)

        var stringToWrite = ""
        
        if let eventsForDay = IdeaFlowEvent.getEventsForDay(date)
        {
            for event in eventsForDay
            {
                stringToWrite.appendContentsOf(event.asCSV())
                stringToWrite.appendContentsOf("\n")
            }
        }
        
        if let dataToWrite = stringToWrite.dataUsingEncoding(NSUTF8StringEncoding)
        {
            fileHandle?.truncateFileAtOffset(fileHandle?.seekToEndOfFile() ?? 0)
            fileHandle?.writeData(dataToWrite)
        }
        
        completion?()
    }
    
    private func _documentsDirectoryPath() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        return paths.first!
    }
    
    private func _filePathForDay(day: NSDate) -> String
    {
        let dayComponents = day.dayComponents()
        let yearString = dayComponents.year.format("04")
        let monthString = dayComponents.month.format("02")
        let dayString = dayComponents.day.format("02")
        let dateString = "\(yearString)\(monthString)\(dayString)"
        let filePath =  "\(_documentsDirectoryPath())/\(dateString).csv"
        return filePath
    }
    
    private func _createFileIfNecessary(filePath: String) -> NSFileHandle?
    {
        var writeHeaders = false
        
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(filePath) == false
        {
            filemanager.createFileAtPath(filePath, contents: nil, attributes: nil)
            writeHeaders = true
            print("created export file at path : \(filePath)")
        }
        
        let fileHandle = _getOrCreateHandleForFile(atPath: filePath)
        
        if (writeHeaders)
        {
            _writeColumnHeadersToFile(withHandle: fileHandle)
        }
        
        return fileHandle
    }
    
    private func _writeColumnHeadersToFile(withHandle fileHandle: NSFileHandle?)
    {
        if let fileHandle = fileHandle
        {
            let stringToWrite = IdeaFlowEvent.csvColumnNames() + "\n"
            
            if let dataToWrite = stringToWrite.dataUsingEncoding(NSUTF8StringEncoding)
            {
                fileHandle.truncateFileAtOffset(fileHandle.seekToEndOfFile())
                fileHandle.writeData(dataToWrite)
            }
        }
    }
    
    private func _createAndRememberHandleForFile(atPath filePath:String) -> NSFileHandle?
    {
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(filePath) == true
        {
            let fileHandle = NSFileHandle(forUpdatingAtPath: filePath)
            if let oldFileHandle = fileHandles["\(filePath)"]
            {
                oldFileHandle.closeFile()
            }
            fileHandles["\(filePath)"] = fileHandle
            return fileHandle
        }
        return nil
    }
    
    private func _truncateExistingFile(withHandle fileHandle: NSFileHandle?)
    {
        if let fileHandle = fileHandle
        {
            if fileHandle.seekToEndOfFile() > 0
            {
                fileHandle.truncateFileAtOffset(0)
                _writeColumnHeadersToFile(withHandle: fileHandle)
                print("truncated file: \(_getPathForFileHandle(fileHandle))")
            }
        }
    }
}