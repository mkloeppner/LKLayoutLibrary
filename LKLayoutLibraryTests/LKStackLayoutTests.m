//
//  MKStackLayoutTests.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKStackLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(LKStackLayoutSpecification)

describe(@"LKStackLayout", ^{
    
    __block LKStackLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 200.0)];
        layout = [[LKStackLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
    it(@"should stack a view", ^{
        
        [layout addSubview:subview1];
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);
        
    });
    
    it(@"should stack two views", ^{
        
        [layout addSubview:subview1];
        [layout addSubview:subview2];
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);
        
        expect(0.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f).to.equal(subview2.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview2.frame.size.width);
        expect(container.frame.size.height).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);
        
    });

    it(@"should stack two views with match parent size", ^{

        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        LKStackLayoutItem *layoutItem2 = [layout addSubview:subview2];

        layoutItem1.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, kLKLayoutItemSizeValueMatchParent);
        layoutItem2.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, kLKLayoutItemSizeValueMatchParent);

        [layout layout];

        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);

        expect(0.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f).to.equal(subview2.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview2.frame.size.width);
        expect(container.frame.size.height).to.equal(subview2.frame.size.height);

        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);

    });
    
    it(@"should insert a margin for a view its specified", ^{
        
        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        layoutItem1.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);

        [layout layout];
        
        expect(0.0f + 5.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 5.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 10.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 10.0f).to.equal(subview1.frame.size.height);
        
    });

    it(@"should apply outer margin", ^{

        [layout addSubview:subview1];

        layout.margin = UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        [layout layout];

        expect(0.0f + 3.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 3.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 6.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 6.0f).to.equal(subview1.frame.size.height);

    });

    it(@"should apply outer margin and the cell item margin", ^{

        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        layoutItem1.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);

        layout.margin = UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        [layout layout];

        expect(0.0f + 5.0f + 3.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 5.0f + 3.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 10.0f - 6.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 10.0f - 6.0f).to.equal(subview1.frame.size.height);

    });
    
    it(@"should insert different margins for different views", ^{
        
        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        LKStackLayoutItem *layoutItem2 = [layout addSubview:subview2];
        
        layoutItem1.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layoutItem2.padding = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
        [layout layout];
        
        expect(0.0f + 10.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 10.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 20.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 20.0f).to.equal(subview1.frame.size.height);
        
        expect(0.0f + 15.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f + 15.0f).to.equal(subview2.frame.origin.y);
        expect(container.frame.size.width - 30.0f).to.equal(subview2.frame.size.width);
        expect(container.frame.size.height - 30.0f).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);
        
    });

    it(@"should insert different margins for different views and apply the global outer margin for layout", ^{

        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        LKStackLayoutItem *layoutItem2 = [layout addSubview:subview2];

        layoutItem1.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layoutItem2.padding = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);

        layout.margin = UIEdgeInsetsMake(2.0f, 2.0f, 2.0f, 2.0f);
        [layout layout];

        expect(0.0f + 10.0f + 2.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 10.0f + 2.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 20.0f - 4.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 20.0f - 4.0f).to.equal(subview1.frame.size.height);

        expect(0.0f + 15.0f + 2.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f + 15.0f + 2.0f).to.equal(subview2.frame.origin.y);
        expect(container.frame.size.width - 30.0f - 4.0f).to.equal(subview2.frame.size.width);
        expect(container.frame.size.height - 30.0f - 4.0f).to.equal(subview2.frame.size.height);

        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);

    });
    
    it(@"should layout sublayouts in stack layout", ^{
        
        LKStackLayout *sublayout = [[LKStackLayout alloc] initWithView:container];
        [sublayout addSubview:subview1];
        [layout addSublayout:sublayout];
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);
        
    });
    
    it(@"should apply margin of sublayout", ^{
        
        LKStackLayout *sublayout = [[LKStackLayout alloc] initWithView:container];
        LKStackLayoutItem *layoutItem1 = [sublayout addSubview:subview1];
        layoutItem1.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        [layout addSublayout:sublayout];
        
        [layout layout];
        
        expect(0.0f + 10.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 10.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 20.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 20.0f).to.equal(subview1.frame.size.height);
        
    });
    
    it(@"should apply margin with a depth of hirarchy of two", ^{
        
        LKStackLayout *stackLayout = [[LKStackLayout alloc] initWithView:container];
        LKStackLayoutItem *layoutItem1 = [layout addSublayout:stackLayout];
        
        LKStackLayoutItem *layoutItem2 = [stackLayout addSubview:subview1];
        
        layoutItem1.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layoutItem2.padding = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
        [layout layout];
        
        expect(0.0f + 10.0f + 15.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f + 10.0f + 15.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 20.0f - 30.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 20.0f - 30.0f).to.equal(subview1.frame.size.height);
        
        
    });
    
    it(@"should apply margin with a depth of hirarchy of three", ^{
        
        LKStackLayout *stackLayout = [[LKStackLayout alloc] initWithView:container];
        LKStackLayoutItem *stackLayoutItem1 = [layout addSublayout:stackLayout];
        
        LKStackLayout *stackLayout2 = [[LKStackLayout alloc] initWithView:container];
        LKStackLayoutItem *stackLayoutItem2 = [stackLayout addSublayout:stackLayout2];
        
        LKStackLayoutItem *viewLayoutItem = [stackLayout2 addSubview:subview1];
        
        stackLayoutItem1.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        stackLayoutItem2.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        viewLayoutItem.padding = UIEdgeInsetsMake(15.0f, 15.0f, 15.0f, 15.0f);
        
        stackLayoutItem1.userInfo = @{@"name" : @"stackLayoutItem1"};
        stackLayoutItem2.userInfo = @{@"name" : @"stackLayoutItem2"};
        viewLayoutItem.userInfo = @{@"name" : @"viewLayoutItem"};
        
        [layout layout];
        
        expect(5.0f + 10.0f + 15.0f).to.equal(subview1.frame.origin.x);
        expect(5.0f + 10.0f + 15.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width - 10.0f - 20.0f - 30.0f).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height - 10.0f - 20.0f - 30.0f).to.equal(subview1.frame.size.height);
    });
    
    it(@"should use parent size if size is set to use the parent size", ^{
        
        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        LKStackLayoutItem *layoutItem2 = [layout addSubview:subview2];
        
        layoutItem1.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, kLKLayoutItemSizeValueMatchParent);
        layoutItem2.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, kLKLayoutItemSizeValueMatchParent);
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview1.frame.size.width);
        expect(container.frame.size.height).to.equal(subview1.frame.size.height);
        
        expect(0.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f).to.equal(subview2.frame.origin.y);
        expect(container.frame.size.width).to.equal(subview2.frame.size.width);
        expect(container.frame.size.height).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);
        
    });
    
    it(@"should apply size if size is beeing set", ^{
        
        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        LKStackLayoutItem *layoutItem2 = [layout addSubview:subview2];
        
        layoutItem1.size = CGSizeMake(57.0f, 57.0f);
        layoutItem2.size = CGSizeMake(31.0f, 3.0f);
        
        [layout layout];
        
        expect(0.0f).to.equal(subview1.frame.origin.x);
        expect(0.0f).to.equal(subview1.frame.origin.y);
        expect(layoutItem1.size.width).to.equal(subview1.frame.size.width);
        expect(layoutItem1.size.height).to.equal(subview1.frame.size.height);
        
        expect(0.0f).to.equal(subview2.frame.origin.x);
        expect(0.0f).to.equal(subview2.frame.origin.y);
        expect(layoutItem2.size.width).to.equal(subview2.frame.size.width);
        expect(layoutItem2.size.height).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);
        
    }),
    
    it(@"should apply size and margin", ^{
        
        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        LKStackLayoutItem *layoutItem2 = [layout addSubview:subview2];
        
        layoutItem1.size = CGSizeMake(57.0f, 57.0f);
        layoutItem1.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        layoutItem2.size = CGSizeMake(31.0f, 10.0f);
        layoutItem2.padding = UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        
        [layout layout];
        
        expect(layoutItem1.padding.left).to.equal(subview1.frame.origin.x);
        expect(layoutItem1.padding.top).to.equal(subview1.frame.origin.y);
        expect(layoutItem1.size.width - layoutItem1.padding.left - layoutItem1.padding.right).to.equal(subview1.frame.size.width);
        expect(layoutItem1.size.height - layoutItem1.padding.top - layoutItem1.padding.bottom).to.equal(subview1.frame.size.height);
        
        expect(layoutItem2.padding.left).to.equal(subview2.frame.origin.x);
        expect(layoutItem2.padding.top).to.equal(subview2.frame.origin.y);
        expect(layoutItem2.size.width - layoutItem2.padding.left - layoutItem2.padding.right).to.equal(subview2.frame.size.width);
        expect(layoutItem2.size.height - layoutItem2.padding.top - layoutItem2.padding.bottom).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);
        
        
    });
    
    it(@"should apply size and margin and gravity top left and bottom right", ^{
        
        LKStackLayoutItem *layoutItem1 = [layout addSubview:subview1];
        LKStackLayoutItem *layoutItem2 = [layout addSubview:subview2];
        
        layoutItem1.size = CGSizeMake(57.0f, 57.0f);
        layoutItem1.padding = UIEdgeInsetsMake(7.0f, 5.0f, 5.0f, 5.0f);
        layoutItem1.gravity = LKLayoutGravityTop | LKLayoutGravityLeft;
        layoutItem2.size = CGSizeMake(31.0f, 25.0f);
        layoutItem2.padding = UIEdgeInsetsMake(6.0f, 4.0f, 3.0f, 3.0f);
        layoutItem2.gravity = LKLayoutGravityBottom | LKLayoutGravityRight;
        
        [layout layout];
        
        expect(layoutItem1.padding.left).to.equal(subview1.frame.origin.x);
        expect(layoutItem1.padding.top).to.equal(subview1.frame.origin.y);
        expect(layoutItem1.size.width - layoutItem1.padding.left - layoutItem1.padding.right).to.equal(subview1.frame.size.width);
        expect(layoutItem1.size.height - layoutItem1.padding.top - layoutItem1.padding.bottom).to.equal(subview1.frame.size.height);
        
        expect(container.frame.size.width - layoutItem2.size.width + layoutItem2.padding.left).to.equal(subview2.frame.origin.x);
        expect(container.frame.size.height - layoutItem2.size.height + layoutItem2.padding.top).to.equal(subview2.frame.origin.y);
        expect(layoutItem2.size.width - layoutItem2.padding.left - layoutItem2.padding.right).to.equal(subview2.frame.size.width);
        expect(layoutItem2.size.height - layoutItem2.padding.top - layoutItem2.padding.bottom).to.equal(subview2.frame.size.height);
        
        // draw order
        expect(layout.items.count).to.equal(2);
        expect(subview1).to.equal([layout.items[0] subview]);
        expect(subview2).to.equal([layout.items[1] subview]);
        
        
    });
    
});

SpecEnd
