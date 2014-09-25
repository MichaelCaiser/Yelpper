//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "SearchViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "FilterViewController.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UITableView *SearchResultsTable;
@property (nonatomic, strong) YelpClient *client;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *searchResults;

- (void)makeNetworkCall:(NSString *)searchTerm;
- (void)showFilter;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self makeNetworkCall :@"greek"];
        
    }
    return self;
}
- (void)makeNetworkCall:(NSString *)searchTerm
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *filters = @{};
    NSString *category = [defaults stringForKey:@"category"];
    NSString *sort = [defaults stringForKey:@"sort"];
    NSString *distance = [defaults stringForKey:@"distance"];
    BOOL deals = [defaults boolForKey:@"deals"];
    if(category) {
        filters = @{ @"category_filter" : category,
                      @"sort" : sort,
                      @"radius_filter" : distance,
                               @"deals_filter" : @"YES"};
    }

    [self.client searchWithTerm:searchTerm success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"response: %@", response);
        self.searchResults = response[@"businesses"];
        [self.SearchResultsTable reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [self makeNetworkCall:@"Thai"];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    // add filter button
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(showFilter)];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    // add search bar to nav bar
    self.searchBar = [[UISearchBar alloc] init];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    
    
    self.SearchResultsTable.delegate = self;
    self.SearchResultsTable.dataSource = self;
//    self.SearchResultsTable.rowHeight = 125;
        [self.SearchResultsTable registerNib:[UINib nibWithNibName:@"SearchViewCell" bundle:nil] forCellReuseIdentifier:@"SearchViewCell"];
    [self makeNetworkCall:@"Thai"];
    
}
- (void)showFilter {
    self.navigationItem.backBarButtonItem.title = @"Cancel";
    [self.navigationController pushViewController:[[FilterViewController alloc] init] animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self makeNetworkCall :searchText];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.searchResults count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *results = self.searchResults;
    
    //UITableViewCell *cell = [[UITableViewCell alloc] init];
    //cell.textLabel.text = results[indexPath.row][@"name"];
    
    SearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchViewCell"];
    cell.nameLabel.text = results[indexPath.row][@"name"];
    cell.descriptionLabel.text = results[indexPath.row][@"location"][@"display_address"][0];
    cell.description4Label.text = results[indexPath.row][@"location"][@"city"];
    cell.description3Label.text = results[indexPath.row][@"location"][@"county_code"];

    NSString *posterUrl = results[indexPath.row][@"image_url"];
    [cell.posterView setImageWithURL:[NSURL URLWithString:posterUrl]];

    NSString *ratingsUrl = results[indexPath.row][@"rating_img_url"];
    [cell.ratingsView setImageWithURL:[NSURL URLWithString:ratingsUrl]];
    return cell;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
