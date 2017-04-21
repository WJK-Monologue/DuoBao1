//
//  WantToSDViewController.h
//  DuoBao
//
//  Created by gthl on 16/2/18.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyLayoutCollectView.h"
#import "ZJRecordListInfo.h"

@interface WantToSDViewController : UIViewController

@property (strong, nonatomic) ZJRecordListInfo *detailInfo;

@property (weak, nonatomic) IBOutlet UITextField *titleTextView;

@property (weak, nonatomic) IBOutlet UITextView *contentText;

@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectView;

@end
