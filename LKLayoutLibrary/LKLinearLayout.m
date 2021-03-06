//
//  LKLinearLayout.m
//  LKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLinearLayout.h"
#import "LKLayout_SubclassAccessors.h"

@interface LKLinearLayout ()

@property (assign, nonatomic) CGRect contentRect;
@property (assign, nonatomic) CGFloat currentPos;
@property (assign, nonatomic) CGFloat overallWeight;
@property (assign, nonatomic) CGFloat alreadyUsedLength;
@property (assign, nonatomic) CGFloat totalUseableContentLength;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) LKLinearLayoutItem *currentItem;
@property (assign, nonatomic) CGFloat currentItemLength;

@end

@implementation LKLinearLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(LKLinearLayoutItem)

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        self.spacing = 0.0f;
        self.orientation = LKLayoutOrientationHorizontal;
    }
    return self;
}

#pragma mark - Highest level
- (void)layoutBounds:(CGRect)bounds
{
    self.contentRect = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    [self resetCalculationState];
    [self gatherOverallWeightAndAlreadyUsedFixedItemLengths]; // In order to map weight to real points
    [self calculateTotalUseableContentLength];
    [self iterateThroughAndPlaceItems];
}

#pragma mark - First level abstraction
- (void)resetCalculationState
{
    [self resetCurrentPointer];
    [self resetGlobalLayoutValues];
}

/**
 *  In order to map weight to real points.
 */
- (void)gatherOverallWeightAndAlreadyUsedFixedItemLengths
{
    [self forEachItem:^{
        if ([self isCurrentItemAnWeightItem]) {
            [self increaseOverallWeightWithItemOnes];
        } else if ([self isCurrentItemAMatchParentItem]) {
            [self increaseAlreadyUsedLengthByParentContentSize];
        } else {
            [self increaseAlreadyUsedLengthByCurrentItemsLength];
        }
    }];
}

- (void)calculateTotalUseableContentLength
{
    self.totalUseableContentLength = [self lengthForSize:self.contentRect.size];
    [self reserveSpaceForSpacingBetweenItems];
}

- (void)iterateThroughAndPlaceItems
{
    [self forEachItem:^{
        [self calculateAndSetCurrentItemsPosition];
    }];
}

#pragma mark - Second level abstraction
- (void)resetCurrentPointer {
    self.currentPos = 0.0f;
}

- (void)resetGlobalLayoutValues
{
    self.overallWeight = 0.0f;
    self.alreadyUsedLength = 0.0f;
}

- (void)forEachItem:(void (^)(void))block
{
    __strong void (^execBlock)(void) = block;
    [self.items enumerateObjectsUsingBlock:^(LKLinearLayoutItem *item, NSUInteger idx, BOOL *stop) {
        self.currentIndex = idx;
        self.currentItem = item;
        execBlock();
    }];
}

- (BOOL)isCurrentItemAnWeightItem
{
    return self.currentItem.weight != kLKLinearLayoutWeightInvalid;
}

- (void)increaseOverallWeightWithItemOnes
{
    self.overallWeight += self.currentItem.weight;
}

- (BOOL)isCurrentItemAMatchParentItem
{
    return [self lengthForSize:self.currentItem.size] == kLKLayoutItemSizeValueMatchParent;
}

- (BOOL)isCurrentItemAMatchContentsItem
{
    return [self lengthForSize:self.currentItem.size] == kLKLayoutItemSizeValueMatchContents;
}

- (void)increaseAlreadyUsedLengthByParentContentSize {
    self.alreadyUsedLength += [self lengthForSize:self.contentRect.size];
}

- (void)increaseAlreadyUsedLengthByCurrentItemsLength {
    self.alreadyUsedLength += [self lengthForSize:self.currentItem.size];
}

- (void)reserveSpaceForSpacingBetweenItems
{
    NSUInteger spacerCount = self.items.count - 1;
    self.totalUseableContentLength -= spacerCount * self.spacing;
}

- (void)calculateAndSetCurrentItemsPosition
{
    if ([self isNotFirstItem]) {
        [self movePointerBySpacing];
    }
    
    [self placeCurrentItem];
    [self movePointerWithItem];
    
}

#pragma mark - Third level abstraction
- (BOOL)isNotFirstItem
{
    return self.currentIndex != 0;
}

- (void)movePointerBySpacing
{
    self.currentPos += self.spacing;
}

- (void)placeCurrentItem
{
    [self calculateCurrentItemLength];
    [self placeCurrentItemOuterBox];
}

- (void)movePointerWithItem
{
    self.currentPos += self.currentItemLength;
}

#pragma mark - Fourth level abstraction
- (void)calculateCurrentItemLength
{
    self.currentItemLength = 0.0f;
    if ([self isCurrentItemAnWeightItem]) {
        [self setCurrentItemLengthByWeight];
    } else if ([self isCurrentItemAMatchParentItem]) {
        [self setCurrentItemLengthByParentContentLength];
    } else if ([self isCurrentItemAMatchContentsItem]) {
        [self setCurrentItemLengthByContentSize];
    } else {
        [self setCurrentItemLengthByItemsFixedSize];
    }
}

- (void)placeCurrentItemOuterBox
{
    CGRect itemOuterRect;
    if (self.orientation == LKLayoutOrientationHorizontal) {
        itemOuterRect = [self currentItemOuterRectForHorizontalOrientation];
    } else {
        itemOuterRect = [self currentItemOuterRectForVerticalOrientation];
    }
    
    [self.currentItem applyPositionWithinLayoutFrame:itemOuterRect];
}

#pragma mark - Fith level abstraction
- (void)setCurrentItemLengthByWeight
{
    self.currentItemLength = self.currentItem.weight / self.overallWeight * (self.totalUseableContentLength - self.alreadyUsedLength);
}

- (void)setCurrentItemLengthByParentContentLength
{
    self.currentItemLength = self.totalUseableContentLength;
}

- (void)setCurrentItemLengthByItemsFixedSize
{
    self.currentItemLength = [self lengthForSize:self.currentItem.size];
}

- (void)setCurrentItemLengthByContentSize
{
    self.currentItemLength = [self lengthForSize:self.currentItem.contentSize];
}

- (CGRect)currentItemOuterRectForHorizontalOrientation
{
    CGFloat positionX = self.contentRect.origin.x + self.currentPos;
    CGFloat positionY = self.contentRect.origin.y;
    CGFloat width = self.currentItemLength;
    CGFloat height = self.contentRect.size.height;
    
    return CGRectMake(positionX, positionY, width, height);
}

- (CGRect)currentItemOuterRectForVerticalOrientation
{
    CGFloat positionX = self.contentRect.origin.x;
    CGFloat positionY = self.contentRect.origin.y + self.currentPos;
    CGFloat width = self.contentRect.size.width;
    CGFloat height = self.currentItemLength;
    
    return CGRectMake(positionX, positionY, width, height);
}

#pragma mark - Sixth level of abstraction


#pragma mark - Helper
- (CGFloat)lengthForSize:(CGSize)size
{
    switch (self.orientation) {
        case LKLayoutOrientationHorizontal:
            return size.width;
            break;
        case LKLayoutOrientationVertical:
            return size.height;
        default:
            break;
    }
    return 0.0f;
}

- (CGSize)sizeForLayout:(LKLayout *)layout lastItem:(LKLayoutItem *)lastItem offset:(UIOffset)offset
{
    CGFloat x = 0.0f;
    CGFloat y = 0.0f;
    
    for (LKLinearLayoutItem *item in layout.items) {
        CGSize size = item.contentSize;
        if (self.orientation == LKLayoutOrientationHorizontal) {
            x += size.width;
            y = MAX(y, size.height );
        } else {
            x = MAX(x, size.width );
            y += size.height;
        }
    }
    
    x += (self.orientation == LKLayoutOrientationHorizontal ? self.spacing : 0.0f) * (layout.items.count - 1);
    y += (self.orientation == LKLayoutOrientationVertical ? self.spacing : 0.0f) * (layout.items.count - 1);
    
    return CGSizeMake(x + self.margin.left + self.margin.right,
                      y + self.margin.top + self.margin.bottom);
}

@end
