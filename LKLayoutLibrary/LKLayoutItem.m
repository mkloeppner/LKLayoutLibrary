//
//  LKLayoutItem.m
//  LKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayoutItem.h"
#import "LKLayout.h"

const CGFloat kLKLayoutItemSizeValueMatchParent = -1.0f;

@interface LKLayout (APIAccessor)

- (void)layoutItemWantsRemoval:(LKLayoutItem *)layoutItem;
- (void)runLayout:(CGRect)rect;
- (CGRect)moveRect:(CGRect)rect withinRect:(CGRect)outerRect gravity:(LKLayoutGravity)gravity;

@end

@interface LKLayoutItem ()

@property (weak, nonatomic) LKLayout *layout;
@property (strong, nonatomic, readwrite) UIView *subview;
@property (strong, nonatomic, readwrite) LKLayout *sublayout;


@end

@implementation LKLayoutItem

- (instancetype)initWithLayout:(LKLayout *)layout
{
    self = [super init];
    if (self) {
        self.layout = layout;
        _gravity = LKLayoutGravityNone;
        _size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, kLKLayoutItemSizeValueMatchParent);
        _padding = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
        _offset = UIOffsetMake(0.0f, 0.0f);
    }
    return self;
}

- (instancetype)initWithLayout:(LKLayout *)layout sublayout:(LKLayout *)sublayout
{
    LKLayoutItem *item = [self initWithLayout:layout];
    item.sublayout = sublayout;
    return item;
}

- (instancetype)initWithLayout:(LKLayout *)layout subview:(UIView *)view
{
    LKLayoutItem *item = [self initWithLayout:layout];
    item.subview = view;
    return item;
}

- (void)removeFromLayout
{
    [self removeAssociatedViews];
    [self.layout layoutItemWantsRemoval:self];
}

- (void)removeAssociatedViews
{
    [self.subview removeFromSuperview];
    
    for (LKLayoutItem *item in self.sublayout.items) {
        [item removeAssociatedViews];
    }
}

- (void)applyPositionWithinLayoutFrame:(CGRect)itemOuterRect
{
    CGRect marginRect = UIEdgeInsetsInsetRect(itemOuterRect, self.padding);
    
    // Apply items size value if beeing set
    CGRect itemRect = itemOuterRect; // Take the outer rect without margin applied to prevent applying margin twice
    if (self.size.width != kLKLayoutItemSizeValueMatchParent) {
        itemRect.size.width = self.size.width;
    }
    if (self.size.height != kLKLayoutItemSizeValueMatchParent) {
        itemRect.size.height = self.size.height;
    }
    
    itemRect = UIEdgeInsetsInsetRect(itemRect, self.padding);
    
    // Move it within the margin bounds if there is a gravity
    CGRect rect = [self.layout moveRect:itemRect withinRect:marginRect gravity:self.gravity];
    
    rect.origin.x += self.offset.horizontal;
    rect.origin.y += self.offset.vertical;
    
    if (self.subview) {
        rect = [self.layout roundedRect:rect];
        self.subview.frame = rect;
    } else if (self.sublayout) {
        [self.sublayout runLayout:rect];
    }
}

@end