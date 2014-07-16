//
//  DFXMLParser.h
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFXMLParser : NSObject {
    NSMutableArray *dictionaryStack;
    NSMutableString *textInProgress;
    NSError **errorPointer;
}

+ (NSDictionary *)dictionaryForXMLData:(NSData *)data error:(NSError **)errorPointer;
+ (NSDictionary *)dictionaryForXMLString:(NSString *)string error:(NSError **)errorPointer;

@end
