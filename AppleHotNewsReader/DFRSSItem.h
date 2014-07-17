//
//  DFRSSItem.h
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFBaseObject.h"
@interface DFRSSItem : DFBaseObject
@property (nonatomic, copy) NSString *link;
@property (nonatomic, copy) NSString *publicationDateString;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *text;

-(void)updateWithDictionary:(NSDictionary *)dictionary;

@end
