//
//  MKRect.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 7/2/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Gravity specifies how views should be positioned in ralation to their super views.
 *
 * For example a view with a size of 100x100 aligned in a view with 1000x1000 positioned with gravity top and gravity right will be positionated at position 900(1000-100)x100.
 */
typedef NS_OPTIONS(NSInteger, LKLayoutGravity) {
    LKLayoutGravityNone = 1 << 0, // Specifies, that the view doesn't stick to any edge
    LKLayoutGravityTop = 1 << 1, // Specifies that a view is aligned on top
    LKLayoutGravityBottom = 1 << 2, // Specifies that a view is aligned on bottom
    LKLayoutGravityLeft = 1 << 3, // Specifies that a view is aligned to the left
    LKLayoutGravityRight = 1 << 4, // Specifies that a view is aligned to the right
    LKLayoutGravityCenterVertical = 1 << 5, // Specifies that a views center is aligned to its superview center on the vertical axis
    LKLayoutGravityCenterHorizontal = 1 << 6 // Specifies that a views center is aligned to its superview center on the horizontal axis
};

/**
 * Gravity alignes an rectangle to its parent bounds regarding its gravity options.
 *
 * It allows to stick the rect to the horizontal or vertical edges or centers.
 */
@interface LKGravity : NSObject

@property (assign, nonatomic, readonly) CGRect CGRect;
@property (assign, nonatomic, readonly) CGRect parentRect;

- (instancetype _Nonnull)initWithCGRect:(CGRect)rect parent:(CGRect)parentRect;

/**
 * Moves an rect within an other rect and uses the gravity to align it within.
 *
 *      Note: If gravity is LKLayoutGravityNone the method exits immediately with return the rect param.
 */
- (void)moveByGravity:(LKLayoutGravity)gravity;

@end
