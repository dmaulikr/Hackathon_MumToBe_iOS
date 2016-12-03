//
//  GPCommentTVCell.h
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCommentTVCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *usernameLbl;
@property (strong, nonatomic) IBOutlet UILabel *commentLbl;
@property (strong, nonatomic) IBOutlet UILabel *hoursLbl;

@end
