//
//  ShareManager.h
//  Matsu
//
//  Created by linqsh on 15/5/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "Reachability.h"
#import "UserInfo.h"

typedef void (^selectImage_block_t)(UIImage* image,NSString* imageName);

@interface ShareManager : NSObject<UIImagePickerControllerDelegate,UIActionSheetDelegate,UINavigationControllerDelegate>

+ (ShareManager *)shareInstance;

@property (nonatomic, strong) Reachability *reach;
@property (nonatomic, strong) UserInfo *userinfo;
@property (nonatomic, strong) NSString *shareContentId;//文章id 或者晒单id
@property (nonatomic, assign) int shareType;//0 无 1文章分析 2 晒单分享 3 app分享
@property (nonatomic, strong) NSString *isShowThird;
@property (nonatomic, strong) NSString *serverPhoneNum;
/**
 *  添加监听：网络状态变化
 */
- (void)addReachabilityChangedObserver;

/**
 *  拨打电话
 *
 *  @param phoneNumber 要拨打的号码
 *  @param view        拨号所在的页面
 */
- (void)dialWithPhoneNumber:(NSString *)phoneNumber inView:(UIView *)selfView;

/**
 *  从相册或相机中获取照片
 *
 *  @param vc        需要选择的图片的 UIViewController
 *  @param block     获取到图片后的操作
 */
- (void)selectPictureFromDevice:(UIViewController*)vc isReduce:(BOOL)isreduce isSelect:(BOOL)isSelect isEdit:(BOOL)isEdit block:(selectImage_block_t)block;
@end
