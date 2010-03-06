//
//  UCCalendarList.m
//  Remember
//
//  Created by Christoph on 03.06.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
//

#import "UCCalendarList.h"
#import "UCColorDot.h"

static NSString * sColorDot = @"UCColorDot";
static NSString * sTitle = @"UCTitle";
static NSString * sDate = @"UCDate";
NSString *const UCIsGroup = @"UCIsGroup";


@implementation UCCalendarList

+ (UCCalendarList *)calendarListWithEvents:(NSArray *)events
{
	return [[[self alloc] initWithEvents:events] autorelease];
}

+ (UCCalendarList *)calendarListWithPredicates:(NSPredicate *)predicate
{
	return [[[self alloc] initWithPredicate:predicate] autorelease];
}

- (id)initWithPredicate:(NSPredicate *)predicate
{
	if(self = [self init])
		{
		[self setEvents:[[CalCalendarStore defaultCalendarStore] eventsWithPredicate:predicate]];
		}
	return self;
}

- (id)initWithEvents:(NSArray *)events
{
	if(self = [self init])
		{
		[self setEvents:events];
		}
	return self;
}

- (id)init
{
	if(self = [super init])
		{
		calendar = [[NSCalendar currentCalendar] retain];
		_now = [[NSDate alloc] init];
		
		[NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehavior10_4];
		weekdayFormatter = [[NSDateFormatter alloc] init];
		[weekdayFormatter setDateFormat:@"EE"];

		dayFormatter = [[NSDateFormatter alloc] init];
		[dayFormatter setDateStyle:NSDateFormatterMediumStyle];
		[dayFormatter setTimeStyle:NSDateFormatterNoStyle];
		
		timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateStyle:NSDateFormatterNoStyle];
		[timeFormatter setTimeStyle:NSDateFormatterShortStyle];
		}
	return self;
}

- (void)dealloc
{
	[calendar release];
	[_now release];
	[weekdayFormatter release];
	[dayFormatter release];
	[timeFormatter release];
	[_events release];
	[super dealloc];
}

#pragma mark -

- (void)setEvents:(NSArray *)events
{
	CalEvent * event;
	NSDate * lastDate = [[NSDate distantPast] retain];

	[_events release];
	eventCount = [events count];
	_events = [[NSMutableArray arrayWithCapacity:eventCount] retain];
	activeCount=0;

	for(NSUInteger i=0; i<eventCount; i++)
		{
		event = (CalEvent *)[events objectAtIndex:i];

		if(![self date:lastDate isSameDayAs:event.startDate])
			{
			if([_now compare:event.startDate]==NSOrderedAscending && ![self date:event.startDate isSameDayAs:_now]
					&& [lastDate compare:_now]==NSOrderedAscending && ![self date:lastDate isSameDayAs:_now])
				{
				[_events addObject:[self dictionaryForDate:_now now:_now]];
				}
			[lastDate release];
			lastDate = [event.startDate retain];
			[_events addObject:[self dictionaryForDate:lastDate now:_now]];
			}

		[_events addObject:[self dictionaryForEvent:event now:_now]];
		}

	if([lastDate compare:_now]==NSOrderedAscending)
		{
		[_events addObject:[self dictionaryForDate:_now now:_now]];
		}

	[lastDate release];
}

- (NSDictionary *)dictionaryAtIndex:(NSUInteger)index
{
	return (NSDictionary *)[_events objectAtIndex:index];
}

- (NSUInteger)count
{
	return [_events count];
}

@synthesize activeCount, eventCount;

#pragma mark -

- (NSDictionary *)dictionaryForDate:(NSDate *)aDate now:(NSDate *)now
{
	NSDictionary * entry;
	if([self date:aDate isSameDayAs:now])
		{
		entry = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt:1], UCIsGroup,
			[NSImage imageNamed:@"TodayTemplate"], sColorDot,
			[weekdayFormatter stringFromDate:aDate], sTitle,
			[dayFormatter stringFromDate:aDate], sDate,
		nil];
		}
	else
		{
		entry = [NSDictionary dictionaryWithObjectsAndKeys:
			[NSNumber numberWithInt:1], UCIsGroup,
			[weekdayFormatter stringFromDate:aDate], sTitle,
			[dayFormatter stringFromDate:aDate], sDate,
		nil];
		}
	return entry;
}

- (NSDictionary *)dictionaryForEvent:(CalEvent *)anEvent now:(NSDate *)now
{
	NSString * title;
	NSString * time;
	NSInteger state;

	if(anEvent.location!=nil)
		{
		title = [NSString stringWithFormat:@"%@ \u2014 %@", anEvent.title, anEvent.location];
		}
	else
		{
		title = anEvent.title;
		}
	if([anEvent.startDate compare:now]==NSOrderedAscending)
		{
		if([anEvent.endDate compare:now]==NSOrderedAscending)
			{
			state=2;
			} // danach
		else
			{
			state=1;
			activeCount++;
			} // aktiv
		}
	else
		{
		state=-1;
		} // vorher
	if(anEvent.isAllDay)
		{
		time = NSLocalizedString(@"\u301c   ",@"Time for all-day events");
		}
	else
		{
		time = [timeFormatter stringFromDate:anEvent.startDate];
		}
	return [NSDictionary dictionaryWithObjectsAndKeys:
			[UCColorDot imageWithColor:anEvent.calendar.color state:state], sColorDot,
			title, sTitle,
			time, sDate,
		nil];
}

- (BOOL)date:(NSDate *)aDate isSameDayAs:(NSDate *)anotherDate
{
	NSDateComponents * someComps =[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:aDate];
	NSDateComponents * otherComps =[calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:anotherDate];

	return [someComps year]==[otherComps year] && [someComps month]==[otherComps month] && [someComps day]==[otherComps day];
}

@end
