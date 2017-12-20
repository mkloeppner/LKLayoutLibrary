//
//  LKLayout.m
//  LKLayout
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayout.h"
#import "UIView_LKLayoutItemInternalAPI.h"

@interface LKLayout ()

@property (weak, nonatomic, readwrite) LKLayoutItem *item;

@property (strong, nonatomic) NSMutableArray *mutableItems;
@property (assign, nonatomic) CGRect bounds;

@end

@implementation LKLayout

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        self.view = view;
        self.contentScaleFactor = [[UIScreen mainScreen] scale];
        self.mutableItems = [[NSMutableArray alloc] init];
        self.margin = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    }
    return self;
}

- (id)init
{
    self = [self initWithView:nil];
    if (self) {
    }
    return self;
}

#pragma mark - UIView and Layout
- (LKLayoutItem *)addSubview:(UIView *)subview
{
    return [self insertSubview:subview atIndex:self.items.count];
}

- (LKLayoutItem *)addSublayout:(LKLayout *)sublayout
{
    return [self insertSublayout:sublayout atIndex:self.items.count];
}

- (LKLayoutItem *)insertSubview:(UIView *)subview atIndex:(NSInteger)index
{
    LKLayoutItem *layoutItem = [[LKLayoutItem alloc] initWithLayout:self subview:subview];
    [self insertLayoutItem:layoutItem atIndex:index];
    return layoutItem;
}

- (LKLayoutItem *)insertSublayout:(LKLayout *)sublayout atIndex:(NSInteger)index
{
    LKLayoutItem *layoutItem = [[LKLayoutItem alloc] initWithLayout:self sublayout:sublayout];
    [self insertLayoutItem:layoutItem atIndex:index];
    return layoutItem;
}

#pragma mark - MKLayoutItem
- (void)clear
{
    NSArray *layoutItems = [self.items copy];
    for (LKLayoutItem *layoutItem in layoutItems) {
        [layoutItem removeFromLayout]; // To notify the delegate for every item that has been removed
    }
}

- (void)insertLayoutItem:(LKLayoutItem *)layoutItem atIndex:(NSInteger)index
{
    [layoutItem removeFromLayout];
    
    if (layoutItem.subview) {
        [self.view addSubview:layoutItem.subview];
        layoutItem.subview.item = layoutItem;
    }
    if (layoutItem.sublayout) {
        layoutItem.sublayout.item = layoutItem;
        layoutItem.sublayout.view = self.view;
        layoutItem.sublayout.delegate = self.delegate;
    }
    [self.mutableItems insertObject:layoutItem atIndex:index];
    if ([self.delegate respondsToSelector:@selector(layout:didAddLayoutItem:)]) {
        [self.delegate layout:self didAddLayoutItem:layoutItem];
    }
}

- (void)removeLayoutItemAtIndex:(NSInteger)index
{
    if (NSNotFound == index) {
        return;
    }
    
    LKLayoutItem *item = self.items[index];
    [self.mutableItems removeObjectAtIndex:index];

    item.subview.item = nil;

    if ([self.delegate respondsToSelector:@selector(layout:didRemoveLayoutItem:)]) {
        [self.delegate layout:self didRemoveLayoutItem:item];
    }
}

- (void)addLayoutItem:(LKLayoutItem *)layoutItem
{
    [self insertLayoutItem:layoutItem atIndex:self.items.count];
}

- (void)removeLayoutItem:(LKLayoutItem *)layoutItem
{
    [self removeLayoutItemAtIndex:[self.items indexOfObjectIdenticalTo:layoutItem]];
}

- (NSArray *)items
{
    return [NSArray arrayWithArray:self.mutableItems];
}

#pragma mark - Layouting
- (void)layout
{
    if ([self.delegate respondsToSelector:@selector(layoutDidStartToLayout:)]) {
        [self.delegate layoutDidStartToLayout:self];
    }
    [self runLayout:self.view.bounds];
    if ([self.delegate respondsToSelector:@selector(layoutDidFinishToLayout:)]) {
        [self.delegate layoutDidFinishToLayout:self];
    }
}

- (void)runLayout:(CGRect)bounds
{
    self.bounds = UIEdgeInsetsInsetRect(bounds, self.margin);
    
    [self layoutBounds:bounds];
    
    // self.bounds = CGRectMake(0.0f, 0.0f, 0.0f, 0.0f);
}

- (void)layoutBounds:(CGRect)bounds
{
    
}

#pragma mark - Setter
- (void)setView:(UIView *)view
{
    _view = view;
    for (LKLayoutItem *item in self.items) {
        if (item.subview) {
            [item.subview removeFromSuperview];
            [view addSubview:item.subview];
        } else if (item.sublayout) {
            item.sublayout.view = view;
        }
    }
}

- (void)setDelegate:(id<LKLayoutDelegate>)delegate
{
    _delegate = delegate;
    for (LKLayoutItem *item in self.items) {
        if (item.sublayout) {
            item.sublayout.delegate = delegate;
        }
    }
}

- (CGRect)moveRect:(CGRect)rect withinRect:(CGRect)outerRect gravity:(LKLayoutGravity)gravity
{
    LKGravity *gravityObj = [[LKGravity alloc] initWithCGRect:rect parent:outerRect];
    [gravityObj moveByGravity:gravity];
    
    return gravityObj.CGRect;
}

- (CGRect)roundedRect:(CGRect)rect
{
    return CGRectMake(roundf(rect.origin.x * self.contentScaleFactor) / self.contentScaleFactor,
                      roundf(rect.origin.y * self.contentScaleFactor) / self.contentScaleFactor,
                      roundf(rect.size.width * self.contentScaleFactor) / self.contentScaleFactor,
                      roundf(rect.size.height * self.contentScaleFactor) / self.contentScaleFactor);
}

- (LKLayoutOrientation)flipOrientation:(LKLayoutOrientation)orientation
{
    if (LKLayoutOrientationHorizontal == orientation) {
        return LKLayoutOrientationVertical;
    }
    if (LKLayoutOrientationVertical == orientation) {
        return LKLayoutOrientationHorizontal;
    }
    [NSException raise:@"UnknownParamValueException" format:@"The specified orientation is unknown"];
    return -1;
}

#pragma mark - Layout Item callbacks
- (void)layoutItemWantsRemoval:(LKLayoutItem *)layoutItem
{
    NSInteger itemIndex = [self.mutableItems indexOfObject:layoutItem];
    [self removeLayoutItemAtIndex:itemIndex];
}

#pragma mark - Size calculations
- (CGSize)size {
    [self layout];
    return [self sizeForLayout:self offset:UIOffsetZero];
}

- (CGSize)sizeForLayout:(LKLayout *)layout offset:(UIOffset)offset {
    LKLayoutItem *lastItem = [layout.items lastObject];
    return [layout sizeForLayout:layout lastItem:lastItem offset:offset];
}

- (CGSize)sizeForLayout:(LKLayout *)layout lastItem:(LKLayoutItem *)lastItem offset:(UIOffset)offset
{
    if ([lastItem.subview conformsToProtocol:@protocol(LKAdaptable)]) {
        return [(id<LKAdaptable>)lastItem.subview size];
    }
    
    return CGSizeMake(lastItem.subview.frame.origin.x +
                      lastItem.subview.frame.size.width +
                      self.margin.right,
                      lastItem.subview.frame.origin.y +
                      lastItem.subview.frame.size.height +
                      self.margin.bottom);
}

@end
