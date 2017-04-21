//
//  CommentTableViewCell.h
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *usenamelab;
@property (weak, nonatomic) IBOutlet UILabel *commenttimelab;
@property (weak, nonatomic) IBOutlet UILabel *commentlab;

@end
