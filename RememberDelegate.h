//
//  RememberDelegate.h
//  Remember
//
//  Created by Christoph on 25.05.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CalendarStore/CalendarStore.h>

@class UCCalendarList;

@interface RememberDelegate : NSObject
{
    IBOutlet NSTableView * tableView;
	IBOutlet NSScrollView * scrollView;
	IBOutlet NSWindow * window;

@private
	NSTimer * timer;
	UCCalendarList * calendarList;
}

- (void)timerFired:(NSTimer *)theTimer;
- (void)eventsChanged:(id)aNotification;
- (IBAction)refresh:(id)sender;
- (IBAction)openEvent:(id)sender;

@end
