//
//  DFConnector.h
//  AppleHotNewsReader
//
//  Created by Dmitry Fedorov on 17.07.14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFConnector;
@protocol DFConnectorDelegate <NSObject>
-(void)connector:(DFConnector *)connector didFinishLoadingWithObject:(id)object error:(NSError *)error;
@optional
-(void)connectorDidStartLoading:(DFConnector *)connector;
@end

@interface DFConnector : NSObject
@property (nonatomic, unsafe_unretained) id <DFConnectorDelegate> delegate;

+(id)sharedInstance;
-(void)loadDataFromURL:(NSURL *)url;
-(void)loadStringFromURL:(NSURL *)url;
@end
