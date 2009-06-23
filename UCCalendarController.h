#import <Cocoa/Cocoa.h>
#import <CalendarStore/CalendarStore.h>
#import "UCColorDot.h"
#import "UCCalendarList.h"

@interface UCCalendarController : NSObject
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

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView;
- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex;
- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row;
- (BOOL)tableView:(NSTableView *)aTableView shouldSelectRow:(NSInteger)rowIndex;

@end
