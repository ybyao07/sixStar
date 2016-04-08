//
//  CitySelectedViewController.h
//  AirPurifier
//
//  Created by bluE on 14-8-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CitySelectedViewController : UIViewController <UISearchDisplayDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSArray *cityArray;
    NSMutableArray *filterCityArray;
}
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BOOL isFromDeviceBind;
- (IBAction)onBack:(id)sender;
//- (IBAction)onLocationSucceed:(id)sender;
//
//@property (weak, nonatomic) IBOutlet UIButton *btnAutoLocation;


//-(void)filterContentForSearchText:(NSString *)searchText;

@end
