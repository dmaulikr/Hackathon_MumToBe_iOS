//
//  GPHomeWithSideMenuVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/2/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPHomeWithSideMenuVC.h"

@interface GPHomeWithSideMenuVC ()

@end

@implementation GPHomeWithSideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(NSString*)segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    
    NSString* identifier;
    
    switch (indexPath.row) {
        case 0:
            identifier = @"homeSegue";
            
            break;
            
        case 1:
            identifier = @"homeSegue";
            break;
            
        case 2:
            identifier = @"communitySegue";
            break;
            
        case 3:
            identifier = @"exercisesSegue";
            break;
        case 4:
            identifier = @"calculatorSegue";
            break;
            
        case 5:
            identifier = @"aboutSegue";
            break;
            
        case 6:
            identifier = @"shareSegue";
            break;
            
        case 7:
            identifier = @"settingsSegue";
            break;
            
        case 8:
            identifier = @"logoutSegue";
            break;
            
    }
    
    return identifier;
}


-(void)configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,5};
    frame.size = (CGSize){25,25};
    
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"menu_white"] forState:UIControlStateNormal];
    //    [button.imageView setImage:[UIImage imageNamed:@"menu"]];
}

@end
