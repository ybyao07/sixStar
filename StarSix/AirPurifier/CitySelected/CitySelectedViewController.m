//
//  CitySelectedViewController.m
//  AirPurifier
//
//  Created by bluE on 14-8-18.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "CitySelectedViewController.h"
#import "CityDataHelper.h"
#import "AirPurifierViewController.h"
#import "LocationController.h"
#import <MapKit/MapKit.h>
#import "AirPurifierAppDelegate.h"

#define kTextColorLabel [UIColor colorWithRed:111/255.0f green:113/255.0f blue:121/255.0f alpha:1]

@interface CitySelectedViewController ()
@end

@implementation CitySelectedViewController
@synthesize isFromDeviceBind;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    cityArray =  [CityDataHelper cityArray];
    filterCityArray = [[NSMutableArray alloc] initWithCapacity:10];
    [self customTableView:_tableView];
    [self customTableView:self.searchDisplayController.searchResultsTableView];
}

-(void)dealloc{
    [NotificationCenter removeObserver:self];
}
#pragma mark - Private Methods
- (void)customTableView:(UITableView *)tableView
{
    //set the line TableView separator
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    footerView.backgroundColor = [UIColor clearColor];
    tableView.tableFooterView = footerView;
    /*
     //set the offset cell separator
     BOOL isSystemVersionIsIos7 = [UIDevice isSystemVersionOnIos7];
     if (isSystemVersionIsIos7) {
     [tableView setSeparatorInset:UIEdgeInsetsZero];
     }
     */
}
#pragma mark - UITableView Data Source / Delegate Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return ((tableView == _tableView) ? cityArray.count : filterCityArray.count);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellID = @"CellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellID];
        cell.textLabel.font = [UIFont fontWithName:@"EuphemiaUCAS" size:17];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = kTextColorLabel;
    }
    NSArray *array = (tableView == _tableView) ? cityArray : filterCityArray;
    NSDictionary *city = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@市-%@", city[kCityName], city[kProvinceName]];//城市的名字，省的名字
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    NSArray *array = (tableView == _tableView) ? cityArray : filterCityArray;
    if (array.count <= indexPath.row) return;
    NSDictionary *city = array[indexPath.row];
    [CityDataHelper updateSelectedCity:city];
    NSLog(@"%@",[city objectForKey:kCityName]);
    if(isFromDeviceBind)//从绑定界面跳转过来
    {
        [NotificationCenter postNotificationName:CityChangedNotification object:city userInfo:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [NotificationCenter postNotificationName:CityFirstdNotification object:city userInfo:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


#pragma mark - UISearchDisplay Delegate Methods
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [filterCityArray removeAllObjects];
    for (NSDictionary *city in cityArray)
    {
        NSRange range = [city[kCityName] rangeOfString:searchString options:NSCaseInsensitiveSearch];
        if (range.location == NSNotFound)
        {
            range = [city[kCityNameEN] rangeOfString:searchString options:NSCaseInsensitiveSearch];
        }
        if (range.location != NSNotFound)
        {
            [filterCityArray addObject:city];
        }
    }
    return YES;
}
- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
