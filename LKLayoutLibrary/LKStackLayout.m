//
//  LKStackLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKStackLayout.h"
#import "LKLayout_SubclassAccessors.h"

@interface LKStackLayout ()

@property (assign, nonatomic) CGRect bounds;

@end

@implementation LKStackLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(LKStackLayoutItem)

- (void)layoutBounds:(CGRect)bounds
{
    for (NSUInteger i = 0; i < self.items.count; i++) {
        LKStackLayoutItem *item = self.items[i];
        [item applyPositionWithinLayoutFrame:self.bounds];
    }
}


@end
