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

@interface FXWindow : NSWindow

@end

@interface FXTextField : NSTextField

@end


#pragma mark - Delegate for NSTableView

@interface FXDelegate : NSObject <NSTableViewDelegate>

@end

#pragma mark - Middle cell
@interface FXTableCellView : NSTableCellView

@end

@interface FXTableHeaderView : NSTableHeaderView

@end

IB_DESIGNABLE
@interface FXButton : NSButton

@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;

@end