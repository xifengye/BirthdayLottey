//
//  DetailViewController.m
//  BirthdayLottey
//
//  Created by yexifeng on 16/4/21.
//  Copyright © 2016年 moregood. All rights reserved.
//

#import "DetailViewController.h"
#import "DataBaseManager.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self initDetailPanel];
    }
}

- (void)initDetailPanel {
    // Update the user interface for the detail item.
    self.addPanel.hidden = YES;
    self.detailPanel.hidden = NO;
    
    if (self.detailItem) {
        self.navigationItem.title = self.detailItem.name;
        self.profile.image = [UIImage imageNamed:[NSString stringWithFormat:@"default_%d.png",self.detailItem.sex]];
        self.labelName.text = [NSString stringWithFormat:@"性别:\t%@",[self.detailItem sexStr]];
        self.labelDept.text = [NSString stringWithFormat:@"部门:\t%@",self.detailItem.dept];
        self.labelNumber.text = [NSString stringWithFormat:@"工号:\t%@",self.detailItem.number];
        self.labelBirthday.text = [NSString stringWithFormat:@"生日:\t%d-%d",self.detailItem.mob,self.detailItem.dob];
        self.labelAccessionDate.text = [NSString stringWithFormat:@"就职日期:\t%@",self.detailItem.accession_date];
        self.labelCountry.text = [NSString stringWithFormat:@"国籍:\t%@",self.detailItem.country];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    if(addMode){
        [self initAddEmployeeUI];
    }else{
        [self initDetailPanel];
    }
}

- (void)insertNewEmployee:(id)sender {
    
    
    NSString* name = self.tfName.text;
    if(name==nil || name.length<=0){
        return;
    }
    NSString* number = self.tfNumber.text;
    if(number==nil || number.length<=0){
        return;
    }
    NSInteger mob = [self.pvMonth selectedRowInComponent:0]+1;
    NSInteger dob = [self.pvMonth selectedRowInComponent:1]+1;
    NSString* dept = [DataBaseManager sharedManager].deptNames[[self.pvDept selectedRowInComponent:0]];
    Employee* employee = [Employee employeeWithParam:number name:name sex:self.sSex.isOn?0:1 country:@"中国" url:@"" mob:mob dob:dob dept:dept accession_data:@""];
    [[DataBaseManager sharedManager]insertEmployee:employee];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"employee_change" object:nil];
    self.navigationItem.rightBarButtonItem = nil;
    self.addPanel.hidden = YES;
}

-(void)showAddEmployeePanel{
    addMode = true;
    
}

-(void)initAddEmployeeUI{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(insertNewEmployee:)];
    self.navigationItem.rightBarButtonItem = addButton;
    self.addPanel.hidden = NO;
    self.detailPanel.hidden = YES;
    self.pvDept.dataSource = self;
    self.pvDept.delegate = self;
    self.pvMonth.dataSource = self;
    self.pvMonth.delegate = self;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark- 设置数据
//一共多少列
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if(pickerView==self.pvDept){
        return 1;
    }
    else{
        return 2;
    }
}

//每列对应多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView==self.pvDept){
        return [DataBaseManager sharedManager].deptNames.count;
    }else{
        return component==0? 12:31;
    }
}

//每列每行对应显示的数据是什么
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView==self.pvDept){
        return [DataBaseManager sharedManager].deptNames[row];
    }else{
        return [NSString stringWithFormat:@"%d",row+1];
    }
}

#pragma mark-设置下方的数据刷新
// 当选中了pickerView的某一行的时候调用
// 会将选中的列号和行号作为参数传入
// 只有通过手指选中某一行的时候才会调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
}


@end
