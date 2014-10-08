//
//  MKLayoutLibraryLayoutIntegrationTests.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 3/30/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKLayoutLibrary.h"

#define EXP_SHORTHAND
#import "Expecta.h"


SpecBegin(LKLayoutLibraryIntegrationSpecification)

describe(@"LKLayoutLibraryIntegration", ^{
    
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
    
    
    it(@"should calculate the right amount of horizontal and vertical separators in a horizontal layout with a vertical sublayout which is a sublayout of stacklayout", ^{
        layout = [[LKStackLayout alloc] initWithView:container];
        
        LKLinearLayout *linearLayout = [[LKLinearLayout alloc] init];
        linearLayout.orientation = LKLayoutOrientationVertical;
        
        LKLinearLayoutItem *subview1LayoutItem =[linearLayout addSubview:subview1];
        subview1LayoutItem.insertBorder = YES;
        
        LKLinearLayout *sublayout1 = [[LKLinearLayout alloc] init];
        sublayout1.orientation = LKLayoutOrientationHorizontal;
        
        LKLinearLayoutItem *subview2LayoutItem =[sublayout1 addSubview:subview2];
        subview2LayoutItem.insertBorder = YES;
        
        LKLinearLayoutItem *subview3LayoutItem =[sublayout1 addSubview:subview3];
        subview3LayoutItem.insertBorder = YES;
        
        LKLinearLayoutItem *subview4LayoutItem =[sublayout1 addSubview:subview4];
        subview4LayoutItem.insertBorder = YES;
        
        LKLinearLayoutItem *sublayout1LayoutItem =[linearLayout addSublayout:sublayout1];
        sublayout1LayoutItem.insertBorder = YES;
        
        [layout addSublayout:linearLayout];
        
        expect([layout numberOfBordersForOrientation:
LKLayoutOrientationVertical]).to.equal(2);
        expect([layout numberOfBordersForOrientation:
LKLayoutOrientationHorizontal]).to.equal(1);
        
    });
    
    it(@"should calculate the right amount of horizontal and vertical separators in a vertical layout with a horizontal sublayout which is a sublayout of stacklayout", ^{
        
        layout = [[LKStackLayout alloc] initWithView:container];
        
        LKLinearLayout *linearLayout = [[LKLinearLayout alloc] init];
        linearLayout.orientation = LKLayoutOrientationHorizontal;
        
        LKLinearLayoutItem *subview1LayoutItem = [linearLayout addSubview:subview1];
        subview1LayoutItem.insertBorder = YES;
        
        LKLinearLayout *sublayout1 = [[LKLinearLayout alloc] init];
        sublayout1.orientation = LKLayoutOrientationVertical;
        
        LKLinearLayoutItem *subview2LayoutItem =[sublayout1 addSubview:subview2];
        subview2LayoutItem.insertBorder = YES;
        
        LKLinearLayoutItem *subview3LayoutItem =[sublayout1 addSubview:subview3];
        subview3LayoutItem.insertBorder = YES;
        
        LKLinearLayoutItem *subview4LayoutItem =[sublayout1 addSubview:subview4];
        subview4LayoutItem.insertBorder = YES;
        
        LKLinearLayoutItem *sublayout1LayoutItem =[linearLayout addSublayout:sublayout1];
        sublayout1LayoutItem.insertBorder = YES;
        
        [layout addSublayout:linearLayout];
        
        expect([layout numberOfBordersForOrientation:
LKLayoutOrientationVertical]).to.equal(1);
        expect([layout numberOfBordersForOrientation:
LKLayoutOrientationHorizontal]).to.equal(2);
        
    });
    
});

SpecEnd
