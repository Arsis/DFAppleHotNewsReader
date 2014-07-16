//
//  DFBaseObject.h
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFBaseObject : NSObject
@property (nonatomic, copy) NSString *descriptionText;
-(id)initWithDictionary:(NSDictionary *)dictionary;
+(id)objectWithDictionary:(NSDictionary *)dictionary;
@end
