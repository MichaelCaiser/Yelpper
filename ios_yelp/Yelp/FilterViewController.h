//
//  FilterViewController.h
//  Yelp
//
//  Created by Priyankaa Vijayakumar on 9/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *filterTableView;

@end
