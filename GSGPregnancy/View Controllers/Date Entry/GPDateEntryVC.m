//
//  GPDateEntryVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPDateEntryVC.h"
#import "GPHomeWithSideMenuVC.h"
#import "GPConnection.h"
#import "GPCommonFunctions.h"

@interface GPDateEntryVC ()
{
    
    
    IBOutlet UISegmentedControl *methodSegmented;
    
    
    IBOutlet UIView *periodView;
    
    IBOutlet UIImageView *periodIcon;
    IBOutlet UILabel *periodLbl;
    IBOutlet UITextField *periodTxt;
    
    IBOutlet UIImageView *periodAvgIcon;
    IBOutlet UILabel *periodAvgLbl;
    IBOutlet UITextField *periodAvgTxt;
    
    
    IBOutlet UIView *pregnancyView;
    
    IBOutlet UITextField *pregnancyDateTxt;
    
    BOOL isPeriodMethod;
    
}
@end

@implementation GPDateEntryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationController.navigationBarHidden = YES;
    
    [pregnancyView setHidden:NO];
    [periodView setHidden:YES];
    
    
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateTextField:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    [periodTxt setInputView:datePicker];
    [pregnancyDateTxt setInputView:datePicker];
    
    
    
    UITapGestureRecognizer *tapGestureRecognize = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissDate:)];
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

- (void)dismissDate:(UIGestureRecognizer *)gestureRecognizer {
    
    [periodTxt resignFirstResponder];
    [pregnancyDateTxt resignFirstResponder];
}

-(void)updateTextField:(id)sender
{
    if (isPeriodMethod)
    {
        UIDatePicker *picker = (UIDatePicker*)periodTxt.inputView;
        periodTxt.text = [self formatDate:picker.date];
    }
    else
    {
        UIDatePicker *picker = (UIDatePicker*)pregnancyDateTxt.inputView;
        pregnancyDateTxt.text = [self formatDate:picker.date];
    }
}

- (IBAction)calculationsMethodSelected:(id)sender {
    
    
    switch (methodSegmented.selectedSegmentIndex) {
            
        case 0:
            [periodView setHidden:YES];
            [pregnancyView setHidden:NO];
            isPeriodMethod = NO;
            break;
            
        case 1:
            [pregnancyView setHidden:YES];
            [periodView setHidden:NO];
            isPeriodMethod = YES;
            break;
            
        default:
            [pregnancyView setHidden:YES];
            [periodView setHidden:NO];
            isPeriodMethod = YES;
            break;
            
    }
    
    
}




- (IBAction)nextVC:(id)sender
{
    
    NSDate* enteredDate;
    NSDate* deliveryDate;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    BOOL isFilled;
    if (isPeriodMethod)
    {
        if (periodTxt.text == nil || periodTxt.text == NULL || [periodTxt.text isEqualToString:@""] || periodAvgTxt.text == nil || periodAvgTxt.text == NULL || [periodAvgTxt.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Field"
                                                            message:@"Please enter required data to continue."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            enteredDate = [self convertStringToDate:periodTxt.text];\
            [defaults setObject:periodTxt.text forKey:@"lastPeriodDate"];
            [defaults synchronize];
            deliveryDate = [enteredDate dateByAddingTimeInterval:60*60*24*280];
            isFilled = true;
        }
    }
    else
    {
        if (pregnancyDateTxt.text == nil || pregnancyDateTxt.text == NULL || [pregnancyDateTxt.text isEqualToString:@""])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Missing Field"
                                                            message:@"Please enter pregnancy date to continue."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            enteredDate = [self convertStringToDate:pregnancyDateTxt.text];
            [defaults setObject:pregnancyDateTxt.text forKey:@"pregnancyDate"];
            [defaults synchronize];
            deliveryDate = [enteredDate dateByAddingTimeInterval:60*60*24*266];
            isFilled = true;
            
        }
    }
    
    if (isFilled) {
        
        GPHomeWithSideMenuVC* homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
        
        
        
        [defaults setObject:deliveryDate forKey:@"deliveryDate"];
        [defaults setObject:enteredDate forKey:@"enteredDate"];
        [defaults synchronize];
        
        NSString* userID = [GPCommonFunctions filterNullString:[defaults objectForKey:@"userID"]];
        
        
        if (![GPConnection checkNetworkStatus]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                            message:@"Please Check Your Internet Connection"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else {
            
            
            NSString* pregnancyTxt = [GPCommonFunctions formatDateWS:[GPCommonFunctions filterNullString:pregnancyDateTxt.text]];
            
            NSString* periodDateTxt = [GPCommonFunctions formatDateWS:[GPCommonFunctions filterNullString:periodTxt.text]];
            
            NSString* deliveryTxt = [GPCommonFunctions formatDateWS:[GPCommonFunctions formatDate:deliveryDate]];
            
            if ([periodDateTxt isEqualToString:@""]) {
                periodDateTxt = pregnancyTxt;
            }
            if ([pregnancyTxt isEqualToString:@""]) {
                pregnancyTxt = periodDateTxt;
            }
            
            NSData* response = [GPInternetConnectionManager getDataFrom:@"set_user_settings" withParameters:[NSString stringWithFormat:@"user_id=%@&calendar_type_id=%@&pregnancy_date=%@&period_date=%@&period_avg=%@&get_notifications=%@&view_day_type_id=%@&count_week_days=%@&birth_date=%@",userID, @"1",pregnancyTxt,periodDateTxt,@"28",@"0",@"0",@"0",deliveryTxt]];
            
            NSDictionary* responseDic = [GPInternetConnectionManager convertJsonToDictionary:response];
            
            if ([[responseDic valueForKey:@"success"] integerValue] == 1)
            {
                
                [self.navigationController pushViewController:homeVC animated:YES];
                
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Data"
                                                                message:@"Empty data, please make sure that you choose a date"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
        
    }
    
}


-(NSString*)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"MM'/'dd'/'yyyy"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
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

@end
