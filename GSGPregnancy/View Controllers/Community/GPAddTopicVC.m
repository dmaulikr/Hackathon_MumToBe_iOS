//
//  GPAddTopicVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPAddTopicVC.h"

@interface GPAddTopicVC ()

@end

@implementation GPAddTopicVC

@synthesize categories;

NSArray* categoriesNameAry;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognize];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    categoriesNameAry = [[categories valueForKey:@"categories"]valueForKey:@"name"];
    
    
    UIPickerView* picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 50, 100, 150)];
    [picker setDataSource: self];
    [picker setDelegate: self];
    picker.showsSelectionIndicator = YES;
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dismissPicker:(UIGestureRecognizer *)gestureRecognizer {
    
    [_categoryTxt resignFirstResponder];
    [_titleTxt resignFirstResponder];
    [_descriptionTxt resignFirstResponder];
    
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [categoriesNameAry count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _categoryTxt.text = [categoriesNameAry objectAtIndex:row];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [categoriesNameAry objectAtIndex:row];
    
}

@end
