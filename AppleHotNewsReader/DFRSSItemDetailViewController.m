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
@interface DFRSSItemDetailViewController () <DFConnectorDelegate, UIWebViewDelegate>
@property (nonatomic, assign) DFConnector *connector;
@property (nonatomic, assign) UIWebView *webView;
@property (nonatomic, assign) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) UIButton *retryButton;
@property (nonatomic, assign) UILabel *errorMessageLabel;
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.connector = [DFConnector sharedInstance];
    self.navigationItem.title = self.currentRSSItem.title;
    UIWebView *webView = [[UIWebView alloc]init];
    webView.delegate = self;
    webView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:webView];
    self.webView = webView;
    [webView release];
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    [self.view insertSubview:activityIndicator
                belowSubview:webView];
    self.activityIndicatorView = activityIndicator;
    [activityIndicator release];
    
    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    retryButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    [retryButton setTitle:@"Retry"
                 forState:UIControlStateNormal];
    [retryButton addTarget:self
                    action:@selector(loadData)
          forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:retryButton
                belowSubview:webView];
    
    self.retryButton = retryButton;
    
    UILabel *errorMessageLabel = [[UILabel alloc] init];
    errorMessageLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    errorMessageLabel.textAlignment = NSTextAlignmentCenter;
    errorMessageLabel.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:errorMessageLabel
                belowSubview:webView];
    
    self.errorMessageLabel = errorMessageLabel;
    [errorMessageLabel release];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.connector.delegate = self;
    self.webView.frame = self.view.bounds;
    self.activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    self.retryButton.center = self.activityIndicatorView.center;
    self.errorMessageLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), 80.0f);
    [self loadData];
}

-(void)viewDidUnload {
    [super viewDidUnload];
    [self.webView removeFromSuperview];
    [self.activityIndicatorView removeFromSuperview];
    self.connector = nil;
    self.activityIndicatorView = nil;
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
    if (object) {
        self.currentRSSItem.text = object;
        [self.webView loadHTMLString:object
                             baseURL:[NSURL URLWithString:self.currentRSSItem.link]];
    }
    else if (error) {
        [self failWithError:error];
    }
}

#pragma mark - UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    webView.hidden = YES;
    self.retryButton.hidden = YES;
    self.errorMessageLabel.hidden = YES;
    [self.activityIndicatorView startAnimating];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicatorView stopAnimating];
    [webView setHidden:NO];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self failWithError:error];
}

#pragma mark - Target/Action

-(void)loadData {
    if (!self.currentRSSItem.text) {
        [self.connector loadStringFromURL:[NSURL URLWithString:self.currentRSSItem.link]];
    }
    else {
        [self.webView loadHTMLString:self.currentRSSItem.text
                             baseURL:[NSURL URLWithString:self.currentRSSItem.link]];
    }
}


-(void)failWithError:(NSError *)error {
    self.webView.hidden = YES;
    self.retryButton.hidden = NO;
    self.errorMessageLabel.text = [error localizedDescription];
    [self.errorMessageLabel sizeToFit];
    self.errorMessageLabel.center = CGPointMake(CGRectGetMidX(self.view.bounds), 80.0f);
    self.errorMessageLabel.hidden = NO;
}

@end
