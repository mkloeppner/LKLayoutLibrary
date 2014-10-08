//
//  LKLayoutView.m
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayoutView.h"
#import "LKLayoutParser.h"

@implementation LKLayoutView

- (instancetype)initWithLayoutNamed:(NSString *)layoutName
{
    [NSException raise:@"UnsupportedException" format:@"This class currently does not support initilization with layouts"];
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame layout:(LKLayout *)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootLayout = layout;
        self.rootLayout.view = self;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.rootLayout layout];
}

@end
