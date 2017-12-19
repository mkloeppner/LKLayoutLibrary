//
//  LKLayoutView.m
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayoutView.h"

@implementation LKLayoutView

- (instancetype)initWithLayoutNamed:(NSString *)layoutName
{
    [NSException raise:@"UnsupportedException" format:@"This class currently does not support initilization with layouts"];
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame layout:(id _Nonnull)layout
{
    self = [super initWithFrame:frame];
    if (self) {
        self.rootLayout = layout;
        [self.rootLayout setView:self];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}

- (CGSize)size
{
    return [self.rootLayout size];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [((LKLayout *)self.rootLayout) layout];
}

@end
