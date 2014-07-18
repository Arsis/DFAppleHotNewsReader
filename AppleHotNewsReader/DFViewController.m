//
//  DFViewController.m
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import "DFViewController.h"
#import "DFRSSChannel.h"
#import "DFConnector.h"
#import "DFRSSItemDetailViewController.h"
static NSString *const cellId = @"feed.cell.id";
static NSString *const kHotNewsURL = @"https://www.apple.com/main/rss/hotnews/hotnews.rss";
static CGFloat const kCellVerticalSpace = 20.0f;
static CGFloat const kCellHorizontalSpace = 45.0f;

@interface DFViewController () <UITableViewDataSource, UITableViewDelegate, DFConnectorDelegate>
@property (nonatomic, assign) UITableView *feedTableView;
@property (nonatomic, retain) DFRSSChannel *currentChannel;
@property (nonatomic, retain) DFConnector *connector;
@end

@implementation DFViewController

@synthesize feedTableView = _feedTableView;
@synthesize currentChannel = _currentChannel;
@synthesize connector = _connector;

-(void)dealloc {
    [self.feedTableView removeFromSuperview];
    [_currentChannel release];
    _currentChannel = nil;
    [_connector release];
    _connector = nil;
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Apple hot news";
    self.navigationController.navigationBar.translucent = NO;
    self.connector = [DFConnector sharedInstance];
    if (!self.feedTableView) {
        UITableView *feedTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                                 style:UITableViewStylePlain];
        feedTableView.delegate = self;
        feedTableView.dataSource = self;
        feedTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:feedTableView];
        self.feedTableView = feedTableView;
        [feedTableView release];
    }
    [self loadData];
}

-(void)loadData {
    NSURL *url = [NSURL URLWithString:kHotNewsURL];
    [self.connector loadDataFromURL:url];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.connector.delegate = self;
    self.feedTableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ConnectorDelegate

-(void)connectorDidStartLoading:(DFConnector *)connector {
    self.navigationItem.rightBarButtonItem = [self activityIndicatorBarButtonItem];
}

-(void)connector:(DFConnector *)connector didFinishLoadingWithObject:(id)object error:(NSError *)error {
    self.navigationItem.rightBarButtonItem = [self refreshBarButtonItem];
    if (object) {
        if (_currentChannel) {
            [_currentChannel updateWithDictionary:object];
        }
        else {
            DFRSSChannel *channel = [[DFRSSChannel alloc]initWithDictionary:object];
            self.currentChannel = channel;
            [channel release];
        }
        [self.feedTableView reloadData];
    }
    else if (error) {
        
    }
}

#pragma mark - UITableViewDataSource 

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.currentChannel.items.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellId] autorelease];
    }
    DFRSSItem *item = [self.currentChannel.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.numberOfLines = 0.0f;
    cell.detailTextLabel.text = item.descriptionText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    DFRSSItem *item = [self.currentChannel.items objectAtIndex:indexPath.row];
    CGSize suggestedTextLabelSize;
    CGSize suggestedDetailTextLabelSize;
    if (NSFoundationVersionNumber > floor(NSFoundationVersionNumber_iOS_6_1)) {
        suggestedTextLabelSize = [item.title boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.bounds) - kCellHorizontalSpace, FLT_MAX)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]}
                                          context:nil].size;
        suggestedDetailTextLabelSize = [item.descriptionText boundingRectWithSize:CGSizeMake(CGRectGetWidth(tableView.bounds) - kCellHorizontalSpace, FLT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                             attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]}
                                                                context:nil].size;;
    }
    else {
        suggestedTextLabelSize = [item.title sizeWithFont:[UIFont boldSystemFontOfSize:18.0f]
                                        constrainedToSize:CGSizeMake(CGRectGetWidth(tableView.bounds) - kCellHorizontalSpace, FLT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping];
        suggestedDetailTextLabelSize = [item.descriptionText sizeWithFont:[UIFont systemFontOfSize:14.0f]
                                                        constrainedToSize:CGSizeMake(CGRectGetWidth(tableView.bounds) - kCellHorizontalSpace, FLT_MAX)
                                                            lineBreakMode:NSLineBreakByWordWrapping];
    }
    return MAX(self.feedTableView.rowHeight, suggestedTextLabelSize.height + suggestedDetailTextLabelSize.height + kCellVerticalSpace);
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DFRSSItemDetailViewController *detailViewController = [[DFRSSItemDetailViewController alloc]init];
    detailViewController.currentRSSItem = [self.currentChannel.items objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
    [detailViewController release];
}

#pragma mark - UIBarButtonItemHelpers

-(UIBarButtonItem *)activityIndicatorBarButtonItem {
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityIndicator startAnimating];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]initWithCustomView:activityIndicator];
    [activityIndicator release];
    return [barButtonItem autorelease];
}

-(UIBarButtonItem *)refreshBarButtonItem {
    UIBarButtonItem *refreshBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                         target:self
                                                                                         action:@selector(loadData)];
    return [refreshBarButtonItem autorelease];
}

@end
