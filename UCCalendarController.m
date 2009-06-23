#import "UCCalendarController.h"

@implementation UCCalendarController

- (id)init
{
	if(self=[super init])
		{
		calendarList = nil;
		}
	
	return self;
}

- (void)dealloc
{
	[timer invalidate];
	[timer release];
	[calendarList release];
	[super dealloc];
}

- (void)awakeFromNib
{
	[tableView setDoubleAction:@selector(openEvent:)];
	[tableView setTarget:self];

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(eventsChanged:) name:CalEventsChangedExternallyNotification object:[CalCalendarStore defaultCalendarStore]];
	timer = [[NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES] retain];

	[self refresh:self];
}

#pragma mark -

- (void)timerFired:(NSTimer *)theTimer
{
	[self refresh:self];
}

- (void)eventsChanged:(id)aNotification
{
	[self refresh:self];
}

- (IBAction)refresh:(id)sender
{
//	NSLog(@"Refresh ...");
	[calendarList release];
	NSPredicate * eventRange = [CalCalendarStore eventPredicateWithStartDate:
		[[NSCalendarDate date] dateByAddingYears:0 months:0 days:-1 hours:0 minutes:0 seconds:0] endDate:
		[[NSCalendarDate date] dateByAddingYears:0 months:0 days:7 hours:0 minutes:0 seconds:0] calendars:
		[[CalCalendarStore defaultCalendarStore] calendars]];
	calendarList = [[UCCalendarList alloc] initWithPredicate:eventRange];
	
	if([calendarList activeCount]>0)
		{ [[NSApp dockTile] setBadgeLabel:[NSString stringWithFormat:@"%d",[calendarList activeCount]]]; }
	else
		{ [[NSApp dockTile] setBadgeLabel:nil]; }

	[tableView reloadData];
//	NSLog(@"Refreshed.");
}

- (IBAction)openEvent:(id)sender
{
	NSInteger row = [tableView clickedRow];
	
	if([sender isKindOfClass:[NSTableView class]] && row!=-1 || [sender isKindOfClass:[NSMenuItem class]])
		{
		if(row==-1) { row=[tableView selectedRow]; }
		NSLog(@"Öffnen: %@", [calendarList dictionaryAtIndex:row]);
		}
}

#pragma mark Data Source

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [calendarList count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return [[calendarList dictionaryAtIndex:rowIndex] objectForKey:[aTableColumn identifier]];
/*	else
		{
		if([[aTableColumn identifier] isEqualToString:@"UCDate"])
			{
			return [dayFormatter stringFromDate:(NSDate *)item];
			}
		else if([[aTableColumn identifier] isEqualToString:@"UCTitle"])
			{
			if([self date:[NSDate date] isSameDayAs:(NSDate *)item])
				{
				return NSLocalizedString(@"Today", @"Header for today’s date group");
				}
			else
				{
				return [weekdayFormatter stringFromDate:(NSDate *)item];
				}
			}
		else if([[aTableColumn identifier] isEqualToString:@"UCColorDot"] && [self date:[NSDate date] isSameDayAs:(NSDate *)item])
			{
			return [NSImage imageNamed:@"TodayTemplate"];
			}
		}
*/	
	return nil;
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
	return [[calendarList dictionaryAtIndex:row] objectForKey:@"UCIsGroup"]!=nil;
}

- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex
{
	return ![self tableView:aTableView isGroupRow:rowIndex];
}

#pragma mark -

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
if([menuItem action]==@selector(openEvent:))
	{ return [tableView selectedRow]!=-1; }
return YES;
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication
{
	[window makeKeyAndOrderFront:self];
	[self refresh:self];
	return YES;
}

- (NSRect)windowWillUseStandardFrame:(NSWindow *)aWindow defaultFrame:(NSRect)defaultFrame
{
	NSRect currentFrame = [aWindow frame];
	CGFloat oldHeight=currentFrame.size.height;
	
	currentFrame.size.height = currentFrame.size.height-[scrollView frame].size.height+[tableView frame].size.height;
	currentFrame.origin.y = currentFrame.origin.y+oldHeight - currentFrame.size.height;
	return currentFrame;
}

@end
