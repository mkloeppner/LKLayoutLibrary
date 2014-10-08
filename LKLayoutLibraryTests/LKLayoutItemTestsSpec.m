//
//  LKLayoutItemTestsSpec.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 4/19/14.
//  Copyright 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKLayout.h"
#import "LKLayoutDelegateImpl.h"

#define EXP_SHORTHAND
#import "Expecta.h"

SpecBegin(LKLayoutItemTests)

describe(@"LKLayoutItemTests", ^{
    
    __block UIView *container;
    
    __block LKLayout *layout;
    
    __block UIView *subview1;
    __block UIView *subview2;
    __block UIView *subview3;
    __block UIView *subview4;
    
    beforeEach(^{
        
        container = [[UIView alloc] initWithFrame:(CGRect){300.0f}];
        
        layout = [[LKLayout alloc] initWithView:container];
        
        subview1 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
        subview2 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
        subview3 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
        subview4 = [[UIView alloc] initWithFrame:(CGRect){100.0f}];
    });
    
    it(@"should provide a userInfo dictionary in order to allow introspection", ^{
        
        NSDictionary *userInfo = @{@"test": @"test"};
        
        LKLayoutItem *layoutItem = [layout addSubview:subview1];
        layoutItem.userInfo = userInfo;
        
        expect(userInfo).to.equal(userInfo);
        
    });
    
    it(@"should not remove its sublayout views if its a sublayout item and removeFromLayout is beeing called", ^{
        
        LKLayout *sublayout = [[LKLayout alloc] init];
        [sublayout addSubview:subview1];
        
        expect(sublayout.items.count).to.equal(1);
        
        LKLayoutItem *layoutItem = [layout addSublayout:sublayout];
        
        expect(sublayout.items.count).to.equal(1);
        
        [layoutItem removeFromLayout];
        
        expect(sublayout.items.count).to.equal(1);
        
    });
    
    it(@"should not retain its delegate since its holding the layout", ^{
        
        __weak LKLayoutDelegateImpl *weakInstanceOfLayoutDelegate = nil;
        __strong LKLayout *layout = [[LKLayout alloc] init];
        
        @autoreleasepool {
            LKLayoutDelegateImpl *createdInstanceOfLayoutDelegate = [[LKLayoutDelegateImpl alloc] init];
            weakInstanceOfLayoutDelegate = createdInstanceOfLayoutDelegate;
            
            layout.delegate = weakInstanceOfLayoutDelegate;
        }
        
        expect(layout.delegate).to.equal(nil);
        
    });
    
});

SpecEnd
