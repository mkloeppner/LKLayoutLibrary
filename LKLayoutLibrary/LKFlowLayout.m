//
//  LKFlowLayout.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 20/04/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKFlowLayout.h"
#import "LKLayout_SubclassAccessors.h"

@interface LKFlowLayout ()

@property (assign, nonatomic) CGRect bounds;

@end

@implementation LKFlowLayout

SYNTHESIZE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(LKFlowLayoutItem);

- (instancetype)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    if (self) {
        _orientation = LKLayoutOrientationHorizontal;
        _horizontalSpacing = 0.0f;
        _verticalSpacing = 0.0f;
    }
    return self;
}

- (void)layoutBounds:(CGRect)bounds
{
    self.bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    NSArray *rowHeights = [self preCalculateRowHeights];
    
    // Globals for movement
    CGFloat currentPositionX = self.margin.left;
    CGFloat currentPositionY = self.margin.top;
    CGFloat spacingX = self.horizontalSpacing;
    CGFloat spacingY = self.verticalSpacing;
    
    NSUInteger rowIndex = 0;
    
    for (LKFlowLayoutItem *item in self.items) {
        
        // Get item sizes
        CGFloat currentLengthHorizontal = [self horizontalLengthForItem:item];
        CGFloat currentLengthVertical = [self verticalLengthForItem:item];
        
        // Get pointer to the right values
        CGFloat *currentOrientationPosition = self.orientation == LKLayoutOrientationHorizontal ? &currentPositionX : &currentPositionY;
        CGFloat *currentOppositePosition  = self.orientation == LKLayoutOrientationHorizontal ? &currentPositionY : &currentPositionX;
        CGFloat *currentOrientationSpacing  = self.orientation == LKLayoutOrientationHorizontal ? &spacingX : &spacingY;
        CGFloat *currentOppositeSpacing  = self.orientation == LKLayoutOrientationHorizontal ? &spacingY : &spacingX;
        CGFloat *currentLengthOfOrientation = self.orientation == LKLayoutOrientationHorizontal ? &currentLengthHorizontal : &currentLengthVertical;
        
        CGFloat totalAvailableLength = self.orientation == LKLayoutOrientationHorizontal ? self.bounds.size.width : self.bounds.size.height;
        
        CGFloat layoutMargin = self.orientation == LKLayoutOrientationHorizontal ? self.margin.left : self.margin.top;
        
        BOOL needsLineBreak = *currentOrientationPosition + *currentLengthOfOrientation > totalAvailableLength + layoutMargin;
        
        // If the current position exeeds the maximum available space jump to the next line
        if (needsLineBreak) {
            *currentOrientationPosition = self.orientation == LKLayoutOrientationHorizontal ? self.margin.left : self.margin.top; // Carriage
            
            NSNumber *rowHeightNumber = rowHeights[rowIndex];
            CGFloat rowHeight = rowHeightNumber.floatValue;
            
            *currentOppositePosition += rowHeight + *currentOppositeSpacing; // Return;
            rowIndex += 1;
        }
        
        // Get current rows height
        NSNumber *rowHeightNumber = rowHeights[rowIndex];
        CGFloat rowHeight = rowHeightNumber.floatValue;
        
        
        // The total available space
        CGRect outerRect = CGRectMake(currentPositionX,
                                      currentPositionY,
                                      self.orientation == LKLayoutOrientationHorizontal ? currentLengthHorizontal : rowHeight,
                                      self.orientation == LKLayoutOrientationVertical ? currentLengthVertical : rowHeight);
        
        [item applyPositionWithinLayoutFrame:outerRect];
        
        *currentOrientationPosition += *currentLengthOfOrientation + *currentOrientationSpacing;
        
    }
}

- (NSArray *)preCalculateRowHeights
{
    NSMutableArray *precalculatedRowHeights = [NSMutableArray array];
    
    CGFloat maximum = 0.0f;
    CGFloat alreadyUsedSpaceForRow = 0.0f;
    
    for (NSUInteger i = 0; i < self.items.count; i++) {
        
        LKFlowLayoutItem *item = self.items[i];
        
        CGFloat totalAvailableLength = self.orientation == LKLayoutOrientationHorizontal ? self.bounds.size.width : self.bounds.size.height;
        CGFloat currentLength = self.orientation == LKLayoutOrientationHorizontal ? [self horizontalLengthForItem:item] : [self verticalLengthForItem:item];
        CGFloat currentHeight = self.orientation == LKLayoutOrientationHorizontal ? [self verticalLengthForItem:item] : [self horizontalLengthForItem:item];
        CGFloat currentOrientationSpacing  = self.orientation == LKLayoutOrientationHorizontal ? self.horizontalSpacing : self.verticalSpacing;
        
        maximum = MAX(maximum, currentHeight);
        alreadyUsedSpaceForRow += currentLength + currentOrientationSpacing;
        
        BOOL newRowBegins = alreadyUsedSpaceForRow > totalAvailableLength; // If the current item already will break the line
        BOOL nextItemStartsNewRow = NO;// If the next item will be in a new row
        if (i < self.items.count - 1) {
            LKFlowLayoutItem *nextItem = self.items[i + 1];
            CGFloat nextItemLength = self.orientation == LKLayoutOrientationHorizontal ? [self horizontalLengthForItem:nextItem] : [self verticalLengthForItem:nextItem];
            nextItemStartsNewRow = alreadyUsedSpaceForRow + nextItemLength > totalAvailableLength;
        }
        BOOL isLastItem = i == self.items.count - 1; // If its the last item, we have to cover the maximum height
        if (newRowBegins || isLastItem || nextItemStartsNewRow) {
            [precalculatedRowHeights addObject:@(maximum)];
            maximum = 0.0f;
            alreadyUsedSpaceForRow = 0.0f;
        }
        
    }
    
    return [NSArray arrayWithArray:precalculatedRowHeights];
}

- (CGFloat)horizontalLengthForItem:(LKLayoutItem *)item
{
    CGFloat width = item.size.width;
    if (width == kLKLayoutItemSizeValueMatchParent) {
        return self.bounds.size.width;
    }
    if (width == kLKLayoutItemSizeValueMatchContents) {
        return item.contentSize.width;
    }
    return width;
}

- (CGFloat)verticalLengthForItem:(LKLayoutItem *)item
{
    CGFloat height = item.size.height;
    if (height == kLKLayoutItemSizeValueMatchParent) {
        return self.bounds.size.height;
    }
    if (height == kLKLayoutItemSizeValueMatchContents) {
        return item.contentSize.height;
    }
    return height;
}

- (CGSize)sizeForLayout:(LKLayout *)layout lastItem:(LKLayoutItem *)lastItem offset:(UIOffset)offset
{
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    
    CGFloat totalHeight = 0.0f;
    NSArray *rowHeights = [self preCalculateRowHeights];
    
    if (rowHeights.count == 1) {
        UIView *lastView = layout.items.lastObject.subview;
        if ([lastItem conformsToProtocol:@protocol(LKAdaptable)]) {
            return [(id<LKAdaptable>)lastView size];
        }
        
        CGRect lastFrame = layout.items.lastObject.subview.frame;
        return CGSizeMake(lastFrame.origin.x + lastFrame.size.width + self.margin.right,
                          lastFrame.origin.y + lastFrame.size.height + self.margin.bottom);
    }
    
    for (NSNumber *number in rowHeights) {
        totalHeight += number.floatValue;
    }
    totalHeight += (self.orientation == LKLayoutOrientationHorizontal ? self.horizontalSpacing : self.verticalSpacing) * (rowHeights.count - 1);
    
    if (self.orientation == LKLayoutOrientationHorizontal) {
        height = totalHeight;
    } else {
        width = totalHeight;
    }
    
    return CGSizeMake(width + self.margin.left + self.margin.right, height + self.margin.top + self.margin.bottom);
}

@end
