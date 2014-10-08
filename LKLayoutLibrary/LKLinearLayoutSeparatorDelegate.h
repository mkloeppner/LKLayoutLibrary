//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKLayoutOrientation.h"
#import "LKLayoutSeparatorDelegate.h"

@class LKLinearLayout;
@class LKLinearLayoutItem;

@protocol LKLinearLayoutSeparatorDelegate <LKLayoutSeparatorDelegate>

- (CGFloat)separatorThicknessForLinearLayout:(LKLinearLayout *)layout;

@optional

- (UIEdgeInsets)separatorIntersectionOffsetsForLinearLayout:(LKLinearLayout *)layout;

- (void)linearLayout:(LKLinearLayout *)linearLayout separatorRect:(CGRect)rect type:(LKLayoutOrientation)type;

@end