//
//  UIView+MKLayoutItem.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 21/08/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLayoutItem.h"

@interface UIView (LKLayoutItem)

/**
 *  The associated layout item
 *
 * Once the view is added in any of the layouts,
 * layout item provides access to its corresponding item in order to configure the visual
 * layout behaviour for that view.
 *
 */
@property (weak, nonatomic, readonly) LKLayoutItem *item;

@end
