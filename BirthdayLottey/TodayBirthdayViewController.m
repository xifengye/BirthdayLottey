//
//  TodayBirthdayViewController.m
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/22.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "TodayBirthdayViewController.h"
#import "db/DataBaseManager.h"

@interface TodayBirthdayViewController ()

//@property NSMutableArray<Employee*>* todayBirthdayEmployees;

@end

@implementation TodayBirthdayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_datePicker addTarget:self action:@selector(dateWillChange:) forControlEvents:UIControlEventValueChanged];
    [_btnMonth addTarget:self action:@selector(dateWillChange:) forControlEvents:UIControlEventValueChanged];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEmployeeDelete:)
                                                 name:@"employee_change" object:nil];
}

-(void)didEmployeeDelete:(id)sender{
    [self.tableView reloadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [self dateWillChange:_datePicker];
}

-(void)dateWillChange:(id)sender{
    NSDate* _date = _datePicker.date;
    NSUInteger unitFlags = NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit;
    NSDateComponents * component = [_datePicker.calendar components:unitFlags fromDate:_date];
    [[DataBaseManager sharedManager] updateBirthdayDate:[component month] dayOfBirthday:[component day] isMonthBirthday:_btnMonth.on];
    [_numberLabel setText:[NSString stringWithFormat:@"%@寿星%d人",_btnMonth.on?@"月":@"日",[[DataBaseManager sharedManager] employeeByBirthday].count]];
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[DataBaseManager sharedManager] employeeByBirthday].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Employee *object = [[DataBaseManager sharedManager] employeeByBirthday][indexPath.row];
    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Employee* e = [[DataBaseManager sharedManager] employeeByBirthday][indexPath.row];
        [[DataBaseManager sharedManager] deleteEmployee:e];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"employee_change" object:nil];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
