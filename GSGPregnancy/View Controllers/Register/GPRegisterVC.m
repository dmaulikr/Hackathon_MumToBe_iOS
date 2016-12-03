//
//  GPRegisterVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/2/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPRegisterVC.h"
#import "GPDateEntryVC.h"
#import "GPConnection.h"
#import "GPCommonFunctions.h"
#import "GPLoginVC.h"
#import "AppDelegate.h"

@interface GPRegisterVC ()

@property (weak, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UITextField *usernameTxt;
@property (strong, nonatomic) IBOutlet UITextField *emailTxt;
@property (strong, nonatomic) IBOutlet UITextField *passwordTxt;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTxt;

@end

@implementation GPRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.profilePictureImageView.layer.cornerRadius = self.profilePictureImageView.frame.size.width / 2;
    self.profilePictureImageView.clipsToBounds = YES;
    
    
    self.navigationController.title = @"Register";
    
    
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
    
    [_usernameTxt resignFirstResponder];
    [_emailTxt resignFirstResponder];
    [_passwordTxt resignFirstResponder];
    [_confirmPasswordTxt resignFirstResponder];
    
    
    
}

- (IBAction)registerAction:(id)sender {
    
    
    if (![GPConnection checkNetworkStatus]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                        message:@"Please Check Your Internet Connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    else {
        if (![self.passwordTxt.text isEqualToString:self.confirmPasswordTxt.text])
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Entered passwords did not match."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
        }
        else
        {
            NSData* response = [GPInternetConnectionManager getDataFrom:@"sign-up" withParameters:[NSString stringWithFormat:@"username=%@&email=%@&password=%@&user_language=1",self.usernameTxt.text, self.emailTxt.text, self.passwordTxt.text]];
            
            NSDictionary* responseDic = [GPInternetConnectionManager convertJsonToDictionary:response];
            
            if ([[responseDic valueForKey:@"success"] integerValue] == 1)
            {
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setBool:YES forKey:@"isLogged"];
                
                NSDictionary* data = [responseDic valueForKey:@"data"];
                GPSharedInstance.userID = [data valueForKey:@"user_id"];
                
                [defaults setBool:[data valueForKey:@"user_id"] forKey:@"userID"];
                [defaults synchronize];
                
                AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
                
                UIViewController* rootController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"GPDateEntryVC"];
                UINavigationController* navigation = [[UINavigationController alloc] initWithRootViewController:rootController];
                
                delegate.window.rootViewController = navigation;
                
                
                //            [self.navigationController pushViewController:enteryVC animated:YES];
            }
            else if ([[responseDic valueForKey:@"success"] integerValue] == 2)
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exist Email"
                                                                message:@"Entered Email is Already Exist!"
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ja "
                                                      otherButtonTitles:nil];
                [alert show];
                
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Error occured, please try again."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            }
        }
    }
}


- (IBAction)gotoLoginVC:(id)sender {
    
    GPLoginVC* loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GPLoginVC"];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}


@end


