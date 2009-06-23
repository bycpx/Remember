//
//  AppDelegate.m
//  Remember
//
//  Created by Christoph on 25.05.09.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)awakeFromNib
{
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication
{
	[window makeKeyAndOrderFront:self];
	return YES;
}

/*
- (void)windowWillClose:(NSNotification *)notification
{
	[NSApp terminate:self];
}
*/

- (NSRect)windowWillUseStandardFrame:(NSWindow *)aWindow defaultFrame:(NSRect)defaultFrame
{
	NSRect currentFrame = [aWindow frame];
	CGFloat oldHeight=currentFrame.size.height;
	
	currentFrame.size.height = currentFrame.size.height-[scrollView frame].size.height+[tableView frame].size.height;
	currentFrame.origin.y = currentFrame.origin.y+oldHeight - currentFrame.size.height;
	return currentFrame;
}

@end
