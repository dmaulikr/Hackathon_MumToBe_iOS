//
//  GPAddTopicVC.h
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPAddTopicVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *categoryTxt;

@property (weak, nonatomic) IBOutlet UITextField *titleTxt;

@property (weak, nonatomic) IBOutlet UITextView *descriptionTxt;

@property NSArray *categories;


@end
