//
//  DBNumViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/17.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"

@interface DBNumViewController : UIViewController

@property (strong, nonatomic) NSString *goodId;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *goodName;

@property (weak, nonatomic) IBOutlet UICollectionView *myCollectView;

@property (weak, nonatomic) IBOutlet UILabel *tiltleLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnLabel;


@end

@interface DuoBaoNumInfo : NSObject

@property (nonatomic, strong) NSString *fight_num;


@end
