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
        NSDictionary *channelInfo = [[dictionary objectForKey:kRSSKey] objectForKey:kChannelKey];
        _category = [channelInfo objectForKey:kCategoryKey][kTextKey];
        _copyright = [channelInfo objectForKey:kCopyrightKey][kTextKey];
        NSArray *itemsInfo = [channelInfo objectForKey:kItemsKey];
        _items = [[NSMutableArray alloc] initWithCapacity:itemsInfo.count];
        for (NSDictionary *itemInfo in itemsInfo) {
            DFRSSItem *item = [DFRSSItem objectWithDictionary:itemInfo];
            [_items addObject:item];
        }
    }
    return self;
}
+(id)channelWithDictionary:(NSDictionary *)dictionary {
    return [[[self alloc]initWithDictionary:dictionary] autorelease];
}

-(void)dealloc {
    [super dealloc];
    [_category release];
    [_copyright release];
    [_descriptionText release];
    [_items removeAllObjects];
    [_items release];
    self.category = nil;
    self.copyright = nil;
    self.descriptionText = nil;
    self.items = nil;
}

@end
