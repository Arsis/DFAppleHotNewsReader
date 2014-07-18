//
//  DFConnector.m
//  AppleHotNewsReader
//
//  Created by Dmitry Fedorov on 17.07.14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import "DFConnector.h"
#import "DFXMLParser.h"
@interface DFConnector () <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (nonatomic, retain) NSURLConnection *currentConnection;
@property (nonatomic, retain) NSMutableData *dataBuffer;
@property (nonatomic, assign, getter = isLoadingHTML) BOOL loadingHTML;
@end

@implementation DFConnector

+(id)sharedInstance {
    static dispatch_once_t onceToken;
    static DFConnector *_connector = nil;
    dispatch_once(&onceToken, ^{
        _connector = [[DFConnector allocHidden] init];
    });
    return _connector;
}

+(id)alloc {
    NSAssert(NO, @"You are not allowed to use ""alloc"", user ""sharedInstance instead""");
    return nil;
}

+(id)allocHidden {
    return [super alloc];
}


-(void)dealloc {
    _delegate = nil;
    [_currentConnection release];
    _currentConnection = nil;
    [_dataBuffer release];
    _dataBuffer = nil;
    [super dealloc];
}

-(void)loadDataFromURL:(NSURL *)url {
    self.loadingHTML = NO;
    [self loadURL:url];
}

-(void)loadStringFromURL:(NSURL *)url {
    self.loadingHTML = YES;
    [self loadURL:url];
}

-(void)loadURL:(NSURL *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request
                                                                delegate:self];
    [connection start];
    if (self.delegate && [self.delegate respondsToSelector:@selector(connectorDidStartLoading:)]) {
        [self.delegate connectorDidStartLoading:self];
    }
    self.currentConnection = connection;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"reaponse received");
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!self.dataBuffer) {
        NSMutableData *buffer = [[NSMutableData alloc] initWithData:data];
        self.dataBuffer = buffer;
        [buffer release];
    }
    else {
        [self.dataBuffer appendData:data];
    }
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *parseError = nil;
    id responseObject;
    if (!self.isLoadingHTML) {
        responseObject = [DFXMLParser dictionaryForXMLData:self.dataBuffer
                                                     error:&parseError];
        [self.delegate connector:self
      didFinishLoadingWithObject:responseObject
                           error:parseError];
    }
    else {
        responseObject = [[NSString alloc]initWithData:self.dataBuffer
                                              encoding:NSUTF8StringEncoding];
        [self.delegate connector:self
      didFinishLoadingWithObject:responseObject
                           error:parseError];
        [responseObject release];
    }
    
    [_dataBuffer release];
    _dataBuffer = nil;
    self.currentConnection = nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error    {
    if (_dataBuffer) {
        [_dataBuffer release];
        _dataBuffer = nil;
    }
    [self.delegate connector:self
  didFinishLoadingWithObject:nil
                       error:error];
}

@end
