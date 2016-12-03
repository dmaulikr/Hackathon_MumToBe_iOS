//
//  GPCommunityTVCell.h
//  GSGPregnancy
//
//  Created by Nour Shbair on 12/1/16.
//  Copyright © 2016 Nour Shbair. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GPCommunityTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *usernameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *seenCountLbl;
//@property (weak, nonatomic) IBOutlet UITextView *topicTxtVw;
@property (strong, nonatomic) IBOutlet UILabel *topicLbl;



@end
