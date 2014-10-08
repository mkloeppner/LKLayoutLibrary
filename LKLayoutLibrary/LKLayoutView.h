//
//  LKLayoutView.h
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LKLayout.h"

@interface LKLayoutView : UIView

@property (strong, nonatomic) LKLayout *rootLayout;

- (instancetype)initWithLayoutNamed:(NSString *)layoutName;
- (instancetype)initWithFrame:(CGRect)frame layout:(LKLayout *)layout;

@end
