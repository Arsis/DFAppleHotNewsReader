//
//  DFViewController.m
//  AppleHotNewsReader
//
//  Created by DF on 7/15/14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import "DFViewController.h"
#import "DFXMLParser.h"
#import "DFRSSChannel.h"
static NSString *cellId = @"feed.cell.id";

@interface DFViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) UITableView *feedTableView;
@property (nonatomic, retain) DFRSSChannel *currentChannel;
@end

@implementation DFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.apple.com/main/rss/hotnews/hotnews.rss"]];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               NSError *parseError;
                               NSDictionary *info =[DFXMLParser dictionaryForXMLData:data
                                                                               error:&parseError];
                               NSLog(@"info = %@",info);
                               self.currentChannel = [[DFRSSChannel alloc] initWithDictionary:info];
                               [self.feedTableView reloadData];
                           }];
    
    if (!self.feedTableView) {
        UITableView *feedTableView = [[UITableView alloc]initWithFrame:CGRectZero
                                                                 style:UITableViewStylePlain];
        feedTableView.delegate = self;
        feedTableView.dataSource = self;
        [self.view addSubview:feedTableView];
        self.feedTableView = feedTableView;
        [feedTableView release];
    }
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.feedTableView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)parserDidStartDocument:(NSXMLParser *)parser {
    
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    
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
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle
                                     reuseIdentifier:cellId];
    }
    DFRSSItem *item = [self.currentChannel.items objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.publicationDateString;
    return cell;
}

-(void)dealloc {
    [super dealloc];
}

@end
