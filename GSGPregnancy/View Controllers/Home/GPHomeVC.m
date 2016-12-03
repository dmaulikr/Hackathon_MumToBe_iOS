//
//  GPHomeVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/2/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPHomeVC.h"
#import "GPConnection.h"
#import "GPCommonFunctions.h"

@interface GPHomeVC ()

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

@property (strong, nonatomic) IBOutlet UILabel *deliveryDateLbl;
@property (strong, nonatomic) IBOutlet UILabel *weeksLbl;
@property (strong, nonatomic) IBOutlet UILabel *daysLbl;
@property (strong, nonatomic) IBOutlet UILabel *monthLbl;

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIImageView *weekImgVw;

@property (strong, nonatomic) IBOutlet UILabel *motherLbl;

@property (strong, nonatomic) IBOutlet UILabel *babyLbl;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation GPHomeVC

@synthesize passedDays;
@synthesize passedMonths;
@synthesize passedWeeks;
@synthesize remainingDays;
@synthesize remainingWeeks;
@synthesize deleveryDate;

NSDate* deliveryDate;
NSDate* enteredDate;


NSString* weeks;
NSString* days;


NSArray* weeksData;
NSArray* mothersInfo;
NSArray* embryoInfo;
NSArray* weeksImages;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //    _scrollView.contentSize = _contentView.frame.size;
    _scrollView.contentSize = CGSizeMake(375, 820);
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    deliveryDate = [defaults objectForKey:@"deliveryDate"];
    enteredDate = [defaults objectForKey:@"enteredDate"];
    
    [self calculate];
    [self setLabelsTexts];
    
    [self getWeeksInfo];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
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

-(void)calculate
{
    
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd"];
    self.deleveryDate = [dateformat stringFromDate:deliveryDate];
    
    
    NSString* passedMonthsX;
    
    NSString* passedWeeksX;
    NSString* passedDaysX;
    NSString* remainingWeeksX;
    NSString* remainingDaysX;
    
    NSDate* currentDate = [NSDate date];
    
    NSInteger remainingDaysInt = [self daysBetweenDate:currentDate andDate:deliveryDate];
    
    NSInteger remainingWeeksInt = floor(remainingDaysInt/7);
    remainingWeeksX = [NSString stringWithFormat:@"%ld",(long)remainingWeeksInt];
    self.remainingWeeks = remainingWeeksX;
    
    
    NSInteger remainingDaysWithWeeksInt = remainingDaysInt - (remainingWeeksInt*4);
    remainingDaysX = [NSString stringWithFormat:@"%ld",(long)remainingDaysWithWeeksInt];
    self.remainingDays = remainingDaysX;
    
    
    NSInteger passedDaysInt = [self daysBetweenDate:enteredDate andDate:currentDate];
    
    
    NSInteger passedMonthsInt = ceil(passedDaysInt/30.3);
    passedMonthsX = [NSString stringWithFormat:@"%ld",(long)passedMonthsInt];
    self.passedMonths = passedMonthsX;
    
    
    NSInteger passedWeeksInt = floor(passedDaysInt/7);
    passedWeeksX = [NSString stringWithFormat:@"%ld",(long)passedWeeksInt];
    self.passedWeeks = passedWeeksX;
    
    
    NSInteger passedDaysWithWeeksInt = passedDaysInt - (passedWeeksInt*4);
    passedDaysX = [NSString stringWithFormat:@"%ld",(long)passedDaysWithWeeksInt];
    self.passedDays = passedDaysX;
}


-(NSDate*)convertStringToDate:(NSString*)str
{
    NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
    [dateformat setDateFormat:@"MM'/'dd'/'yyyy"];
    NSDate *date = [dateformat dateFromString:str];
    
    return date;
    
}

-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    NSDate *fromDate;
    NSDate *toDate;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                 interval:NULL forDate:fromDateTime];
    [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                 interval:NULL forDate:toDateTime];
    
    NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                               fromDate:fromDate toDate:toDate options:0];
    
    return [difference day];
}





-(void)setLabelsTexts
{
    self.deliveryDateLbl.text = self.deleveryDate;
    self.weeksLbl.text = passedWeeks;
    self.daysLbl.text = passedDays;
    
    if ([passedMonths isEqualToString:@"1"])
    {
        self.monthLbl.text = [NSString stringWithFormat:@"You are in %@st month",passedMonths];
    }
    else if ([passedMonths isEqualToString:@"2"])
    {
        self.monthLbl.text = [NSString stringWithFormat:@"You are in %@nd month",passedMonths];
    }
    else if ([passedMonths isEqualToString:@"3"])
    {
        self.monthLbl.text = [NSString stringWithFormat:@"You are in %@rd month",passedMonths];
    }
    else
    {
        self.monthLbl.text = [NSString stringWithFormat:@"You are in %@th month",passedMonths];
    }
}


- (IBAction)calculationsMethod:(id)sender {
    
    
    switch (self.segmentedControl.selectedSegmentIndex) {
            
        case 0:
            weeks = passedWeeks;
            days = passedDays;
            break;
            
        case 1:
            weeks = remainingWeeks;
            days = remainingDays;
            break;
            
        default:
            weeks = remainingWeeks;
            days = remainingDays;
            break;
            
    }
    self.weeksLbl.text = weeks;
    self.daysLbl.text = days;
    
}


-(void)getWeeksInfo
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
        
        NSData* response = [GPInternetConnectionManager getDataFrom:@"get_all_weeks_info" withParameters:[NSString stringWithFormat:@"language_id=2"]];
        
        NSDictionary* responseDic = [GPInternetConnectionManager convertJsonToDictionary:response];
        
        if ([[responseDic valueForKey:@"success"] integerValue] == 1)
        {
            
            weeksData = [responseDic valueForKey:@"data"];
            mothersInfo = [[weeksData valueForKey:@"weeks"]valueForKey:@"info"];
            embryoInfo = [[weeksData valueForKey:@"weeks"]valueForKey:@"embryo_info"];
            weeksImages = [[weeksData valueForKey:@"weeks"]valueForKey:@"image"];
            
            [self fillData];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Data"
                                                            message:@"Entered data is incorrect, please try again."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
    
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"weekCell" forIndexPath:indexPath];
    
    UILabel* weekLbl = [[UILabel alloc] initWithFrame:cell.bounds];
    
    weekLbl.text = [NSString stringWithFormat:@"%li",indexPath.row+1];
    weekLbl.textColor = [UIColor colorWithRed:(126/255.0) green:(103/255.0) blue:(117/255.0) alpha:1];
    weekLbl.textAlignment = NSTextAlignmentCenter;
    
    [cell addSubview:weekLbl];
    
    cell.contentView.backgroundColor = [UIColor clearColor];
    
    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[weeksImages objectAtIndex:indexPath.row]]]];
    [_weekImgVw setImage:image];
    
    _motherLbl.text = [mothersInfo objectAtIndex:indexPath.row];
    _babyLbl.text = [embryoInfo objectAtIndex:indexPath.row];
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(187/255.0) blue:(175/255.0) alpha:1];

    
}


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor clearColor];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 40;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}




-(void)fillData
{
    if (passedWeeks != nil) {
        passedWeeks = @"3";
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[weeksImages objectAtIndex:[passedWeeks integerValue]-1]]]];
        [_weekImgVw setImage:image];
        
        _motherLbl.text = [mothersInfo objectAtIndex:[passedWeeks integerValue]-1];
        _babyLbl.text = [embryoInfo objectAtIndex:[passedWeeks integerValue]-1];
        
    }
}


@end
