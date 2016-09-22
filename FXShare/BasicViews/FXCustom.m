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

@implementation FXWindow


@end

@implementation FXTextField



@end

@implementation FXDelegate


@end

@implementation FXTableCellView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self middleVerticalSubview];
    }
    return self;
}

- (void)middleVerticalSubview {
    
    CGFloat originX = self.subviews.firstObject.frame.origin.x;
    CGFloat originY = self.subviews.firstObject.frame.origin.y;
    CGFloat width = self.subviews.firstObject.frame.size.width;
    CGFloat height = self.subviews.firstObject.frame.size.height;
    
    
    CGFloat y = originY - .5 + (self.frame.size.height - height) / 2.0;
    
    self.subviews.firstObject.frame = CGRectMake(originX, y, width, height);
}

@end


@implementation FXTableHeaderView


@end

@implementation FXButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        NSLog(@"123");
    }
    return self;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.cornerRadius = cornerRadius;
}

@end




