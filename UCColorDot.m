//
//  UCColorDot.m
//  Remember
//
//  Created by Christoph on 25.05.09.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import "UCColorDot.h"


@implementation UCColorDot

+ (NSImage *)imageWithColor:(NSColor *)aColor state:(NSInteger)aState
{
	UCColorDot * temp = [[[self alloc] initWithColor:aColor state:aState] autorelease];
	return [temp image];
}

+ (NSImage *)imageWithColor:(NSColor *)aColor
{
	return [self imageWithColor:aColor state:0];
}

- (id)init
{
	if(self = [super init])
		{
		colorDot = [[NSImage alloc] initWithSize:NSMakeSize(16.0,16.0)];
		shadow = [[NSShadow alloc] init];
		[shadow setShadowOffset:NSMakeSize(0,-1)];
		[shadow setShadowBlurRadius:2];
		[shadow setShadowColor:[NSColor shadowColor]];
		}
		
	return self;
}

- (id)initWithColor:(NSColor *)aColor state:(NSInteger)aState;
{
	if(self=[self init])
		{
		gradient = nil;
		[self setColor:aColor];
		[self setState:aState];
		}
	
	return self;
}

- (id)initWithColor:(NSColor *)aColor
{
	return [self initWithColor:aColor state:0];
}

- (void)dealloc
{
	[color release];
	[shadow release];
	[gradient release];
	[colorDot release];
	[super dealloc];
}

@synthesize color, state;

- (void)setColor:(NSColor *)aColor
	{
	[color release];
	color = [aColor copy];
	[gradient release];
	gradient = [[NSGradient alloc] initWithStartingColor:[color highlightWithLevel:0.8] endingColor:color];
	}

- (NSImage *)image
{
	[colorDot lockFocus];
		[color set];
		NSBezierPath * circle = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(3,4, 10,10)];
		[circle setLineWidth:0.75];
		[NSGraphicsContext saveGraphicsState];
			[shadow set];
			[circle fill];
		[NSGraphicsContext restoreGraphicsState];
		[[color colorWithAlphaComponent:0.5] set];
		[gradient drawInBezierPath:circle angle:270];
		[circle stroke];
		switch(state)
			{
			case 1:
				{
				NSBezierPath * dot = [NSBezierPath bezierPathWithOvalInRect:NSMakeRect(6,7, 4,4)];
				[[color shadowWithLevel:0.4] set];
				[dot fill];
				}
			break;
			case 2:
				{
				[[NSColor whiteColor] set];
				NSBezierPath * check = [NSBezierPath bezierPath];
				[check moveToPoint:NSMakePoint(5,9)];
				[check lineToPoint:NSMakePoint(7,6)];
				[check lineToPoint:NSMakePoint(11,12)];
				[check setLineWidth:1.5];
				[check stroke];
				}
			break;
			}
	[colorDot unlockFocus];
	
	return colorDot;
}

@end
