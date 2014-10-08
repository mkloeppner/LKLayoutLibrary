//
//  LKLinearLayoutItem.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLinearLayoutItem.h"
#import "LKLayoutItem_SubclassAccessors.h"

const CGFloat kMKLinearLayoutWeightInvalid = -1.0f;

@implementation LKLinearLayoutItem

- (instancetype)initWithLayout:(LKLayout *)layout
{
    LKLinearLayoutItem *layoutItem = [super initWithLayout:layout];
    layoutItem.weight = kMKLinearLayoutWeightInvalid;
    return layoutItem;
}

@end
