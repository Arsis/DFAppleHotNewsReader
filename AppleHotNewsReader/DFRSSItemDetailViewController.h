//
//  DFRSSItemDetailViewController.h
//  AppleHotNewsReader
//
//  Created by Dmitry Fedorov on 17.07.14.
//  Copyright (c) 2014 df. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DFRSSItem;
@interface DFRSSItemDetailViewController : UIViewController
@property (nonatomic, retain) DFRSSItem *currentRSSItem;
@end
