//
//  MKLayoutParserSpec.m
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 6/13/14.
//  Copyright 2014 Martin Klöppner. All rights reserved.
//

#import "Specta.h"
#import "LKLayout.h"
#import "LKLinearLayout.h"

#define EXP_SHORTHAND
#import "Expecta.h"

#define MOCKITO_SHORTHAND
#import "OCMockito.h"

#import "LKLayoutParser.h"

SpecBegin(LKLayoutParserSpec)

describe(@"LKLayoutParser", ^{
    
    __block LKLayoutParser *_parser;
    
    beforeEach(^{
        _parser = [[LKLayoutParser alloc] init];
    });
    
    it(@"should parse a linear layout", ^{
        __autoreleasing NSError *error;
        LKLayout *layout = [_parser parseLayoutFromString:@"<LinearLayout/>" error:&error];
        expect(layout.class).to.equal([
LKLinearLayout class]);
    });
    
});

SpecEnd
