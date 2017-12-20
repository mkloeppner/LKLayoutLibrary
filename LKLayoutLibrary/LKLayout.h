//
//  LKLayout.h
//  LKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKLayoutItem.h"
#import "LKLayoutDelegate.h"
#import "LKLayoutOrientation.h"

#define DECLARE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(classname) \
- (classname * _Nonnull)addSubview:(UIView * _Nonnull)subview; \
- (classname * _Nonnull)addSublayout:(LKLayout * _Nonnull)sublayout; \
- (classname * _Nonnull)insertSubview:(UIView * _Nonnull)subview atIndex:(NSInteger)index; \
- (classname * _Nonnull)insertSublayout:(LKLayout * _Nonnull)sublayout atIndex:(NSInteger)index; \

#define SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(classname) \
- (classname * _Nonnull)addSubview:(UIView * _Nonnull)subview \
{ \
    return [self insertSubview:subview atIndex:self.items.count]; \
} \
\
- (classname * _Nonnull)addSublayout:(LKLayout * _Nonnull)sublayout \
{ \
    return [self insertSublayout:sublayout atIndex:self.items.count]; \
} \
\
- (classname * _Nonnull)insertSubview:(UIView * _Nonnull)subview atIndex:(NSInteger)index \
{ \
    classname *layoutItem = [[classname alloc] initWithLayout:self subview:subview]; \
    [self insertLayoutItem:layoutItem atIndex:index]; \
    return layoutItem; \
} \
\
- (classname * _Nonnull)insertSublayout:(LKLayout * _Nonnull)sublayout atIndex:(NSInteger)index \
{ \
    classname *layoutItem = [[classname alloc] initWithLayout:self sublayout:sublayout]; \
    [self insertLayoutItem:layoutItem atIndex:index]; \
    return layoutItem; \
}

/**
 * LKLayout is the root class of MKLayoutLibrary
 *
 *
 * @discussion
 *
 * LKLayout maintains the view and layout tree and provides an easy interface for subclasses such as LKLinearLayout
 *
 * LKLayout subclasses can easy implement their layout behavior without the needs to maintain the view and layout hirarchy.
 *
 * Therefore the items array gives easy access to the layout children.
 *
 * Every layout needs to support all LKLayoutItem properties.
 *
 */
@interface LKLayout : NSObject

/**
 * Allows to store meta data for debugging, layout introspection ...
 */
@property (strong, nonatomic) NSDictionary * _Nullable userInfo;

/**
 * The layouts content scale factor
 *
 * The views frames will be set in points. With specifying the contentScaleFactor this frames will be round to perfectly match the grid.
 *
 * Default value is 1.0f;
 */
@property (assign, nonatomic) CGFloat contentScaleFactor;

/**
 * The layout delegate notifies layout steps and delegate some layout calculations.
 */
@property (weak, nonatomic) __nullable id<LKLayoutDelegate> delegate;

/**
 * The parent layout item if layout is a sublayout
 */
@property (weak, nonatomic, readonly) LKLayoutItem * _Nullable item;

/**
 * Adds spacing all around the layout contents
 */
@property (assign, nonatomic) UIEdgeInsets margin;

/**
 * The layouts view.
 *
 * All layout items views and sublayout views will be added into the specified layout view.
 *
 * For sublayouts the view property will be set automatically to parent layouts view.
 */
@property (weak, nonatomic) UIView * _Nullable view;

/**
 * The layout items representing the layouts structure
 *
 * Contains instances of LKLayoutItem or its subclasses. LKLayout subclasses ensure typesafety by overwriting - (LKLayoutItem *)addView:(UIView *)view and - (LKLayoutItem *)addSublayout:(LKLayout *)sublayout
 */
@property (strong, nonatomic, readonly) NSArray<__kindof LKLayoutItem *> * __nonnull items;

/**
 * @param view The root layouts view or the view that needs to be layouted
 */
- (instancetype _Nonnull )initWithView:(UIView * _Nonnull )view;

#pragma mark - UIView and Layout API
/**
 * Adds a subview to the layout.
 *
 * @param subview a view that will be position by the layout
 * @return the associated LKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (LKLayoutItem * _Nonnull )addSubview:(UIView * _Nonnull )subview;

/**
 * Adds a sublayout to the layout.
 *
 * @param sublayout a sublayout that will be position by the layout
 * @return the associated LKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (LKLayoutItem * _Nonnull )addSublayout:(LKLayout * _Nonnull )sublayout;

/**
 * Adds a subview to the layout with a specific index.
 *
 * @param subview a view that will be position by the layout
 * @param index the position in the layout at which the subview will be inserted
 * @return the associated LKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (LKLayoutItem * _Nonnull )insertSubview:(UIView * _Nonnull )subview atIndex:(NSInteger)index;

/**
 * Adds a sublayout to the layout with a specific index.
 *
 * @param sublayout a sublayout that will be position by the layout
 * @param index the position in the layout at which the sublayout will be inserted
 * @return the associated LKLayoutItem It allows layout behavior costumization with view layout properties
 */
- (LKLayoutItem * _Nonnull )insertSublayout:(LKLayout * _Nonnull )sublayout atIndex:(NSInteger)index;

#pragma mark - LKLayoutItem API
/**
 * Removed all subviews and sublayouts
 *
 *      Hint: To remove single items, checkout LKLayoutItem:removeFromLayout;
 */
- (void)clear;

/**
 * Add a layout item to allow subclasses using their own item classes with custom properties
 */
- (void)insertLayoutItem:(LKLayoutItem * _Nonnull )layoutItem atIndex:(NSInteger)index;

/**
 * Removes a layout item with a specified index
 *
 * @param index the index of the item that will be removed
 */
- (void)removeLayoutItemAtIndex:(NSInteger)index;

/**
 *  Inserts a layout item at the end of the layout
 *
 *  @param item the item, that will be added at the end of the layout
 */
- (void)addLayoutItem:(LKLayoutItem * _Nonnull )layoutItem;

/**
 *  Removes a layout item from a layout.
 *
 * Additionally it removes its assoicated view, if its a view layout item or its associated sublayout views if its a sublayout item.
 *
 *  @param item The layout item to be removed from the layout
 */
- (void)removeLayoutItem:(LKLayoutItem * _Nonnull )layoutItem;

#pragma mark - Layouting API
/**
 * Calls layoutBounds with the associated view bounds
 */
- (void)layout;

/**
 * layoutBounds:(CGRect)bounds needs to be implemented by subclasses in order to achieve the layout behavior.
 *
 * It will automatically be called.
 *
 * @param bounds - The rect within the layout calculates the child position
 *
 */
- (void)layoutBounds:(CGRect)bounds;

/**
 * Flips the orientation to the opposit
 */
- (LKLayoutOrientation)flipOrientation:(LKLayoutOrientation)orientation;

#pragma mark - Helper
/**
 *  Moves a frame within another frame edges by gravity
 *
 *  @param rect      The inner frame thats
 *  @param outerRect The outer frame within rect is beeing moved
 *  @param gravity   The gravity to which edge the rect should be moved.
 *
 *  @see LKLayoutGravity
 *
 *  @return The aligned and modified rect
 */
- (CGRect)moveRect:(CGRect)rect withinRect:(CGRect)outerRect gravity:(LKLayoutGravity)gravity;

/**
 *  Rounds the rects values to numbers within a grid matches the content scale factor
 *
 *  @param rect Any rect with uneven numbers
 *
 *  @return The given rect with grid matching values. Grid of 1 mean even numbers, Grid of 2 (Retina) means half even numbers and so on.
 */
- (CGRect)roundedRect:(CGRect)rect;

#pragma mark - Size
- (CGSize)size;
- (CGSize)sizeForLayout:(LKLayout * _Nonnull)layout offset:(UIOffset)offset;
- (CGSize)sizeForLayout:(LKLayout *)layout lastItem:(LKLayoutItem *)lastItem offset:(UIOffset)offset;

@end
