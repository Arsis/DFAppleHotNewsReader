//
//  DFRSSItem.m
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import "DFRSSItem.h"

@implementation DFRSSItem

-(id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        _link = [[[dictionary objectForKey:kLinkKey][kTextKey] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]]  retain];
        _publicationDateString = [[[dictionary objectForKey:kPublicationDateKey][kTextKey] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
        _title = [[[dictionary objectForKey:kTitleKey][kTextKey] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]] retain];
    }
    return self;
}

-(void)dealloc {
    [_link release];
    [_publicationDateString release];
    [_title release];
    [_text release];
    _link = nil;
    _publicationDateString = nil;
    _title = nil;
    _text = nil;
    [super dealloc];
}

@end
