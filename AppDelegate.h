//
//  AppDelegate.h
//  Remember
//
//  Created by Christoph on 25.05.09.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <CalendarStore/CalendarStore.h>


@interface AppDelegate : NSObject
{
	IBOutlet NSTableView * tableView;
	IBOutlet NSScrollView * scrollView;
	IBOutlet NSWindow * window;
}

@end
