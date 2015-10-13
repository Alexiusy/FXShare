//
//  FXCustom.h
//  FXShare
//
//  Created by Zeacone on 15/10/9.
//  Copyright © 2015年 Zeacone. All rights reserved.
//

#import <Cocoa/Cocoa.h>

///----------------------------------------
///  Custom titlebar of window
///----------------------------------------

@interface FXPanel : NSPanel

@end


///----------------------------------------
///  Custom titlebar of window
///----------------------------------------

@interface FXTitleBar : NSView

/**
 *  Build three buttons.
 */
@property (strong) NSButton *closeButton, *minimizeButton, *zoomButton;
@property (strong) NSImage *backgroundPattern;
@property (strong) NSBezierPath *outline;
@property (strong) NSTrackingArea *buttonArea;

- (void)updateOutline;

@end

///----------------------------------------
///  Custom window with custom titlebar.
///----------------------------------------

@interface FXWindow : NSWindow

@property (readonly) NSColor *backgroundPattern;
@property (strong) FXTitleBar *windowTitleBar;

@end
