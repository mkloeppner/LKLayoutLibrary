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

@property (strong, nonatomic) NSMutableArray *separators;
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
        self.separators = [[NSMutableArray alloc] init];
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
    [self resetSeparatorInformation];
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

- (void)resetSeparatorInformation
{
    self.separators = [[NSMutableArray alloc] init];
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

- (void)increaseAlreadyUsedLengthByParentContentSize {
    self.alreadyUsedLength += [self lengthForSize:self.contentRect.size];
}

- (void)increaseAlreadyUsedLengthByCurrentItemsLength {
    self.alreadyUsedLength += [self lengthForSize:self.currentItem.size];
}

- (void)reserveSpaceForSpacingBetweenItems
{
    self.totalUseableContentLength -= (self.items.count - 1) * self.spacing; // For every item without separators just remove the spacing
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

@end