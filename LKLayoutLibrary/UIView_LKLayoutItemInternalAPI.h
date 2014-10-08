//
//  UIView_MKLayoutItemInternalAPI.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 21/08/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+LKLayoutItem.h"

@interface UIView (LKLayoutItemInternalAPI)

@property (weak, nonatomic, readwrite) LKLayoutItem *item;

@end