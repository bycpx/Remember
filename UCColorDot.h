//
//  UCColorDot.h
//  Remember
//
//  Created by Christoph on 25.05.09.
//  Copyright 2009 Useless Coding. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface UCColorDot : NSObject
{
NSColor * color;
NSInteger state;
@private
	NSImage * colorDot;
	NSGradient * gradient;
	NSShadow * shadow;
}

+ (NSImage *)imageWithColor:(NSColor *)aColor state:(NSInteger)aState;
+ (NSImage *)imageWithColor:(NSColor *)aColor;
- (id)initWithColor:(NSColor *)aColor state:(NSInteger)aState;
- (id)initWithColor:(NSColor *)aColor;

@property(nonatomic,readonly) NSImage * image;
@property(nonatomic,copy) NSColor * color;
@property(nonatomic) NSInteger state;

@end
