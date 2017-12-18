//
//  LKFlowLayout.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayout.h"
#import "LKFlowLayoutItem.h"

/**
 *  A flow layout tries fill either the width or the height with subviews. 
 * If the space of a row or column is full the flow layout continues in another row or column.
 *
 * The distinction if the layout tries to fill either rows or column is made by orientation.
 *
 */
@interface LKFlowLayout : LKLayout

DECLARE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(LKFlowLayoutItem);

/**
 * Specifies in which direction the layout should place its childs.
 *
 * LKFlowLayout dynamically creates new rows or columns depending on orientations.
 *
 * LKLayoutOrientationHorizontal insert new line breaks if the space is exceeded
 * LKLayoutOrientationVertical insert new columns if the space is exceeded
 */
@property (assign, nonatomic) LKLayoutOrientation orientation;

@property (assign, nonatomic) CGFloat horizontalSpacing;
@property (assign, nonatomic) CGFloat verticalSpacing;

@end
