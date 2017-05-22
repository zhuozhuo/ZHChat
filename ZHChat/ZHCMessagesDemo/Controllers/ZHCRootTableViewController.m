//
//  ZHCRootTableViewController.m
//  ZHChat
//
//  Created by aimoke on 16/8/8.
//  Copyright © 2016年 zhuo. All rights reserved.
//
#define CellIdentifier @"RootTableViewControllerCellIdenntifier"

#import "ZHCRootTableViewController.h"
#import "ZHCDemoMessagesViewController.h"

@interface ZHCRootTableViewController (){
    NSArray *dataArray;
}

@end

@implementation ZHCRootTableViewController


#pragma mark - Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    
    dataArray = @[@"Push",@"Present", @"Tab bar"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark － TableView datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    
    return cell;
}


#pragma mark - TableView delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:{
            ZHCDemoMessagesViewController *messagesVC = [[ZHCDemoMessagesViewController alloc]init];
            messagesVC.presentBool = NO;
            [messagesVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:messagesVC animated:YES];
        }
            break;
        case 1:{
            ZHCDemoMessagesViewController *messagesVC = [[ZHCDemoMessagesViewController alloc]init];
            messagesVC.presentBool = YES;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:messagesVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 2:{
            ZHCDemoMessagesViewController *messagesVC = [[ZHCDemoMessagesViewController alloc]init];
            messagesVC.presentBool = NO;
            UITabBarController *tabBarVC = [[UITabBarController alloc] init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:messagesVC];
            tabBarVC.tabBar.translucent = NO;
            tabBarVC.viewControllers = @[nav];
            [self.navigationController pushViewController:tabBarVC animated:YES];
        }
            break;

        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Remove seperator inset
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
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
