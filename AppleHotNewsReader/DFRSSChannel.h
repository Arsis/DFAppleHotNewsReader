//
//  DFRSSChannel.h
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFBaseObject.h"
#import "DFRSSItem.h"
@interface DFRSSChannel : DFBaseObject
@property (nonatomic, copy) NSString *category;
@property (nonatomic, copy) NSString *copyright;
@property (nonatomic, copy) NSMutableArray *items;

-(id)initWithDictionary:(NSDictionary *)dictionary;
+(id)channelWithDictionary:(NSDictionary *)dictionary;

@end
