//
//  GPCommunityVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPCommunityVC.h"
#import "GPAddTopicVC.h"
#import "GPConnection.h"
#import "GPCommunityTVCell.h"

@interface GPCommunityVC ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UITextField *categoryTxt;
@end


NSArray* categoriesData;
NSArray* categoriesName;

NSArray* postsData;
NSArray* profilePictures;
NSArray* usernames;
NSArray* postsTimes;
NSArray* titles;
NSArray* commentsCounts;
NSArray* seenCounts;
NSArray* topics;



@implementation GPCommunityVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getCategories];
    [self getSectionData:@"23"];
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissPicker:)];
    tapGestureRecognize.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGestureRecognize];
    
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

- (void)dismissPicker:(UIGestureRecognizer *)gestureRecognizer {
    
    [_categoryTxt resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [postsData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GPCommunityTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IPCommunityTVCell" forIndexPath:indexPath];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[profilePictures objectAtIndex:indexPath.row]]]];
    
    [cell.profilePicture setImage:image];
    
    [cell.usernameLbl setText:[usernames objectAtIndex:indexPath.row]];
    [cell.titleLbl setText:[titles objectAtIndex:indexPath.row]];
    [cell.commentsCountLbl setText:[commentsCounts objectAtIndex:indexPath.row]];
    [cell.seenCountLbl setText:[seenCounts objectAtIndex:indexPath.row]];
    [cell.topicLbl setText:[topics objectAtIndex:indexPath.row]];
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 50;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    UIView* view = UIView.new;
    
    UIButton* addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 50, 50)];
    [addBtn setImage:[UIImage imageNamed:@"plus_circle"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(gotoAddTopic:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:addBtn];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    _categoryTxt = [[UITextField alloc] initWithFrame:CGRectMake(120, 15, 200, 30)];
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    _categoryTxt.inputView = _pickerView;
    
    _categoryTxt.text = @"Choose category:";
    //    categoryTxt.enabled = NO;
    //    _categoryTxt.center = CGPointMake(CGRectGetWidth(tableView.bounds)/2.0f, CGRectGetHeight(tableView.bounds)/2.0f);
    return _categoryTxt;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [categoriesName count];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _categoryTxt.text = [categoriesName objectAtIndex:row];
    [self getSectionData:[[[categoriesData valueForKey:@"categories"]valueForKey:@"id"] objectAtIndex:row]];
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [categoriesName objectAtIndex:row];
    
}



- (IBAction)gotoAddTopic:(id)sender
{
    
    
    GPAddTopicVC* addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"IPAddTopicVC"];
    addVC.categories = categoriesData;
    [self.navigationController pushViewController:addVC animated:YES];
}


-(void)getSectionData:(NSString*)categoryID
{
    
    if (![GPConnection checkNetworkStatus]) {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                    message:@"Please Check Your Internet Connection"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
    }
    else {
        
        NSString *count = @"20";
        NSString *step = @"0";
        
//        NSData* response = [GPInternetConnectionManager getDataFrom:@"get_posts_list" withParameters:[NSString stringWithFormat:@"category_id=%@&count=%@&step=%@",categoryID,count,step]];
        
        NSData* response = [GPInternetConnectionManager getDataFrom:@"get_posts_list" withParameters:[NSString stringWithFormat:@"category_id=23&count=%@&step=%@",count,step]];
        
        NSDictionary* responseDic = [GPInternetConnectionManager convertJsonToDictionary:response];
        
        if ([[responseDic valueForKey:@"success"] integerValue] == 1)
        {
            
            postsData = [[responseDic valueForKey:@"data"] valueForKey:@"posts"];
            
            profilePictures = [postsData valueForKey:@"img"];
            usernames = [postsData valueForKey:@"username"];
            postsTimes = [postsData valueForKey:@"date"];
            titles = [postsData valueForKey:@"title"];
            commentsCounts = [postsData valueForKey:@"no_of_comments"];
            seenCounts = [postsData valueForKey:@"no_of_views"];
            topics = [postsData valueForKey:@"subtitle"];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Data"
                                                            message:@"No posts exist for this category."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
}



-(void)getCategories
{
    if (![GPConnection checkNetworkStatus]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                        message:@"Please Check Your Internet Connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else {
        
        
        NSData* response = [GPInternetConnectionManager getDataFrom:@"get_categories" withParameters:[NSString stringWithFormat:@"cat_language=3"]];
        
        NSDictionary* responseDic = [GPInternetConnectionManager convertJsonToDictionary:response];
        
        if ([[responseDic valueForKey:@"success"] integerValue] == 1)
        {
            
            categoriesData = [responseDic valueForKey:@"data"];
            categoriesName = [[categoriesData valueForKey:@"categories"]valueForKey:@"name"];
            
            [_pickerView reloadInputViews];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Data"
                                                            message:@"Entered username or password is incorrect, please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
}




@end
