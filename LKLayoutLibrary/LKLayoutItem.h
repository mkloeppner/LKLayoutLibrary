//
//  LKLayoutItem.h
//  LKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKGravity.h"
#import "LKAdaptable.h"

@class LKLayout;

/**
 * Specifies that the layout item view should match the parent views or parent layouts size.
 */
FOUNDATION_EXPORT const CGFloat kLKLayoutItemSizeValueMatchParent;
FOUNDATION_EXPORT const CGFloat kLKLayoutItemSizeValueMatchContents;

/**
 * LKLayoutItem contains all the necessary information for layouts in order to perform its layout implementation.
 *
 * @discussion
 *
 * LKLayoutItem extends UIView via composition. It is the base class for all kind of layouts.
 *
 * Every layout has to support size, margin, gravity, subviews and sublayouts.
 *
 * In addition, layouts can have its own properties. Therefore LKLayoutItem can be sublassed with extending LKLayoutItem and importing MKLayoutItem_SubclassAccessors.h
 */
@interface LKLayoutItem : NSObject

- (instancetype _Nonnull)initWithLayout:(LKLayout * _Nonnull)layout subview:(UIView * _Nonnull)view;
- (instancetype _Nonnull)initWithLayout:(LKLayout * _Nonnull)layout sublayout:(LKLayout * _Nonnull)sublayout;

/**
 * The parent layout of the current layout item
 */
@property (weak, nonatomic, readonly) LKLayout * __nullable layout;

/**
 * An absolute size within a layout
 *
 * kLKLayoutItemSizeValueMatchParent can be used to set either
 *
 * - the width
 * - the height
 * - or both to parents size to perfectly fit the space
 */
@property (assign, nonatomic) CGSize size;

@property (nonatomic, readonly) CGSize contentSize;

/**
 * Ensures a margin around the layout items view. 
 */
@property (assign, nonatomic) UIEdgeInsets padding;

/**
 * Moves the items view or sublayout by the specified offset.
 *
 * Positive values increases the offset from the top left while negatives do the opposite
 */
@property (assign, nonatomic) UIOffset offset;

/**
 * Can store a subview or a sublayout.
 *
 * Use the property which instance is not nil
 */
@property (strong, nonatomic, readonly) UIView * _Nullable subview;
@property (strong, nonatomic, readonly) LKLayout * __nullable sublayout;

/**
 * Gravity aligns the layout items view to the following options:
 *
 * gravity = LKLayoutGravityTop | LKLayoutGravityLeft = The view is on the upper left corner
 * gravity = LKLayoutGravityBottom | LKLayoutGravityCenterHorizontal = The view is on the horizontal center of the bottom view
 * gravity = LKLayoutGravityCenterVertical | LKLayoutGravityCenterHorizontal = The view is on the center of the cell
 *
 * @see LKLayoutGravity
 */
@property (assign, nonatomic) LKLayoutGravity gravity;

/**
 * Allows to store meta data for debugging, layout introspection ...
 */
@property (strong, nonatomic) NSDictionary * __nullable userInfo;

/**
 * Removes the whole layout contents and cleans them up
 */
- (void)removeFromLayout;

@end
