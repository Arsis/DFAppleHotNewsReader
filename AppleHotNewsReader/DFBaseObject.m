//
//  DFBaseObject.m
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import "DFBaseObject.h"

@implementation DFBaseObject

-(id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]) {
        _descriptionText = [[dictionary objectForKey:kDescriptionKey][kTextKey] retain];
    }
    return self;
}

+(id)objectWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc]initWithDictionary:dictionary] autorelease];
}

-(void)dealloc {
    [_descriptionText release];
    _descriptionText = nil;
    [super dealloc];
}

@end
