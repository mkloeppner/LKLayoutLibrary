//
// Created by Martin Klöppner on 1/26/14.
// Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLinearLayoutSeparatorImpl.h"
#import "LKLinearLayout.h"

NSString *const kSeparatorsDictionaryKeyRect = @"kSeparatorsDictionaryKeyRect";
NSString *const kSeparatorsDictionaryKeyType = @"kSeparatorsDictionaryKeyType";

@interface LKLinearLayoutSeparatorImpl ()

@property (strong, nonatomic, readwrite) NSMutableArray *separators;

@end

@implementation LKLinearLayoutSeparatorImpl

- (instancetype)initWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets {
    self = [super init];
    if (self) {
        self.separatorThickness = separatorThickness;
        self.separatorIntersectionOffsets = separatorIntersectionOffsets;
        self.separators = [[NSMutableArray alloc] init];
    }

    return self;
}

+ (instancetype)separatorWithSeparatorThickness:(CGFloat)separatorThickness separatorIntersectionOffsets:(UIEdgeInsets)separatorIntersectionOffsets {
    return [[self alloc] initWithSeparatorThickness:separatorThickness separatorIntersectionOffsets:separatorIntersectionOffsets];
}

- (CGFloat)separatorThicknessForLinearLayout:(LKLinearLayout *)layout {
    return self.separatorThickness;
}

- (UIEdgeInsets)separatorIntersectionOffsetsForLinearLayout:(LKLinearLayout *)layout
{
    return self.separatorIntersectionOffsets;
}

- (void)linearLayout:(LKLinearLayout *)linearLayout separatorRect:(CGRect)rect type:(LKLayoutOrientation)type {
    NSValue *separatorRect = [NSValue valueWithCGRect:rect];
    NSNumber *separatorType = @(type);

    [self.separators addObject:@{
            kSeparatorsDictionaryKeyRect : separatorRect,
            kSeparatorsDictionaryKeyType : separatorType
    }];
}

@end