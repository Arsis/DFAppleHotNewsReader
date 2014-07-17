//
//  DFRSSItemDetailViewController.m
//  AppleHotNewsReader
//
//  Created by Dmitry Fedorov on 17.07.14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import "DFRSSItemDetailViewController.h"
#import "DFRSSItem.h"
#import "DFConnector.h"
@interface DFRSSItemDetailViewController () <DFConnectorDelegate>
@property (nonatomic, assign) DFConnector *connector;
@property (nonatomic, assign) UIWebView *webView;
@end

@implementation DFRSSItemDetailViewController

@synthesize currentRSSItem = _currentRSSItem;
@synthesize webView = _webView;

#pragma mark - Init/Dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc {
    [super dealloc];
    [_currentRSSItem release];
    _currentRSSItem = nil;
}

#pragma mark - ViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.connector = [DFConnector sharedInstance];
    self.navigationItem.title = self.currentRSSItem.title;
    UIWebView *webView = [[UIWebView alloc]init];
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView release];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.connector.delegate = self;
    self.webView.frame = self.view.bounds;
    if (!self.currentRSSItem.text) {
        [self.connector loadStringFromURL:[NSURL URLWithString:self.currentRSSItem.link]];
    }
    else {
        [self.webView loadHTMLString:self.currentRSSItem.text
                             baseURL:[NSURL URLWithString:self.currentRSSItem.link]];
    }
}

-(void)viewDidUnload {
    [super viewDidUnload];
    [self.webView removeFromSuperview];
    self.webView = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - DFConnectorDelegate

-(void)connector:(DFConnector *)connector didFinishLoadingWithObject:(id)object error:(NSError *)error {
    NSLog(@"object = %@",object);
    self.currentRSSItem.text = object;
    [self.webView loadHTMLString:object
                         baseURL:[NSURL URLWithString:self.currentRSSItem.link]];
}

@end
