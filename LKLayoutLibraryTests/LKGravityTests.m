//
//  MKGravityTests.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/2/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKGravity.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define MOCKITO_SHORTHAND
#import "OCMockito.h"

SpecBegin(LKGravitySpecification)

describe(@"LKGravity", ^{
    
    __block LKGravity *gravity;
    __block CGRect rect;
    __block CGRect itemRect;
    
    beforeEach(^{
        rect = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
        itemRect = CGRectMake(0.0f, 0.0f, 10.0f, 10.0f);
        
        gravity = [[LKGravity alloc] initWithCGRect:itemRect parent:rect];
    });
    
    it(@"should not apply gravity if gravity it set to LKLayoutGravityNone", ^{

        [gravity moveByGravity:LKLayoutGravityNone];
        
        expect(gravity.CGRect).to.equal(itemRect);
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally (center)", ^{

        [gravity moveByGravity:LKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, 0.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect vertically (center)", ^{

        [gravity moveByGravity:LKLayoutGravityCenterVertical];
        
        expect(gravity.CGRect).to.equal(CGRectMake(0.0f, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally and vertically (center)", ^{

        [gravity moveByGravity:LKLayoutGravityCenterHorizontal | LKLayoutGravityCenterVertical];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect horizontally and keep the vertical offset", ^{

        [gravity moveByGravity:LKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f, itemRect.origin.y, itemRect.size.width, itemRect.size.height));
        
    });
    
    it(@"should apply a gravity for rect within another rect vertically and keep the horizontal offset", ^{

        [gravity moveByGravity:LKLayoutGravityCenterVertical];
        
        expect(gravity.CGRect).to.equal(CGRectMake(itemRect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to topleft", ^{

        [gravity moveByGravity:LKLayoutGravityTop | LKLayoutGravityLeft];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to topright", ^{

        [gravity moveByGravity:LKLayoutGravityTop | LKLayoutGravityRight];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to top and horizontalcenter", ^{

        [gravity moveByGravity:LKLayoutGravityTop | LKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottomleft", ^{

        [gravity moveByGravity:LKLayoutGravityBottom | LKLayoutGravityLeft];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.origin.x, rect.size.height - itemRect.size.height, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottomright", ^{


        [gravity moveByGravity:LKLayoutGravityBottom | LKLayoutGravityRight];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.size.height - itemRect.size.height + rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to bottom and horizontalcenter", ^{

        [gravity moveByGravity:LKLayoutGravityBottom | LKLayoutGravityCenterHorizontal];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.size.height - itemRect.size.height + rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to vericalcenter left", ^{

        [gravity moveByGravity:LKLayoutGravityCenterVertical | LKLayoutGravityLeft];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to verticalcenter right", ^{

        [gravity moveByGravity:LKLayoutGravityCenterVertical | LKLayoutGravityRight];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width - itemRect.size.width + rect.origin.x, rect.size.height / 2.0f - itemRect.size.height / 2.0f, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to horizontalcenter top", ^{

        [gravity moveByGravity:LKLayoutGravityCenterHorizontal | LKLayoutGravityTop];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.origin.y, itemRect.size.width, itemRect.size.height));
    });
    
    it(@"should apply a gravity for rect within another rect to horizontalcenter bottom", ^{


        [gravity moveByGravity:LKLayoutGravityCenterHorizontal | LKLayoutGravityBottom];
        
        expect(gravity.CGRect).to.equal(CGRectMake(rect.size.width / 2.0f - itemRect.size.width / 2.0f + rect.origin.x, rect.size.height - itemRect.size.height, itemRect.size.width, itemRect.size.height));
    });
    
    
});

SpecEnd