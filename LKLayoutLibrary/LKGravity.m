//
//  MKRect.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/2/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKGravity.h"
#import "LKCGRectAdditions.h"

@interface LKGravity ()

@property (assign, nonatomic, readwrite) CGRect CGRect;
@property (assign, nonatomic, readwrite) CGRect parentRect;

@property (assign, nonatomic, readwrite) LKLayoutGravity gravity;

@end

@implementation LKGravity

- (instancetype)initWithCGRect:(CGRect)rect parent:(CGRect)parentRect
{
    self = [super init];
    if (self) {
        self.CGRect = rect;
        self.parentRect = parentRect;
    }
    return self;
}

- (void)moveByGravity:(LKLayoutGravity)gravity {
    
    if (LKLayoutGravityNone == gravity) {
        return;
    }
    self.gravity = gravity;
    [self moveHorizontalByGravity];
    [self moveVerticalByGravity];
    
}

- (void)moveHorizontalByGravity {
    if ([self shouldBeCenteredHorizontally]) {
        [self moveRectToHorizontalCenter];
    } else {
        [self moveToHorizontalEdgeByGravity];
    }
}

- (void)moveVerticalByGravity {
    if ([self shouldBeCenteredVertically]) {
        [self moveRectToVerticalCenter];
    } else {
        [self moveToVerticalEdgeByGravity];
    }
}

- (void)moveToHorizontalEdgeByGravity {
    if ([self shouldBeMovedToTheLeft]) {
        [self moveRectToLeftOfParent];
    } else if ([self shouldBeMovedToTheRight]) {
        [self moveRectToRightOfParent];
    }
}

- (void)moveToVerticalEdgeByGravity {
    if ([self shouldBeMovedToTheTop]) {
        [self moveRectToTopOfParent];
    } else if ([self shouldBeMovedToTheBottom]) {
        [self moveRectToBottomOfParent];
    }
}

- (BOOL)shouldBeCenteredHorizontally {
    return (self.gravity & LKLayoutGravityCenterHorizontal) == LKLayoutGravityCenterHorizontal;
}

- (void)moveRectToHorizontalCenter {
    self.CGRect = CGRectMoveHorizontallyToCenterWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeCenteredVertically {
    return (self.gravity & LKLayoutGravityCenterVertical) == LKLayoutGravityCenterVertical;
}

- (void)moveRectToVerticalCenter{
    self.CGRect = CGRectMoveVerticallyToCenterWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheLeft {
    return (self.gravity & LKLayoutGravityLeft) == LKLayoutGravityLeft;
}

- (void)moveRectToLeftOfParent{
    self.CGRect =  CGRectMoveToLeftWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheRight {
    return (self.gravity & LKLayoutGravityRight) == LKLayoutGravityRight;
}

- (void)moveRectToRightOfParent{
    self.CGRect = CGRectMoveToRightWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheTop {
    return (self.gravity & LKLayoutGravityTop) == LKLayoutGravityTop;
}

- (void)moveRectToTopOfParent{
    self.CGRect =  CGRectMoveToTopWithinRect(self.CGRect, self.parentRect);
}

- (BOOL)shouldBeMovedToTheBottom {
    return (self.gravity & LKLayoutGravityBottom) == LKLayoutGravityBottom;
}

- (void)moveRectToBottomOfParent{
    self.CGRect =  CGRectMoveToBottomWithinRect(self.CGRect, self.parentRect);
}

@end
