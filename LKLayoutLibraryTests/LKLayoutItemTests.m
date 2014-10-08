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

SpecBegin(LKLayoutItemSpecification)

describe(@"LKLayout", ^{
    
    __block LKLayout *layout;
    __block UIView *container;
    
    __block UIView *view;
    __block UIView *view2;
    __block LKLayout *sublayout;
    __block UIView *sublayoutView;
    
    __block LKLayoutItem *viewItem;
    __block LKLayoutItem *viewItem2;
    __block LKLayoutItem *sublayoutItem;
    __block LKLayoutItem *sublayoutViewItem;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[LKLayout alloc] initWithView:container];
        
        view = [[UIView alloc] init];
        view2 = [[UIView alloc] init];
        sublayout = [[LKLayout alloc] init];
        sublayoutView = [[UIView alloc] init];
        
        viewItem = [layout addSubview:view];
        viewItem2 = [layout addSubview:view2];
        sublayoutItem = [layout addSublayout:sublayout];
        sublayoutViewItem = [sublayout addSubview:sublayoutView];
        
        expect(sublayout).to.equal(sublayoutItem.sublayout);
        expect(sublayout).toNot.equal(nil);
        
    });
    
    it(@"should keep sublayout items of its sublayout if its removed from layout by calling removeFromLayout", ^{
        
        expect(sublayout.items.count).to.equal(1);
        expect([sublayout.items[0] subview]).to.equal(sublayoutView);
        
        [sublayoutItem removeFromLayout];
        
        expect(sublayout.items.count).to.equal(1);
        expect([sublayout.items[0] subview]).to.equal(sublayoutView);
        
    });
});

SpecEnd