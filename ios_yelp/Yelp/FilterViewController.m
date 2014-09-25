//
//  FilterViewController.m
//  Yelp
//
//  Created by Priyankaa Vijayakumar on 9/25/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "MainViewController.h"

@interface FilterViewController ()
@property (nonatomic) BOOL isCategoriesExpanded;
@property (nonatomic) BOOL isSortExpanded;
@property (nonatomic) BOOL isDistanceExpanded;

@property (strong, nonatomic) NSArray *categories;
@property (strong, nonatomic) NSArray *sortTypes;
@property (strong, nonatomic) NSArray *distances;

@property (nonatomic) NSInteger selectedCategory;
@property (nonatomic) NSInteger selectedDistance;
@property (nonatomic) NSInteger selectedSortType;
@property (nonatomic) BOOL isDealsEnabled;
@property (strong, nonatomic) NSDictionary *filters;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isCategoriesExpanded = false;
    self.isSortExpanded = false;
    self.isDistanceExpanded = false;
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    self.categories = @[
                        @{ @"name" : @"American (New)",
                           @"id" : @"newamerican"},
                        @{ @"name" : @"Barbeque",
                           @"id" : @"bbq"},
                        @{ @"name" : @"Cafes",
                           @"id" : @"cafes"},
                        @{ @"name" : @"Diners",
                           @"id" : @"diners"},
                        @{ @"name" : @"Ethiopian",
                           @"id" : @"ethiopian"},
                        @{ @"name" : @"Filipino",
                           @"id" : @"filipino"},
                        @{ @"name" : @"Greek",
                           @"id" : @"greek"},
                        @{ @"name" : @"Hawaiian",
                           @"id" : @"hawaiian"},
                        @{ @"name" : @"Italian",
                           @"id" : @"italian"},
                        @{ @"name" : @"Japanase",
                           @"id" : @"japanese"},
                        @{ @"name" : @"Korean",
                           @"id" : @"korean"},
                        @{ @"name" : @"Latin American",
                           @"id" : @"latin"},
                        @{ @"name" : @"Mexican",
                           @"id" : @"mexican"},
                        @{ @"name" : @"Night Food",
                           @"id" : @"nightfood"},
                        @{ @"name" : @"Open Sandwiches",
                           @"id" : @"opensandwiches"},
                        @{ @"name" : @"Pizza",
                           @"id" : @"pizza"},
                        @{ @"name" : @"Rice",
                           @"id" : @"riceshop"},
                        @{ @"name" : @"Seafood",
                           @"id" : @"seafood"},
                        @{ @"name" : @"Thai",
                           @"id" : @"thai"},
                        @{ @"name" : @"Ukrainian",
                           @"id" : @"ukrainian"},
                        @{ @"name" : @"Vietnamese",
                           @"id" : @"vietnamese"},
                        @{ @"name" : @"Wraps",
                           @"id" : @"wraps"},
                        @{ @"name" : @"Yugoslav",
                           @"id" : @"yugoslav"}
                        ];
    self.isCategoriesExpanded = NO;
    
    // sort
    self.isSortExpanded = NO;
    self.sortTypes = @[
                       @"Best Match",
                       @"Distance",
                       @"Highest Rated"
                       ];
    self.selectedSortType = 0;
    
    // distance
    self.isDistanceExpanded = NO;
    self.distances = @[
                       @{ @"name" : @"400 meters",
                          @"meters" : @"400"},
                       @{ @"name" : @"1600 meters",
                          @"meters" : @"1600"},
                       @{ @"name" : @"8000 meters",
                          @"meters" : @"8000"},
                       @{ @"name" : @"40000 meters",
                          @"meters" : @"40000"}
                       ];
    self.selectedDistance = 2;
    
    //results
    self.selectedCategory = 0;
    self.selectedDistance = 0;
    self.selectedSortType = 0;
    self.isDealsEnabled = NO;
    
    self.filterTableView.rowHeight= 60;
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStylePlain target:self action:@selector(refreshSearch:)];
    self.navigationItem.rightBarButtonItem = anotherButton;

}
- (void)refreshSearch:(UIBarButtonItem *)btn {
    self.filters = @{ @"category_filter" : self.categories[self.selectedCategory][@"id"],
                    @"sort" : self.sortTypes[self.selectedSortType],
                      @"radius_filter" : self.distances[self.selectedDistance][@"meters"],
                      @"deals_filter" : @(self.isDealsEnabled)};
    

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *category = self.categories[self.selectedCategory][@"id"];
    [defaults setObject:category forKey:@"category"];

    NSString *sort = self.sortTypes[self.selectedSortType];
    [defaults setObject:sort forKey:@"sort"];

    NSString *distance = self.distances[self.selectedDistance][@"meters"];
    [defaults setObject:distance forKey:@"distance"];
    
    BOOL deals = @(self.isDealsEnabled);
    [defaults setBool:deals forKey:@"deals"];
    
    
    [defaults synchronize];

    MainViewController *detailsViewController = [[MainViewController alloc]init];
    [self.navigationController pushViewController:detailsViewController animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // one section each for category, sort, radius, and deals
    return 4;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    
    
    if (section == 0) { // categories
        if(self.isCategoriesExpanded) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = self.categories[indexPath.row][@"name"];
            BOOL isOn = NO;
            if(self.selectedCategory == row) {
                isOn = YES;
            }
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
            [switchView setOn:isOn animated:NO];
            [switchView addTarget:self action:@selector(toggleCategorySwitch:) forControlEvents:UIControlEventValueChanged];
            [switchView setTag:row];
            cell.accessoryView = switchView;
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = self.categories[self.selectedCategory][@"name"];
            BOOL isOn = YES;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
            [switchView setOn:isOn animated:NO];
            [switchView addTarget:self action:@selector(toggleCategorySwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            return cell;
        }
        
        
    } else if (section == 1) {  // sort
        if(self.isSortExpanded) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = self.sortTypes[indexPath.row];
            BOOL isOn = NO;
            if(self.selectedSortType == row) {
                isOn = YES;
            }
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
            [switchView setOn:isOn animated:NO];
            [switchView addTarget:self action:@selector(toggleSortSwitch:) forControlEvents:UIControlEventValueChanged];
            [switchView setTag:row];
            cell.accessoryView = switchView;
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = self.sortTypes[self.selectedSortType];
            BOOL isOn = YES;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
            [switchView setOn:isOn animated:NO];
            [switchView addTarget:self action:@selector(toggleSortSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            return cell;
        }
    } else if (section == 2) {  // distance
        if(self.isDistanceExpanded) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = self.distances[indexPath.row][@"name"];
            BOOL isOn = NO;
            if(self.selectedDistance == row) {
                isOn = YES;
            }
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
            [switchView setOn:isOn animated:NO];
            [switchView addTarget:self action:@selector(toggleDistanceSwitch:) forControlEvents:UIControlEventValueChanged];
            [switchView setTag:row];
            cell.accessoryView = switchView;
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = self.distances[self.selectedDistance][@"name"];
            BOOL isOn = YES;
            UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
            [switchView setOn:isOn animated:NO];
            [switchView addTarget:self action:@selector(toggleDistanceSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchView;
            return cell;
        }
    } else if (section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.textLabel.text = [NSString stringWithFormat:@"Deals"];
        BOOL isOn = NO;
        if(self.isDealsEnabled) {
            isOn = YES;
        }
        UISwitch *switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200.0f, 5.0f, 75.0f, 30.0f)];
        [switchView setOn:isOn animated:NO];
        [switchView addTarget:self action:@selector(toggleDealsSwitch:) forControlEvents:UIControlEventValueChanged];
        [switchView setTag:row];
        cell.accessoryView = switchView;
        return cell;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    headerView.backgroundColor = [UIColor colorWithWhite:.9 alpha:.9];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, 320, 50)];
    CGRect frame = tableView.frame;
    UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 30)];
    [addButton setTitle:@"Show" forState:UIControlStateNormal];
    switch (section) {
        case 0:
            headerLabel.text = @"Category";
            [addButton setTag:0];
            if(self.isCategoriesExpanded) {
                [addButton setTitle:@"Hide" forState:UIControlStateNormal];
            }
            break;
        case 1:
                        [addButton setTag:1];
            if(self.isSortExpanded) {
                [addButton setTitle:@"Hide" forState:UIControlStateNormal];
            }
            headerLabel.text = @"Sort";
            break;
        case 2:
                        [addButton setTag:2];
            if(self.isDistanceExpanded) {
                [addButton setTitle:@"Hide" forState:UIControlStateNormal];
            }
            headerLabel.text = @"Distance";
            break;
        case 3:
                        [addButton setTag:3];
            headerLabel.text = @"Deals";
            break;
    }
    
    [addButton addTarget:self action:@selector(sectionTapped:) forControlEvents:UIControlEventTouchDown];
    headerLabel.font = [UIFont systemFontOfSize:16];
    headerLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    [headerView addSubview:addButton];
    [headerView addSubview:headerLabel];
    
    return headerView;
}
- (void)toggleCategorySwitch:(UISwitch*)switchView {
    self.selectedCategory = switchView.tag;

        self.filterTableView.reloadData;
}
- (void)toggleSortSwitch:(UISwitch*)switchView {
    self.selectedSortType = switchView.tag;
    
    self.filterTableView.reloadData;
}
- (void)toggleDistanceSwitch:(UISwitch*)switchView {
    self.selectedDistance = switchView.tag;
    
    self.filterTableView.reloadData;
}
- (void)toggleDealsSwitch:(UISwitch*)switchView {
    self.isDealsEnabled = !self.isDealsEnabled;
    
    self.filterTableView.reloadData;
}
- (void)sectionTapped:(UIButton*)btn {
    switch(btn.tag) {
        case 0:
            self.isCategoriesExpanded = !self.isCategoriesExpanded;
            break;
        case 1:
            self.isSortExpanded = !self.isSortExpanded;
            break;
        case 2:
            self.isDistanceExpanded = !self.isDistanceExpanded;
            break;
            
    }
    self.filterTableView.reloadData;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    if (section == 0) {
        // See All Categories
        
        self.isCategoriesExpanded = !self.isCategoriesExpanded;
        
            //self.isCategoryEnabled[@(row)] = @(!self.isCategoryEnabled[@(row)]);
        
    } else if (section == 1) {
        self.isSortExpanded = !self.isSortExpanded;
        if (!self.isSortExpanded) {
            //self.selectedSortType = row;
        }
    } else if (section == 2) {
        self.isDistanceExpanded = !self.isDistanceExpanded;
        if (!self.isDistanceExpanded) {
            //self.selectedDistance = row;
        }
    } else if (section == 3) {
        //self.isDealsEnabled = !self.isDealsEnabled;
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationAutomatic];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
            // category
        case 0:
            if (self.isCategoriesExpanded) {
                return 10;
            } else {
                return 1;
            }
            // sort
        case 1:
            if (self.isSortExpanded) {
                return 3;
            } else {
                return 1;
            }
            // distance
        case 2:
            if (self.isDistanceExpanded) {
                return 3;
            } else {
                return 1;
            }
            // deals
        case 3:
            return 1;
        default:    // should never get here
            return 5;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
