//
//  GPExercisesVC.m
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/2/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import "GPExercisesVC.h"
#import "GPConnection.h"

@interface GPExercisesVC ()

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *lbl;

@end

NSArray* exercisesData;
NSArray* exercisesDesciption;
NSArray* exercisesImages;

@implementation GPExercisesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getExercisesInfo];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Exercises"
                                                    message:@"Train only if you feel well. If you feel slightly uncomfortable, stop. Train to keep running during pregnancy, not to improve your fitness and strength"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
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


-(void)getExercisesInfo
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
        
        NSData* response = [GPInternetConnectionManager getDataFrom:@"get_all_trainings" withParameters:@""];
        
        NSDictionary* responseDic = [GPInternetConnectionManager convertJsonToDictionary:response];
        
        if ([[responseDic valueForKey:@"success"] integerValue] == 1)
        {
            
            exercisesData = [responseDic valueForKey:@"data"];
            exercisesDesciption = [[exercisesData valueForKey:@"trainings"]valueForKey:@"details"];
            exercisesImages = [[exercisesData valueForKey:@"trainings"]valueForKey:@"image"];
            
            [self fillData];
            
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


-(void)fillData
{
    //    if (passedWeeks != nil) {
    
    //        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[exercisesImages objectAtIndex:[passedWeeks integerValue]-1]]]];
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[exercisesImages objectAtIndex:1]]]];
    [_imageView setImage:image];
    //        _lbl.text = [exercisesDesciption objectAtIndex:[passedWeeks integerValue]-1];
    _lbl.text = [exercisesDesciption objectAtIndex:1];
    
    
    //    }
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"exerciseCell" forIndexPath:indexPath];
    
    UILabel* weekLbl = [[UILabel alloc] initWithFrame:cell.bounds];
    
    weekLbl.text = [NSString stringWithFormat:@"%li",indexPath.row+1];
    
    [cell addSubview:weekLbl];
    
    return cell;
    
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[exercisesImages objectAtIndex:indexPath.row]]]];
    [_imageView setImage:image];
    
    _lbl.text = [exercisesDesciption objectAtIndex:indexPath.row];
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

@end
