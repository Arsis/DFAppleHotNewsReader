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
        _descriptionText = [dictionary objectForKey:kDescriptionKey];
    }
    return self;
}

+(id)objectWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc]initWithDictionary:dictionary] autorelease];
}

@end
