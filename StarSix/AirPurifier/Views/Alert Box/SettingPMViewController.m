//
//  SettingPMViewController.m
//  AirPurifier
//
//  Created by bluE on 14-10-28.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import "SettingPMViewController.h"

@interface SettingPMViewController ()<UITableViewDataSource,UITableViewDelegate>
{
     NSMutableArray *dataArray1;
    NSString *alertValue;
    NSInteger currentRow;
}
@property (nonatomic) NSInteger intFirtSelectedRow;
@end

@implementation SettingPMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dataArray1 = [[NSMutableArray alloc] initWithObjects:@"30", @"40", @"50", @"60", @"70", @"80",@"100",@"150",@"200",@"250",nil];
//    [_tableView setSeparatorInset:UIEdgeInsetsMake(1, -4, 1, 1)];
    [dataArray1 enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (self.curPmValue == [obj intValue]) {
            _intFirtSelectedRow = idx;
        }
    }];
    
    NSIndexPath *first = [NSIndexPath
                          indexPathForRow:_intFirtSelectedRow inSection:0];
    currentRow = _intFirtSelectedRow;
    _tableView.scrollEnabled = YES;
    [_tableView selectRowAtIndexPath:first
                           animated:YES
                     scrollPosition:UITableViewScrollPositionTop];
    alertValue = [dataArray1 objectAtIndex:currentRow];
}

- (IBAction)onSure:(id)sender {
    [self dismiss:^
     {
         if (self.delegate && [self.delegate respondsToSelector:@selector(changePMAlertValue:)])
         {
             if (!alertValue) {
                 alertValue = [dataArray1 objectAtIndex:2];
             }
             [self.delegate changePMAlertValue:alertValue];
         }
     }
     ];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
   if(cell == nil)
   {
          cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
   }
    
    if (indexPath.row == currentRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.selectedBackgroundView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big_btn_press"]];
    [[cell textLabel]  setText:[dataArray1 objectAtIndex:indexPath.row]];
    return  cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return   [dataArray1 count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    alertValue = [dataArray1 objectAtIndex:indexPath.row];
    UITableViewCell *oldCell = [self.tableView
                                cellForRowAtIndexPath:[NSIndexPath indexPathForRow:currentRow inSection:0]];
    oldCell.accessoryType = UITableViewCellAccessoryNone;
    oldCell.selectedBackgroundView = nil;
    UITableViewCell *newCell = [self.tableView
                                cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    newCell.accessoryType = UITableViewCellAccessoryCheckmark;
    currentRow = indexPath.row;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,4, 280, 40)];
    contentView.backgroundColor = [UIColor blackColor];
    CGRect frameRect = CGRectMake(16, 0, 280, 40);
    UILabel *label = [[UILabel alloc] initWithFrame:frameRect];
    //清空背景颜色
    label.backgroundColor = [UIColor clearColor];
    //设置字体颜色为白色
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:18.0];
    label.textAlignment = NSTextAlignmentLeft;
    label.text=@"提醒值";
    [contentView addSubview:label];
    return contentView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
