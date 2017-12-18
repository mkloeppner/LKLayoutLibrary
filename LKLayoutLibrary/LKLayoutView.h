//
//  LKLayoutView.h
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLayout.h"

@interface LKLayoutView<__covariant ObjectType> : UIView

@property (strong, nonatomic) ObjectType _Nullable rootLayout;

- (instancetype _Nonnull)initWithLayoutNamed:(NSString * _Nonnull)layoutName;
- (instancetype _Nonnull)initWithFrame:(CGRect)frame layout:(ObjectType _Nonnull)layout;

@end
