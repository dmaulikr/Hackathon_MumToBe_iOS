//
//  GPLoginVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/2/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPLoginVC.h"
#import "GPConnection.h"
#import "GPHomeWithSideMenuVC.h"
#import "GPRegisterVC.h"
#import "AppDelegate.h"

@interface GPLoginVC ()

@property (weak, nonatomic) IBOutlet UIImageView *mailIcon;
@property (weak, nonatomic) IBOutlet UIImageView *passwordIcon;
@property (weak, nonatomic) IBOutlet UITextField *mailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passwordTxt;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation GPLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.navigationController.navigationBar setHidden:YES];
    
    
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

-(IBAction)unwind:(UIStoryboardSegue*)segue
{
    
}


- (void)dismissDate:(UIGestureRecognizer *)gestureRecognizer {
    
    [_passwordTxt resignFirstResponder];
    [_mailTxt resignFirstResponder];
}

- (IBAction)forgetPasswordAction:(id)sender {
}


- (IBAction)loginAction:(id)sender {
    
    
    if (![GPConnection checkNetworkStatus]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Connection"
                                                        message:@"Please Check Your Internet Connection"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else {
        
        NSData* response = [GPInternetConnectionManager getDataFrom:@"sign-in" withParameters:[NSString stringWithFormat:@"email=%@&password=%@",self.mailTxt.text, self.passwordTxt.text]];
        
        NSDictionary* responseDic = [GPInternetConnectionManager convertJsonToDictionary:response];
        
        if ([[responseDic valueForKey:@"success"] integerValue] == 1)
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:@"isLogged"];
            [defaults synchronize];
            
            
            //this will exchanged by method in App Delegate to change root
            AppDelegate* myDelegate = (((AppDelegate*) [UIApplication sharedApplication].delegate));
            
            GPHomeWithSideMenuVC* homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC"];
            
            myDelegate.window.rootViewController = homeVC;
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Data!"
                                                            message:@"Incorrect E-mail or password, please enter valid data!"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}


- (IBAction)registerAction:(id)sender {
    
    GPRegisterVC* registerVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GPRegisterVC"];
    [self.navigationController pushViewController:registerVC animated:YES];
    
    
}




- (NSString *) getDataFrom:(NSString *)url{
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = [[NSError alloc] init];
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %i", url,[responseCode statusCode]);
        return nil;
    }
    
    return [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
}




@end
