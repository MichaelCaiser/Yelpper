//
//  SearchViewCell.h
//  Yelp
//
//  Created by Priyankaa Vijayakumar on 9/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingsView;
@property (weak, nonatomic) IBOutlet UILabel *description2Label;
@property (weak, nonatomic) IBOutlet UILabel *description3Label;
@property (weak, nonatomic) IBOutlet UILabel *description4Label;

@end
