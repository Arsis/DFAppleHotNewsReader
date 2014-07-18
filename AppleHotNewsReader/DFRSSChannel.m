//
//  DFRSSChannel.m
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import "DFRSSChannel.h"

@implementation DFRSSChannel
@synthesize category = _category;
@synthesize copyright = _copyright;
@synthesize descriptionText = _descriptionText;
@synthesize items = _items;

-(id)initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super initWithDictionary:dictionary]) {
        [self updateWithDictionary:dictionary];
    }
    return self;
}

-(void)updateWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *channelInfo = [[dictionary objectForKey:kRSSKey] objectForKey:kChannelKey];
    self.category = [channelInfo objectForKey:kCategoryKey][kTextKey];
    self.copyright = [channelInfo objectForKey:kCopyrightKey][kTextKey];
    NSArray *itemsInfo = [channelInfo objectForKey:kItemsKey];
    if (!self.items) {
       _items =[[NSMutableArray arrayWithCapacity:itemsInfo.count] retain];
    }
    else {
        [_items removeAllObjects];
    }
    for (NSDictionary *itemInfo in itemsInfo) {
        DFRSSItem *item = [[DFRSSItem alloc]initWithDictionary:itemInfo];
        [_items addObject:item];
        [item release];
    }
}

+(id)channelWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc]initWithDictionary:dictionary] autorelease];
}

-(void)dealloc {
    [_category release];
    [_copyright release];
    [_items release];
    _category = nil;
    _copyright = nil;
    _items = nil;
    [super dealloc];
}

@end
