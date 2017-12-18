//
//  LKLayoutParser.h
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKLayout.h"

extern NSString *const kLKLayoutParserErrorDomain;

typedef enum {
    LKLayoutParserUnsupportedAttributeError
} LKLayoutParserError;

@interface LKLayoutParser : NSObject

+ (LKLayout *)parseXMLFromFileAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error;
- (LKLayout *)parseXMLFromFileAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error;
- (LKLayout *)parseLayoutFromString:(NSString *)xmlLayout error:(NSError *__autoreleasing *)error;

@end
