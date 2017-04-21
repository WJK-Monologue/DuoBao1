//
//  CommentTableViewCell.m
//  DuoBao
//
//  Created by Macintosh on 2017/3/21.
//  Copyright © 2017年 linqsh. All rights reserved.
//

#import "CommentTableViewCell.h"

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 20;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
