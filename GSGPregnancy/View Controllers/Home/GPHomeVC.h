//
//  GPHomeVC.h
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/2/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPHomeVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property NSString* passedMonths;
@property NSString* passedWeeks;
@property NSString* passedDays;

@property NSString* remainingWeeks;
@property NSString* remainingDays;

@property NSString* deleveryDate;

@end
