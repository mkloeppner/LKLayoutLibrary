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
- (void)layoutDidStartToLayout:(LKLayout * _Nonnull)layout;
- (void)layout:(LKLayout * _Nonnull)layout didAddLayoutItem:(LKLayoutItem * _Nonnull)item;
- (void)layout:(LKLayout * _Nonnull)layout didRemoveLayoutItem:(LKLayoutItem * _Nonnull)item;
- (void)layoutDidFinishToLayout:(LKLayout * _Nonnull)layout;

@end

