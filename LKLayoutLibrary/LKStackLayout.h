//
//  LKStackLayout.h
//  MKLayoutLibrary
//
//  Created by Martin Klöppner on 1/11/14.
//  Copyright (c) 2014 Martin Klöppner. All rights reserved.
//

#import "LKLayout.h"
#import "LKStackLayoutItem.h"

/**
 *  A stack layout creates for every single view its own layer which creates "overlays"
 */
@interface LKStackLayout : LKLayout

DECLARE_LAYOUT_ITEM_ACCESSORS_WITH_CLASS_NAME(LKStackLayoutItem)

@end
