//
//  FXCustom.m
//  FXShare
//
//  Created by Zeacone on 15/10/9.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import "FXCustom.h"

@implementation FXPanel

/**
 *  Override this method to support NSTextField editable on the no titlebar window.
 */
- (BOOL)canBecomeKeyWindow {
    return YES;
}

@end

@implementation FXTitleBar

- (BOOL)_mouseInGroup:(id)sender {
    NSPoint point = [self convertPoint:self.window.mouseLocationOutsideOfEventStream fromView:nil];
    return [self mouse:point inRect:self.buttonArea.rect];
}

- (BOOL)mouseDownCanMoveWindow {
    return YES;
}

- (id)initWithFrame:(NSRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.closeButton = [NSWindow standardWindowButton: NSWindowCloseButton forStyleMask:NSTexturedBackgroundWindowMask];
        self.minimizeButton = [NSWindow standardWindowButton: NSWindowMiniaturizeButton forStyleMask:NSTexturedBackgroundWindowMask];
        self.zoomButton = [NSWindow standardWindowButton: NSWindowZoomButton forStyleMask:NSTexturedBackgroundWindowMask];
        NSRect __bounds = [self bounds];
        NSRect __frame = [self.closeButton frame];
        __frame.origin.x = 8;
        __frame.origin.y = 21-__bounds.size.height+3;
        
        [self.closeButton setFrame: __frame];
        
        __frame = [self.minimizeButton frame];
        __frame.origin.x = 8+21;
        __frame.origin.y = 21-frame.size.height + 3;
        [self.minimizeButton setFrame: __frame];
        
        __frame = [self.zoomButton frame];
        __frame.origin.x = 8+21+21;
        __frame.origin.y = 21-frame.size.height + 3;
        [self.zoomButton setFrame: __frame];
        
        [self addSubview: self.closeButton];
        [self addSubview: self.minimizeButton];
        [self addSubview: self.zoomButton];
        
        NSRect bound = [self.closeButton frame];
        bound.size.width = [self.zoomButton frame].origin.x
        + [self.zoomButton frame].size.width;
        
        NSTrackingArea *trackingButtons = [[NSTrackingArea alloc] initWithRect: bound
                                                                       options: NSTrackingMouseEnteredAndExited | NSTrackingActiveInKeyWindow
                                                                         owner: self
                                                                      userInfo: nil];
        
        [self addTrackingArea: trackingButtons];
        
        self.buttonArea = trackingButtons;
        
        [self updateOutline];
    }
    
    return self;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    NSTrackingArea *area = nil;
    
    @try {
        area = [theEvent trackingArea];
        
        if (area == self.buttonArea)
        {
            [self.closeButton setNeedsDisplay: YES];
            [self.minimizeButton setNeedsDisplay: YES];
            [self.zoomButton setNeedsDisplay: YES];
        }
    }
    @catch (NSException * e) {
        // not a tracking area event
    }
}

- (void)dealloc {
    // Clean-up code here.
    self.backgroundPattern = nil;
}

// This method should be called when the window resizes
- (void) updateOutline
{
    NSRect __frame = [self bounds];
    
    const int radius = 6;
    NSBezierPath *background = [NSBezierPath bezierPath];
    [background moveToPoint: NSMakePoint(0, 0)];
    [background lineToPoint: NSMakePoint(__frame.size.width, 0)];
    
    [background lineToPoint: NSMakePoint(__frame.size.width, __frame.size.height-radius)];
//    [background cornerToPoint: NSMakePoint(__frame.size.width - radius, __frame.size.height) radius: radius];
    
    [background lineToPoint: NSMakePoint(radius, __frame.size.height)];
//    [background cornerToPoint: NSMakePoint(0, __frame.size.height-radius) radius: radius];
    
    [background lineToPoint: NSMakePoint(0, 0)];
    [background closePath];
    
    self.outline = background;
}

- (void)drawRect:(NSRect)dirtyRect {
    
    
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:[NSColor colorWithDeviceRed: 0.55 green: 0.55 blue:0.55 alpha:1]
                                                         endingColor: [NSColor colorWithDeviceRed: 0.2 green:0.2 blue:0.2 alpha:1]];
    
    [gradient drawInBezierPath: self.outline  angle: 270];
    
    [[NSColor colorWithDeviceRed:0.5 green:0.5 blue:0.5 alpha:1.0] setStroke];
    
    [self.outline stroke];
    
    
    // The following code is borrowed from somewhere, but I forget where.
    // Probably will change this to something better.
    
    NSWindow *win = [self window];
    NSString *title = (win? [win title] : @"");
    
    NSFont *titleFont = [NSFont titleBarFontOfSize: 0];
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    [paraStyle setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [paraStyle setAlignment:NSCenterTextAlignment];
    [paraStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    NSMutableDictionary *titleAttrs = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       titleFont, NSFontAttributeName,
                                       [NSColor whiteColor], NSForegroundColorAttributeName,
                                       [paraStyle copy], NSParagraphStyleAttributeName,
                                       nil];
    
    NSSize titleSize = [title sizeWithAttributes:titleAttrs];
    // We vertically centre the title in the titlbar area, and we also horizontally 
    // inset the title by 19px, to allow for the 3px space from window's edge to close-widget, 
    // plus 13px for the close widget itself, plus another 3px space on the other side of 
    // the widget.
    NSRect titleRect = NSInsetRect([self bounds], 200, ([self bounds].size.height - titleSize.height) / 2.0);
    [title drawInRect:titleRect withAttributes:titleAttrs];
    
    
}

@end

@implementation FXWindow

- (id) initWithContentRect:(NSRect)contentRect
{
    self = [self initWithContentRect: contentRect styleMask: 0 backing: 0 defer: NO];
    
    return self;
}

- (id) initWithContentRect:(NSRect)contentRect styleMask:(NSUInteger)aStyle backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag
{
    self = [super initWithContentRect: contentRect styleMask: NSBorderlessWindowMask backing: NSBackingStoreBuffered defer: NO];
    
    if (self)
    {
        [self setBackgroundColor: [NSColor clearColor]];
        [self setAlphaValue:1.0];
        [self setHasShadow: YES];
        [self setOpaque: NO];
        [self setMovableByWindowBackground:YES];
        
        [self setBackgroundColor: self.background];
        
        NSRect frame = [self frame];
        self.windowTitleBar = [[FXTitleBar alloc] initWithFrame: NSMakeRect(0, frame.size.height - 21, frame.size.width, 21)];
        
        [[self contentView] addSubview: self.windowTitleBar
                            positioned: NSWindowAbove
                            relativeTo: nil];
        
        CALayer *mask = [CALayer layer];
        mask.backgroundColor = [NSColor blackColor].CGColor;
        mask.cornerRadius = 6;
        [mask removeFromSuperlayer];
        
        [[self contentView] makeBackingLayer];
        [[self contentView] layer].mask = mask;
        [[self contentView] layer].masksToBounds = YES;
        
        [self.windowTitleBar setHidden: YES];
        
        NSTrackingArea *titlebar = [[NSTrackingArea alloc] initWithRect: [self.windowTitleBar frame]
                                                                options: NSTrackingMouseEnteredAndExited | NSTrackingMouseMoved | NSTrackingActiveInActiveApp
                                                                  owner: self
                                                               userInfo: nil];
        
        [[self contentView] addTrackingArea: titlebar];
        
        [self setAcceptsMouseMovedEvents:YES];
        
    }
    
    return self;
}

- (BOOL)acceptsMouseMovedEvents
{
    return YES;
}

- (void)mouseEntered:(NSEvent *)theEvent
{
    [self.windowTitleBar setAlphaValue: 0.0];
    [self.windowTitleBar setHidden: NO];
    [[self.windowTitleBar animator] setAlphaValue: 1.0];
    
}

- (void)mouseExited:(NSEvent *)theEvent
{
    [[self.windowTitleBar animator] setAlphaValue: 0.0];
    
    [[self.windowTitleBar animator] setHidden: YES];
    [self.windowTitleBar setAlphaValue: 1.0];
    
}

- (NSColor*) background
{
    static bool initialized = NO;
    
    if (initialized == YES)
        return _backgroundPattern;
    
    NSImage *_background = [[NSImage alloc] initWithSize: [self frame].size];
    
    [_background lockFocus];
    
    NSBezierPath *backgroundPath = [NSBezierPath bezierPathWithRoundedRect: [self frame] xRadius: 6 yRadius: 6];
    
    [[NSColor blackColor] setFill];
    [[NSColor blackColor] setStroke];
    
    [backgroundPath stroke];
    [backgroundPath fill];
    
    [_background unlockFocus];
    
    _backgroundPattern = [NSColor colorWithPatternImage:_background];
    
    initialized = YES;
    
    return _backgroundPattern;
}

- (BOOL) canBecomeKeyWindow
{
    return YES;
}

- (BOOL) canBecomeMainWindow
{
    return YES;
}

- (void)dealloc {
    
}

@end
