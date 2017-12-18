//
//  UIView+MKLayoutItem.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 21/08/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "UIView+LKLayoutItem.h"
#import <objc/runtime.h>

static char const * const kMKLayoutItemUIViewAssociatedLayoutItemKey = "io.github.mkloeppner.kLKLayoutItemUIViewAssociatedLayoutItemKey";

@implementation UIView (LKLayoutItem)

- (void)setItem:(LKLayoutItem *)item
{
    objc_setAssociatedObject(self, kMKLayoutItemUIViewAssociatedLayoutItemKey, item, OBJC_ASSOCIATION_ASSIGN);
}

- (LKLayoutItem *)item
{
    return objc_getAssociatedObject(self, kMKLayoutItemUIViewAssociatedLayoutItemKey);
}

@end
