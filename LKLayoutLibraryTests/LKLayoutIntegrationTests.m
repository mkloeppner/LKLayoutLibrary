//
//  MKStackLayoutTests.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKLinearLayout.h"
#import "LKFlowLayout.h"
#import <UIKit/UIKit.h>

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(LKLayoutIntegrationTests)

describe(@"LKStackLayout", ^{
    
    __block LKLinearLayout *layout;
    __block UIView *container;
    
    __block UIView *subview1;
    __block UIView *subview2;
    
    it(@"should stack a view", ^{
        
        container = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
        
        layout = [[LKLinearLayout alloc] initWithView:container];
        layout.margin = UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f);
        
        LKFlowLayout *sublayout = [[LKFlowLayout alloc] init];
        LKLinearLayoutItem *flowLayoutItem = [layout addSublayout:sublayout];
        flowLayoutItem.size = CGSizeMake(kLKLayoutItemSizeValueMatchContents, kLKLayoutItemSizeValueMatchContents);
        
        for (int i = 0; i < 100; i++) {
            UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
            LKFlowLayoutItem *item = [sublayout addSubview:view];
        
            item.size = CGSizeMake(10.0f, 10.0f);
        }
        
        CGSize size = [layout size];
        
        expect(size.width).to.equal(120.0f);
        expect(size.height).to.equal(120.0f);
        
    });
        
});

SpecEnd

