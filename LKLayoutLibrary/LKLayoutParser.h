//
//  LKLayoutParser.h
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKLayout.h"

extern NSString * _Nullable const kLKLayoutParserErrorDomain;

typedef enum {
    LKLayoutParserUnsupportedAttributeError
} LKLayoutParserError;

@interface LKLayoutParser : NSObject

+ (LKLayout *_Nullable)parseXMLFromFileAtURL:(NSURL * _Nonnull)fileURL error:(NSError * _Nullable __autoreleasing *_Nullable)error;
- (LKLayout *_Nullable)parseXMLFromFileAtURL:(NSURL * _Nonnull)fileURL error:(NSError * _Nullable __autoreleasing *_Nullable)error;
- (LKLayout *_Nullable)parseLayoutFromString:(NSString * _Nonnull)xmlLayout error:(NSError * _Nullable __autoreleasing *_Nullable)error;

@end
