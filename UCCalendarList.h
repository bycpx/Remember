//
//  UCCalendarList.h
//  Remember
//
//  Created by Christoph on 03.06.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CalendarStore/CalendarStore.h>

extern NSString *const UCIsGroup;

@class UCColorDot;

@interface UCCalendarList : NSObject
{
NSUInteger activeCount;
NSUInteger eventCount;

@private
	NSMutableArray * _events;
	NSDate * _now;
	NSCalendar * calendar;
	NSDateFormatter * weekdayFormatter;
	NSDateFormatter * dayFormatter;
	NSDateFormatter * timeFormatter;
}

+ (UCCalendarList *)calendarListWithEvents:(NSArray *)events;
+ (UCCalendarList *)calendarListWithPredicates:(NSPredicate *)predicate;

- (id)initWithEvents:(NSArray *)events;
- (id)initWithPredicate:(NSPredicate *)predicate;
- (void)setEvents:(NSArray *)events;

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index;
@property(readonly) NSUInteger count;
@property(readonly) NSUInteger activeCount;
@property(readonly) NSUInteger eventCount;

- (NSDictionary *)dictionaryForDate:(NSDate *)aDate now:(NSDate *)now;
- (NSDictionary *)dictionaryForEvent:(CalEvent *)anEvent now:(NSDate *)now;
- (BOOL)date:(NSDate *)aDate isSameDayAs:(NSDate *)anotherDate;

@end
