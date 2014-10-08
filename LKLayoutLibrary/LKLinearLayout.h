//
//  LKLinearLayout.h
//  LKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayout.h"
#import "LKLinearLayoutItem.h"

/**
 *  A linear layout places all its children view side by side in a specified direction.
 */
@interface LKLinearLayout : LKLayout

DECLARE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(LKLinearLayoutItem)

/**
 * Inserts spacing between the outer border and the different layout items.
 *
 * Reduces the total available space which affects the calculation of relative sizes calculated by weight.
 */
@property (assign, nonatomic) CGFloat spacing;

/**
 * Specifies in which direction the linear layout should place its childs.
 */
@property (assign, nonatomic) LKLayoutOrientation orientation;


@end
