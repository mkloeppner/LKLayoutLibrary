//
//  MKLayoutTests.m
//  MKLayoutTests
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define MOCKITO_SHORTHAND
#import "OCMockito.h"

#import "UIView+LKLayoutItem.h"

@interface LKLayout (APIAccessors)

- (void)layoutItemWantsRemoval:(LKLayoutItem *)item;

@property (weak, nonatomic, readwrite) LKLayoutItem *item;

@end

SpecBegin(LKLayoutSpecification)

describe(@"LKLayout", ^{
    
    __block LKLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    __block UIView *subview4;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[LKLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview4 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
    
    // View management
    it(@"should associate the specified container", ^{
        expect(layout.view).to.equal(container);
    });
    
    it(@"should add a view to the associated view of the layout when added to it", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        expect(container.subviews.count).to.equal(1);
        expect(container.subviews[0]).to.equal(childView);
    });
    
    it(@"should add multiple views to the associated view of the layout when added to it", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        UIView *childView2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView2];
        
        expect(container.subviews.count).to.equal(2);
        expect(container.subviews[0]).to.equal(childView);
        expect(container.subviews[1]).to.equal(childView2);
    });
    
    it(@"should return an layout reference object to identify the childViews associated layout parameters", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        expect(layoutItem).toNot.beNil;
        expect(layoutItem.subview).to.equal(childView);
        expect(layoutItem.layout).to.equal(layout);
    });
    
    it(@"should remove view from layout", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(layout.view.subviews.count).to.equal(0);
        expect(layoutItem.layout).to.beNil;
        
    });
    
    it(@"should add a view of a sublayout with adding this sublayout", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
        LKLayout *sublayout = [[LKLayout alloc] initWithView:container];
        LKLayoutItem *layoutItem = [sublayout addSubview:childView];
        [layout addSublayout:sublayout];
        
        expect(layoutItem).toNot.beNil;
        expect(layoutItem.subview).to.equal(childView);
        expect(layoutItem.layout).to.equal(sublayout);
        
    });
    
    it(@"should remove a view of a sublayout with removing this sublayout", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
        LKLayout *sublayout = [[LKLayout alloc] initWithView:container];
        [sublayout addSubview:childView];
        LKLayoutItem *sublayoutItem = [layout addSublayout:sublayout];
        
        [sublayoutItem removeFromLayout];
        
        expect(layout.view.subviews.count).to.equal(0);
        expect(sublayoutItem.layout).to.beNil;
        
    });
    
    // Item management
    it(@"should cache the layout item for a added view to allow to access information at any time", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(layoutItem);
    });
    
    it(@"should remove a layout item from cache with removing the view", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(layout.items.count).to.equal(0);
    });
    
    it(@"should provide an empty method to override", ^{
        [layout layoutBounds:layout.view.bounds];
    });
    
    it(@"should return a specified userInfo for meta data", ^{
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        NSDictionary *userInfo = @{@"name": @"item"};
        layoutItem.userInfo = userInfo;
        
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(layoutItem);
        expect(layoutItem.userInfo).to.equal(userInfo);
    });
    
    // Helper
    it(@"should provide a method to insert a subview at a specific index", ^{
        
        LKLayoutItem *item = [layout insertSubview:subview1 atIndex:0];
        
        expect(layout.items.count).to.equal(1);
        
        expect(item).to.equal(layout.items[0]);
        
    });
    
    it(@"should provide a method to insert a subview bofore an other item", ^{
        
        LKLayoutItem *item = [layout addSubview:subview1];
        LKLayoutItem *item2 = [layout insertSubview:subview2 atIndex:0];
        
        expect(layout.items.count).to.equal(2);
        
        expect(item).to.equal(layout.items[1]);
        expect(item2).to.equal(layout.items[0]);
        
    });
    
    it(@"should provide a method to insert a sublayout behind an other item with the following index", ^{
        
        LKLayoutItem *item = [layout addSubview:subview1];
        LKLayoutItem *item2 = [layout insertSubview:subview2 atIndex:layout.items.count];
        
        expect(layout.items.count).to.equal(2);
        
        expect(item).to.equal(layout.items[0]);
        expect(item2).to.equal(layout.items[1]);
        
    });
    
    it(@"should provide a method to be able to remove items via index", ^{
        
        [layout addSubview:subview1];
        
        expect(layout.items.count).to.equal(1);
        
        [layout removeLayoutItemAtIndex:0];
        
        expect(layout.items.count).to.equal(0);
        
    });
    
    it(@"should provide a method to remove any layout item at a specific position in the layout hirarchy", ^{
        
        LKLayoutItem *item = [layout addSubview:subview1];
        [layout addSubview:subview2];
        LKLayoutItem *item3 = [layout addSubview:subview3];
        
        expect(layout.items.count).to.equal(3);
        
        [layout removeLayoutItemAtIndex:1];
        
        expect(layout.items.count).to.equal(2);
        
        expect(item).to.equal(layout.items[0]);
        expect(item3).to.equal(layout.items[1]);
        
    });
    
    it(@"should provide a method to remove a layout item", ^{
        
        LKLayoutItem *item = [layout addSubview:subview1];
        
        expect(layout.items.count).to.equal(1);
        
        [layout removeLayoutItem:item];
        
        expect(layout.items.count).to.equal(0);
        
    });
    
    it(@"should provide a method to add a layout item", ^{
        
        LKLayoutItem *item = [layout addSubview:subview1];
        [item removeFromLayout];
        
        expect(layout.items.count).to.equal(0);
        
        [layout addLayoutItem:item];
        
        expect(layout.items.count).to.equal(1);
        
    });
    
    it(@"should provide a method to append layout item at the end of the layout", ^{
        
        LKLayoutItem *item = [layout addSubview:subview1];
        [layout addSubview:subview2];
        [layout addSubview:subview3];
        [layout addSubview:subview4];
        
        expect(layout.items.count).to.equal(4);
        
        [item removeFromLayout];
        
        expect(layout.items.count).to.equal(3);
        
        [layout addLayoutItem:item];
        
        expect(layout.items.count).to.equal(4);
        
        LKLayoutItem *itemAtLastPosition = layout.items[layout.items.count - 1];
        
        expect(itemAtLastPosition).to.equal(item);
        
    });
    
    it(@"should provide a method to delete all child items", ^{
        
        [layout addSubview:subview1];
        [layout addSubview:subview2];
        [layout addSubview:subview3];
        [layout addSubview:subview4];
        
        expect(layout.items.count).to.equal(4);
        
        [layout clear];
        
        expect(layout.items.count).to.equal(0);
        
    });
    
    it(@"should automatically remove a layout item from an old layout with adding it to another one", ^{
        
        UIView *container2 = [[UIView alloc] init];
        LKLayout *layout2 = [[LKLayout alloc] initWithView:container2];
        
        LKLayoutItem *item = [layout2 addSubview:subview1];
        
        [layout addLayoutItem:item];
        
        // Is it removed from the old layout
        expect(layout2.items.count).to.equal(0);
        
        // Is it inserted in the new layout
        expect(layout.items.count).to.equal(1);
        expect(layout.items[0]).to.equal(item);
        
        // Does it changed it superview
        expect(item.subview.superview).to.equal(container);
        
    });
    
    it(@"should not retain a view its view in order to prevent retain cycles", ^{
        
        __weak UIView *view = nil;
        __strong LKLayout *layout = [[LKLayout alloc] init];
        
        @autoreleasepool {
            UIView *localReleasedView = [[UIView alloc] init];
            localReleasedView = [[UIView alloc] init];
            view = localReleasedView;
            
            layout.view = view;
        }
        
        expect(layout.view).to.equal(nil);
        
    });
    
    it(@"should not retain its item since its holding the layout", ^{
        
        __weak LKLayoutItem *weakLayoutItem = nil;
        __strong LKLayout *layout = [[LKLayout alloc] init];
        
        @autoreleasepool {
            LKLayoutItem *layoutItem = [[LKLayoutItem alloc] init];
            weakLayoutItem = layoutItem;
            
            layout.item = weakLayoutItem;
        }
        
        expect(layout.item).to.equal(nil);
        
    });
    
    it(@"should not assign a layout item to a view if its not added", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        
        expect(childView.item).to.equal(nil);
        
    });
    
    it(@"should assign a layout item to view with adding a subview", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        expect(childView.item).to.equal(layoutItem);
        
    });
    
    it(@"should assign the layout item to the given view with adding by inserting", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout insertSubview:childView atIndex:0];
        
        expect(childView.item).to.equal(layoutItem);
        
    });
    
    it(@"should un-assign the layout item from the view with removing the object via layout items removeFromParent", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(childView.item).to.equal(nil);
        
    });
    
    it(@"should un-assign the layout item from the view with removing the object from layout", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layout removeLayoutItem:layoutItem];
        
        expect(childView.item).to.equal(nil);
        
    });
    
    it(@"should un-assign the layout item from the view with removing the object by index", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        [layout removeLayoutItemAtIndex:0];
        
        expect(childView.item).to.equal(nil);
        
    });
    
    it(@"should un-assign the layout item from the view with removing the object by clearing", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        [layout addSubview:childView];
        
        [layout clear];
        
        expect(childView.item).to.equal(nil);
        
    });
    
    it(@"should re-assign the layout item from the view with removing the object", ^{
        
        UIView *childView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        LKLayoutItem *layoutItem = [layout addSubview:childView];
        
        [layoutItem removeFromLayout];
        
        expect(childView.item).to.equal(nil);
        
        [layout addLayoutItem:layoutItem];
        
        expect(childView.item).to.equal(layoutItem);
        
    });
    
});

SpecEnd