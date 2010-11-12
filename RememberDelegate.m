//
//  RememberDelegate.m
//  Remember
//
//  Created by Christoph on 25.05.2009.
//  Copyright 2009-2010 Useless Coding. All rights reserved.
//

#import "RememberDelegate.h"
#import "UCCalendarList.h"

@implementation RememberDelegate

- (void)awakeFromNib
{
	[tableView setDoubleAction:@selector(openEvent:)];
	[tableView setTarget:self];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsChanged:) name:CalEventsChangedExternallyNotification object:[CalCalendarStore defaultCalendarStore]];
	timer = [[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES] retain];

	statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSSquareStatusItemLength];
	[statusItem retain];

	[statusItem setImage:[NSImage imageNamed:@"TodayTemplate"]];
	[statusItem setHighlightMode:YES];
	[statusItem setMenu:statusMenu];

	[self refresh:self];
}

- (void)dealloc
{
	[timer invalidate];
	[timer release];
	[calendarList release];
	[statusItem release];
	[super dealloc];
}

#pragma mark -

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication
{
	[window makeKeyAndOrderFront:self];
	return YES;
}

#pragma mark Timer and Notification

- (void)timerFired:(NSTimer *)theTimer
{
	[self refresh:self];
}

- (void)eventsChanged:(id)aNotification
{
	[self refresh:self];
}

#pragma mark Actions

- (IBAction)refresh:(id)sender
{
	[calendarList release];
	NSPredicate * eventRange = [CalCalendarStore eventPredicateWithStartDate:
								[[NSCalendarDate date] dateByAddingYears:0 months:0 days:-1 hours:0 minutes:0 seconds:0] endDate:
								[[NSCalendarDate date] dateByAddingYears:0 months:0 days:7 hours:0 minutes:0 seconds:0] calendars:
								[[CalCalendarStore defaultCalendarStore] calendars]];
	calendarList = [[UCCalendarList alloc] initWithPredicate:eventRange];

	switch(calendarList.activeCount) {
		case 0: [[statusMenu itemAtIndex:0] setTitle:@"No Events"];
			[[NSApp dockTile] setBadgeLabel:nil];
			break;
		case 1: [[statusMenu itemAtIndex:0] setTitle:@"One Event"];
			[[NSApp dockTile] setBadgeLabel:@"1"];
			break;
		default:  [[statusMenu itemAtIndex:0] setTitle:[NSString stringWithFormat:@"%d Events", calendarList.activeCount]];
			[[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%d", calendarList.activeCount]];
	}

	[tableView reloadData];
}

- (IBAction)openEvent:(id)sender
{
	NSInteger row = [tableView clickedRow];

	if([sender isKindOfClass:[NSTableView class]] && row!=-1 || [sender isKindOfClass:[NSMenuItem class]]) {
		if(row==-1) { row=[tableView selectedRow]; }
		NSLog(@"Öffnen: %@", [calendarList dictionaryAtIndex:row]);
	}
}

#pragma mark Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return calendarList.count;
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return [[calendarList dictionaryAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
	return [[calendarList dictionaryAtIndex:row] objectForKey:UCIsGroup]!=nil;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	return ![self tableView:aTableView isGroupRow:rowIndex];
}

#pragma mark Validation

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
	if([menuItem action]==@selector(openEvent:)) {
		return [tableView selectedRow]!=-1;
	}
	return YES;
}

#pragma mark Window Delegate

- (NSRect)windowWillUseStandardFrame:(NSWindow *)aWindow defaultFrame:(NSRect)defaultFrame
{
	NSRect currentFrame = [aWindow frame];
	CGFloat oldHeight=currentFrame.size.height;

	currentFrame.size.height = currentFrame.size.height-[scrollView frame].size.height+[tableView frame].size.height;
	currentFrame.origin.y = currentFrame.origin.y+oldHeight - currentFrame.size.height;
	return currentFrame;
}

@end
