//
//  LKLayoutParser.m
//  LayoutParser
//
//  Created by Martin Klöppner on 12/06/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayoutParser.h"

NSString *const kMKLayoutParserErrorDomain = @"MKLayoutParserErrorDomain";

@interface LKLayoutParser () <NSXMLParserDelegate>

@property (strong, nonatomic) LKLayout *result;
@property (strong, nonatomic) id<NSObject> parentObject;
@property (strong, nonatomic) NSError *parserError;

@end

@implementation LKLayoutParser

+ (LKLayout *)parseXMLFromFileAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error
{
    return [[[LKLayoutParser alloc] init] parseXMLFromFileAtURL:fileURL error:error];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (LKLayout *)parseXMLFromFileAtURL:(NSURL *)fileURL error:(NSError *__autoreleasing *)error
{
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithContentsOfURL:fileURL];
    parser.delegate = self;
    [parser parse];
    return self.result;
}

- (LKLayout *)parseLayoutFromString:(NSString *)xmlLayout error:(NSError *__autoreleasing *)error
{
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[xmlLayout dataUsingEncoding:NSUTF8StringEncoding]];
    parser.delegate = self;
    [parser parse];
    return self.result;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    id<NSObject> element = [self createObjectForElementNamed:elementName];
    LKLayoutItem *item = nil;
    // Create root note which must equal to a ViewGroup
    if (self.result == nil) {
        NSAssert([element isKindOfClass:[LKLayout class]], @"First element must be an layout");
        self.result = element;
        self.parentObject = self.result;
    } else {
        // Step hirarchally through the layout and remember current hirarchy by persisting the parentObj
        item = [self addChildToCurrentParent:element];
    }
    [self configureElement:element containedWithinItem:item withAttributes:attributeDict];
}

- (LKLayoutItem *)addChildToCurrentParent:(id<NSObject>)child
{
    LKLayoutItem *item = nil;
    
    if ([self.parentObject isKindOfClass:[LKLayout class]]) {
        if ([child isKindOfClass:[UIView class]]) {
            item = [((LKLayout *)self.parentObject) addSubview:(UIView *)child];
        } else if ([child isKindOfClass:[LKLayout class]]) {
            item = [((LKLayout *)self.parentObject) addSublayout:(LKLayout *)child];
            // In order to traverse through the hirarchy
            self.parentObject = child;
        }
    } else if ([self.parentObject isKindOfClass:[UIView class]]) {
        if ([child isKindOfClass:[UIView class]]) {
            [((UIView *)self.parentObject) addSubview:(UIView *)child];
        } else if ([child isKindOfClass:[LKLayout class]]) {
            // TODO: Adding layouts to views is not possible right now
        }
    }
    
    return item;
}

- (void)configureElement:(id<NSObject>)element containedWithinItem:(LKLayoutItem *)item withAttributes:(NSDictionary *)attributes {
    for (NSString *key in attributes.keyEnumerator) {
        
        NSString *value = attributes[key];
        
        NSString *attributeName = key;
        NSRange itemPrefixRange = [key rangeOfString:@"item:"];
        id performObject = element;
        
        if (itemPrefixRange.location == 0) {
            NSAssert(item != nil, @"accessing item without previous layout");
            attributeName = [key stringByReplacingCharactersInRange:itemPrefixRange withString:@""];
            performObject = item;
        }
        
        SEL selector = [self getSelectorForAttributeName:attributeName];
        id parameter = [self anyObjectFromString:value forAttribute:attributeName];
        
        if (selector && parameter) {
            [self applyAttributeWithSelector:selector parameter:parameter onObject:performObject];
        }
    }
}

// TODO: Get the selector for an attribute, so basically map attribute to an selector
- (SEL)getSelectorForAttributeName:(NSString *)attributeName
{
    NSRange firstLetter = NSMakeRange(0,1);
    NSString *firstUppercaseCharacter = [[attributeName capitalizedString] substringWithRange:firstLetter];
    NSString *upperCaseAttributeName = [attributeName stringByReplacingCharactersInRange:firstLetter withString:firstUppercaseCharacter];
    NSString *selectorName = [NSString stringWithFormat:@"set%@:", upperCaseAttributeName];
    return NSSelectorFromString(selectorName);
}

// TODO: Return an object from an string by evaluating its value
- (id)anyObjectFromString:(NSString *)value forAttribute:(NSString *)attribute {
    
    if ([attribute isEqualToString:@"orientation"]) {
        if ([[value lowercaseString] isEqualToString:@"horizontal"]) {
            return @(LKLayoutOrientationHorizontal);
        } else if ([[value lowercaseString] isEqualToString:@"vertical"]) {
            return @(LKLayoutOrientationVertical);
        }
    }
    
    if ([value isEqualToString:@"green"]) {
        return [UIColor greenColor];
    }
    
    if ([value hasPrefix:@"CGSizeMake("] && [value hasSuffix:@")"]) {
        value = [value stringByReplacingOccurrencesOfString:@"CGSizeMake(" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *sizes = [value componentsSeparatedByString:@","];
        return [NSValue valueWithCGSize:CGSizeMake([sizes[0] floatValue], [sizes[1] floatValue])];
    }
    
    if ([value hasPrefix:@"UIEdgeInsetsMake("] && [value hasSuffix:@")"]) {
        value = [value stringByReplacingOccurrencesOfString:@"UIEdgeInsetsMake(" withString:@""];
        value = [value stringByReplacingOccurrencesOfString:@")" withString:@""];
        NSArray *sizes = [value componentsSeparatedByString:@","];
        return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsMake([sizes[0] floatValue], [sizes[1] floatValue], [sizes[2] floatValue], [sizes[3] floatValue])];
    }
    
    return nil;
}

// TODO: Invoke that by getting the attributes name
- (void)applyAttributeWithSelector:(SEL)selector parameter:(id)parameter onObject:(id)object {
    
    NSMethodSignature * signature = [[object class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = object;
    invocation.selector = selector;
    
    if ([parameter isKindOfClass:[NSNumber class]]) {
        NSInteger test = [parameter integerValue];
        [invocation setArgument:&test atIndex:2];
    } else if ([parameter isKindOfClass:[NSValue class]]) {
        NSString *encodedType = [NSString stringWithUTF8String:[parameter objCType]];
        if ([encodedType rangeOfString:@"CGSize"].location != NSNotFound) {
            CGSize size = [parameter CGSizeValue];
            [invocation setArgument:&size atIndex:2];
        } else if ([encodedType rangeOfString:@"UIEdgeInsets"].location != NSNotFound) {
            UIEdgeInsets insets = [parameter UIEdgeInsetsValue];
            [invocation setArgument:&insets atIndex:2];
        }
    } else if ([parameter isKindOfClass:[NSObject class]]) {
        [invocation setArgument:&parameter atIndex:2];
    }
    
    [invocation invoke];
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    id<NSObject> element = [self createObjectForElementNamed:elementName];
    // In order to close a ViewGroup definition and jump back to the previous one
    if ([element isKindOfClass:[LKLayout class]]) {
        NSAssert([self.parentObject class] == [element class], @"Expected to close the latest parent");
        LKLayout *parent = self.parentObject;
        self.parentObject = parent.item.layout;
        
    }
}

- (id<NSObject>)createObjectForElementNamed:(NSString *)elementName
{
    if ([elementName isEqualToString:@"StackLayout"]) {
        return [[LKStackLayout alloc] init];
    }
    if ([elementName isEqualToString:@"LinearLayout"]) {
        return [[LKLinearLayout alloc] init];
    }
    if ([elementName isEqualToString:@"FlowLayout"]) {
        return [[LKFlowLayout alloc] init];
    }
    
    return [[NSClassFromString(elementName) alloc] init];
}

@end
