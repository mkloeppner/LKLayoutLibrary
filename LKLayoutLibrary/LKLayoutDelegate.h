//
//  LKLayoutDelegate.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 05/02/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LKLayout;

@protocol LKLayoutDelegate <NSObject>

@optional
- (void)layoutDidStartToLayout:(LKLayout *)layout;
- (void)layout:(LKLayout *)layout didAddLayoutItem:(LKLayoutItem *)item;
- (void)layout:(LKLayout *)layout didRemoveLayoutItem:(LKLayoutItem *)item;
- (void)layoutDidFinishToLayout:(LKLayout *)layout;

@end

