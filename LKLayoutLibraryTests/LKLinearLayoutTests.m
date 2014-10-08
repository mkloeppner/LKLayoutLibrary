//
//  MKLayoutTests.m
//  MKLayoutTests
//
//  Created by Martin Klöppner on 1/10/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKLinearLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(LKLinearLayoutSpecification)

describe(@"LKLinearLayout", ^{
    
    __block LKLinearLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    __block UIView *subview4;
    
    beforeEach(^{
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 300.0f, 100.0)];
        layout = [[LKLinearLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview2 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview3 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
        subview4 = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 10.0f, 10.0f)];
    });
    
    it(@"should layout a view with the specified size", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, 40.0f);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
    });
    
    it(@"should size a view with the parent size if nothing is specified", ^{
        [layout addSubview:subview1];
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    // Absolute layouting
    it(@"should layout a view horinzontally with the specified width", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views horinzontally with specified widths", ^{
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(70.0f, kLKLayoutItemSizeValueMatchParent);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout two views horinzontally with specified sizes and uses outer gravity", ^{
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, 10.0f);
        layoutItem.gravity = LKLayoutGravityCenterVertical;
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(70.0f, 20.0f);
        layoutItem2.gravity = LKLayoutGravityCenterVertical;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(container.bounds.size.height / 2.0f - layoutItem.size.height / 2.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(container.bounds.size.height / 2.0f - layoutItem2.size.height / 2.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.size.width);
        expect(subview2.frame.size.height).to.equal(layoutItem2.size.height);
        
    });
    
    it(@"should layout a view vertically with the specified width", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, 30.0f);
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
    });
    
    it(@"should layout two views vertically with specified widths", ^{
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, 30.0f);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, 70.0f);
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(layoutItem.size.height);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(layoutItem2.size.height);
        
    });
    
    it(@"should apply outer margin", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        
        layout.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 10.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 10.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 20.0f);
    });
    
    it(@"should apply outer margin and item margin", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        layoutItem.padding = UIEdgeInsetsMake(3.0f, 3.0f, 3.0f, 3.0f);
        
        layout.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 10.0f + 3.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 10.0f + 3.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width - layoutItem.padding.left - layoutItem.padding.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 20.0f - 6.0f);
    });
    
    it(@"should layout a view horizontally with margin specified", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width  - layoutItem.padding.left - layoutItem.padding.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
    });
    
    it(@"should layout two views horizontally with margin specified", ^{
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);;
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(70.0f, kLKLayoutItemSizeValueMatchParent);
        layoutItem2.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width  - layoutItem.padding.left - layoutItem.padding.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width + 5.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview2.frame.size.width).to.equal(layoutItem2.size.width  - layoutItem2.padding.left - layoutItem2.padding.right);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
    });
    
    it(@"should layout a view vertically with margin specified", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, 30.0f);
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height  - layoutItem.padding.top - layoutItem.padding.bottom);
    });
    
    it(@"should layout two views vertically with margin specified", ^{
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, 30.0f);
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.size = CGSizeMake(kLKLayoutItemSizeValueMatchParent, 70.0f);
        layoutItem2.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f );
        expect(subview1.frame.size.height).to.equal(layoutItem.size.height - layoutItem.padding.top - layoutItem.padding.bottom);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview2.frame.origin.y).to.equal(layoutItem.size.height + 5.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview2.frame.size.height).to.equal(layoutItem2.size.height - layoutItem2.padding.top - layoutItem2.padding.bottom);
        
    });
    
    // Relative layouting
    it(@"should layout a view horizontally with specified weight", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views horizontally with specified weights", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 2.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 2.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views horizontally with different weights", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width * 1.0f / 3.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width * 1.0f / 3.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width * 2.0f / 3.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout a view vertically with specified weight", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout two views vertically with specified weights", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 2.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 2.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 2.0f);
    });
    
    it(@"should layout two views vertically with different weights", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).beCloseToWithin(container.frame.size.height * 1.0f / 3.0f, 1.0f / layout.contentScaleFactor);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.beCloseToWithin(container.frame.size.height * 1.0f / 3.0f, 1.0f / layout.contentScaleFactor);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.beCloseToWithin(container.frame.size.height * 2.0f / 3.0f, 1.0f / layout.contentScaleFactor);
    });
    
    // Also test marigin
    it(@"should layout a view horizontally with specified weight and margin", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(5.0f);
        expect(subview1.frame.origin.y).to.equal(5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
    });
    
    it(@"should layout two views horizontally with specified weights and different margins", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(5.0f);
        expect(subview1.frame.origin.y).to.equal(5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 2.0f - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 2.0f + 10.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f + 10.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 2.0f - 20.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - 20.0f);
    });
    
    it(@"should layout two views horizontally with different weights and different margins", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        layoutItem2.padding = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width * 1.0f / 3.0f - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width * 1.0f / 3.0f + 13.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f + 13.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width * 2.0f / 3.0f - 26.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height - 26.0f);
    });
    
    it(@"should layout a view vertically with specified weight and margin", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - 10.0f);
    });
    
    it(@"should layout two views vertically with specified weights and different margins", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        layoutItem2.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 2.0f - 10.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + 10.0f);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 2.0f + 10.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - 20.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 2.0f - 20.0f);
    });
    
    it(@"should layout two views vertically with different weights and different margins", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        layoutItem.padding = UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 2.0f;
        layoutItem2.padding = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + 5.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f + 5.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - 10.0f);
        expect(subview1.frame.size.height).beCloseToWithin(container.frame.size.height * 1.0f / 3.0f - 10.0f, 1.0f / layout.contentScaleFactor);
        
        expect(subview2.frame.origin.x).to.equal(0.0f + 10.0f);
        expect(subview2.frame.origin.y).to.beCloseToWithin(container.frame.size.height * 1.0f / 3.0f + 10.0f, 1.0f / layout.contentScaleFactor);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - 20.0f);
        expect(subview2.frame.size.height).to.beCloseToWithin(container.frame.size.height * 2.0f / 3.0f - 20.0f, 1.0f / layout.contentScaleFactor);
    });
    
    // Mixed layouting
    it(@"should layout two views horizontally with one absolute and the other with relative size specified", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should layout three views horizontally with one absolute and the others with relative size specified", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) / 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview3.frame.origin.x).to.equal(subview2.frame.origin.x + subview2.frame.size.width);
        expect(subview3.frame.origin.y).to.equal(0.0f);
        expect(subview3.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) / 2.0f);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should layout three views horizontally with one absolute and the others with different relative sizes specified", ^{
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem3 = [layout addSubview:subview3];
        layoutItem3.weight = 2.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) * 1.0f / 3.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview3.frame.origin.x).to.equal(subview2.frame.origin.x + subview2.frame.size.width);
        expect(subview3.frame.origin.y).to.equal(0.0f);
        expect(subview3.frame.size.width).to.equal((container.frame.size.width - layoutItem.size.width) * 2.0f / 3.0f);
        expect(subview3.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    // Sublayouts
    it(@"should layout views of a sublayout", ^{
        
        // Creation of sublayout
        LKLinearLayout *sublayout = [[LKLinearLayout alloc] initWithView:container];
        sublayout.orientation = LKLayoutOrientationHorizontal;
        
        LKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview1];
        sublayoutItem.weight = 1.0f;
        // Ends creation
        
        LKLinearLayoutItem *layoutItem = [layout addSublayout:sublayout];
        layoutItem.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
    });
    
    it(@"should apply margin of a sublayout", ^{
        
        UIEdgeInsets margin = UIEdgeInsetsMake(3.0f, 13.0f, 2.0f, 4.0f);
        
        // Creation of sublayout
        LKLinearLayout *sublayout = [[LKLinearLayout alloc] initWithView:container];
        sublayout.orientation = LKLayoutOrientationHorizontal;
        
        LKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview1];
        sublayoutItem.weight = 1.0f;
        sublayoutItem.padding = margin;
        // Ends creation
        
        LKLinearLayoutItem *layoutItem = [layout addSublayout:sublayout];
        layoutItem.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + margin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + margin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - margin.left - margin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - margin.top - margin.bottom);
        
    });
    
    it(@"should layout the sublayout views with contentBounds of the sublayout item regarding position and available space", ^{
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.size = CGSizeMake(30.0f, kLKLayoutItemSizeValueMatchParent);
        
        // Creation of sublayout
        LKLinearLayout *sublayout = [[LKLinearLayout alloc] initWithView:container];
        sublayout.orientation = LKLayoutOrientationHorizontal;
        
        LKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview2];
        sublayoutItem.weight = 1.0f;
        // Ends creation
        
        LKLinearLayoutItem *layoutItem2 = [layout addSublayout:sublayout];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(layoutItem.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(layoutItem.size.width);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width - layoutItem.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
    });
    
    
    it(@"should apply margin of a sublayout and its sublayout views margins with depth of hirary of 2", ^{
        
        UIEdgeInsets margin = UIEdgeInsetsMake(3.0f, 13.0f, 2.0f, 4.0f);
        UIEdgeInsets sublayoutViewMargin = UIEdgeInsetsMake(4.0f, 5.0f, 13.0f, 1.0f);
        
        // Creation of sublayout
        LKLinearLayout *sublayout = [[LKLinearLayout alloc] initWithView:container];
        sublayout.orientation = LKLayoutOrientationHorizontal;
        
        LKLinearLayoutItem *sublayoutItem = [sublayout addSubview:subview1];
        sublayoutItem.weight = 1.0f;
        sublayoutItem.padding = sublayoutViewMargin;
        // Ends creation
        
        LKLinearLayoutItem *layoutItem = [layout addSublayout:sublayout];
        layoutItem.weight = 1.0f;
        layoutItem.padding = margin;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f + margin.left + sublayoutViewMargin.left);
        expect(subview1.frame.origin.y).to.equal(0.0f + margin.top + sublayoutViewMargin.top);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width - margin.left - margin.right - sublayoutViewMargin.left - sublayoutViewMargin.right);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height - margin.top - margin.bottom - sublayoutViewMargin.top - sublayoutViewMargin.bottom);
        
    });
    
    it(@"should insert spacing between two items in a horizontal layout and not insert a spacing before the first item and the last item", ^{
        
        layout.spacing = 10.0f;
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width / 2.0f - layout.spacing / 2.0f);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
        expect(subview2.frame.origin.x).to.equal(container.frame.size.width / 2.0f + layout.spacing / 2.0f);
        expect(subview2.frame.origin.y).to.equal(0.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width / 2.0f - layout.spacing / 2.0f);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should not insert a spacing before the first and the last item with in horizontal layout even if the first and the last item is the same", ^{
        
        layout.spacing = 10.0f;
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
    
        layout.orientation = LKLayoutOrientationHorizontal;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
    it(@"should insert spacing between two items in a vertical layout and not insert a spacing before the first item and the last item", ^{
        
        layout.spacing = 10.0f;
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        LKLinearLayoutItem *layoutItem2 = [layout addSubview:subview2];
        layoutItem2.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height / 2.0f - layout.spacing / 2.0f);
        
        expect(subview2.frame.origin.x).to.equal(0.0f);
        expect(subview2.frame.origin.y).to.equal(container.frame.size.height / 2.0f + layout.spacing / 2.0f);
        expect(subview2.frame.size.width).to.equal(container.frame.size.width);
        expect(subview2.frame.size.height).to.equal(container.frame.size.height / 2.0f - layout.spacing / 2.0f);
        
    });

    it(@"should not insert a spacing before the first and the last item with in vertical layout even if the first and the last item is the same", ^{
        
        layout.spacing = 10.0f;
        
        LKLinearLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.weight = 1.0f;
        
        layout.orientation = LKLayoutOrientationVertical;
        [layout layout];
        
        expect(subview1.frame.origin.x).to.equal(0.0f);
        expect(subview1.frame.origin.y).to.equal(0.0f);
        expect(subview1.frame.size.width).to.equal(container.frame.size.width);
        expect(subview1.frame.size.height).to.equal(container.frame.size.height);
        
    });
    
});

SpecEnd