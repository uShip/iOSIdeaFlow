//
//  IdeaFlowEvent.h
//  
//
//  Created by Matt Hayes on 8/14/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface IdeaFlowEvent : NSManagedObject

@property (nonatomic, retain) NSNumber * eventType;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * notes;

@end
