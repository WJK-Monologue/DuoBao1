//
//  HttpHelper.m
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import "HttpHelper.h"
#import "AFHTTPRequestOperationManager.h"
#import "RSAEncrypt.h"
#import "SecurityUtil.h"

@implementation HttpHelper

/**
 * 拼接:URL_Server+keyURL
 */
- (NSString *)getURLbyKey:(NSString *)URLKey{
    
    return [NSMutableString stringWithFormat:@"%@%@",URL_ShareServer, URLKey];

}

#pragma mark - 注册、登录、获取验证码、找回密码
/**
 * 获取验证码
 * type:[1.注册,2.找回密码,3.修改电话号码和微信绑定]
 */
- (void)getVerificationCodeByMobile:(NSString *)mobile
                               type:(NSString *)type
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetVerificationCode];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}



/**
 * 注册
 */
- (void)registerByWithMobile:(NSString *)mobile
                    password:(NSString *)password
           recommend_user_id:(NSString *)recommend_user_id
                   auth_code:(NSString *)auth_code
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    if (recommend_user_id) {
        [parameters setObject:recommend_user_id forKey:@"recommend_user_id"];
    }else{
        [parameters setObject:@"" forKey:@"recommend_user_id"];
    }
    if (auth_code) {
        [parameters setObject:auth_code forKey:@"auth_code"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_Register];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 第三方
 */
- (void)loginByWithMobile:(NSString *)mobile
                 password:(NSString *)password
                 jpush_id:(NSString *)jpush_id
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    if (password) {
        
        [parameters setObject:password forKey:@"password"];
    }
    if (jpush_id) {
        
        [parameters setObject:jpush_id forKey:@"jpush_id"];
    }else{
        [parameters setObject:@"" forKey:@"jpush_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_Login];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 第三方登录
 * jpush_id :极光推送id(registrationId)
 * type:登陆形式[weixin,qq]
 */
- (void)thirdloginByWithLoginId:(NSString *)app_login_id
                      nick_name:(NSString *)nick_name
                    user_header:(NSString *)user_header
                           type:(NSString *)type
                       jpush_id:(NSString *)jpush_id
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (app_login_id) {
        [parameters setObject:app_login_id forKey:@"app_login_id"];
    }
    if (nick_name) {
        
        [parameters setObject:nick_name forKey:@"nick_name"];
    }else{
         [parameters setObject:@"" forKey:@"nick_name"];
    }
    
    if (user_header) {
        
        [parameters setObject:user_header forKey:@"user_header"];
    }else{
        [parameters setObject:@"" forKey:@"user_header"];
    }

    if (type) {
        
        [parameters setObject:type forKey:@"type"];
    }else{
        [parameters setObject:@"" forKey:@"type"];
    }
    
    if (jpush_id) {
        
        [parameters setObject:jpush_id forKey:@"jpush_id"];
    }else{
        [parameters setObject:@"" forKey:@"jpush_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ThirdLogin];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 找回密码
 */
- (void)findPwdByWithMobile:(NSString *)mobile
                   password:(NSString *)password
                  auth_code:(NSString *)auth_code
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (mobile) {
        [parameters setObject:mobile forKey:@"app_login_id"];
    }
    if (password) {
        [parameters setObject:password forKey:@"password"];
    }
    if (auth_code) {
        [parameters setObject:auth_code forKey:@"auth_code"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_FindPwd];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 第三方绑定
 */
- (void)bangDingByWithLoginId:(NSString *)app_login_id
                         type:(NSString *)type
                      url_tel:(NSString *)url_tel
                    auth_code:(NSString *)auth_code
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (app_login_id) {
        [parameters setObject:app_login_id forKey:@"app_login_id"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    if (url_tel) {
        [parameters setObject:url_tel forKey:@"user_tel"];
    }
    if (auth_code) {
        [parameters setObject:auth_code forKey:@"auth_code"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_BangDing];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 我的
/**
 * 获取大转盘大奖历史纪录
 */
- (void)getRotaryGameHistoryWithPageNum:(NSString *)pageNum
                               limitNum:(NSString *)limitNum
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetRotaryGameHistory];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 签到
 */
- (void)userSignWithUserId:(NSString *)user_id
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_Sign];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetUserInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 收获地址列表
 */
- (void)receiveAddressListWithUserId:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetAdressList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 修改默认地址
 */
- (void)changeDefaultAddressWithUserId:(NSString *)user_id
                             addressId:(NSString *)addressId
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (addressId) {
        [parameters setObject:addressId forKey:@"id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeDefaultAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 *添加或修改我的收获地址
 *
 */
- (void)addAddressWithUserId:(NSString *)user_id
                   addressId:(NSString *)addressId
                    user_tel:(NSString *)user_tel
                   user_name:(NSString *)user_name
                 province_id:(NSString *)province_id
                     city_id:(NSString *)city_id
              detail_address:(NSString *)detail_address
                  is_default:(NSString *)is_default
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (addressId) {
        [parameters setObject:addressId forKey:@"id"];
    }else{
         [parameters setObject:@"" forKey:@"id"];
    }
    
    if (user_tel) {
        [parameters setObject:user_tel forKey:@"user_tel"];
    }
    if (user_name) {
        [parameters setObject:user_name forKey:@"user_name"];
    }
    if (province_id) {
        [parameters setObject:province_id forKey:@"province_id"];
    }
    if (city_id) {
        [parameters setObject:city_id forKey:@"city_id"];
    }
    if (detail_address) {
        [parameters setObject:detail_address forKey:@"detail_address"];
    }
    if (is_default) {
        [parameters setObject:is_default forKey:@"is_default"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_AddAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取城市列表
 */
- (void)getCityInfoWithProvinceId:(NSString *)provinceId
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (provinceId) {
        [parameters setObject:provinceId forKey:@"provinceId"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetCityInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 删除地址
 */
- (void)deleteAddressWithAddressId:(NSString *)addressId
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (addressId) {
        [parameters setObject:addressId forKey:@"id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_DeleteMyAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 修改用户信息
 * fieldName:字段名称(多个请用,隔开)
 * fieldNameValue:修改后的字段值(多个请用,隔开)
 * updateFieldNameNum:修改字段数量
 */
- (void)changeUserInfoWithUserId:(NSString *)user_id
                       fieldName:(NSString *)fieldName
                  fieldNameValue:(NSString *)fieldNameValue
              updateFieldNameNum:(NSString *)updateFieldNameNum
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (fieldName) {
        [parameters setObject:fieldName forKey:@"fieldName"];
    }
    if (fieldNameValue) {
        [parameters setObject:fieldNameValue forKey:@"fieldNameValue"];
    }
    if (updateFieldNameNum) {
        [parameters setObject:updateFieldNameNum forKey:@"updateFieldNameNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeUserInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取系统消息
 */
- (void)getSystemMessageWithPageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                             userId:(NSString *)userId
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    if (userId) {
        [parameters setObject:userId forKey:@"userId"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_SystemMessage];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取夺宝记录
 * status: 夺宝状态[全部、已揭晓、进行]
 */
- (void)getDuoBaoRecordWithUserid:(NSString *)user_id
                           status:(NSString *)status
                          pageNum:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (status) {
        [parameters setObject:status forKey:@"status"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetDuoBaoRecordList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 我的中奖记录
 */
- (void)getZJRecordWithUserid:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetZJRecord];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 修改订单地址
 */
- (void)changeOrderAddressWithOrderId:(NSString *)orderId
                       consignee_name:(NSString *)consignee_name
                        consignee_tel:(NSString *)consignee_tel
                    consignee_address:(NSString *)consignee_address
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (orderId) {
        [parameters setObject:orderId forKey:@"id"];
    }
    
    
    if (consignee_name) {
        [parameters setObject:consignee_name forKey:@"consignee_name"];
    }
    
    if (consignee_tel) {
        [parameters setObject:consignee_tel forKey:@"consignee_tel"];
    }
    
    if (consignee_address) {
        [parameters setObject:consignee_address forKey:@"consignee_address"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeOrderAddress];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 发布晒单
 */
- (void)publicShaiDanWithUserId:(NSString *)user_id
                 goods_fight_id:(NSString *)goods_fight_id
                          title:(NSString *)title
                        content:(NSString *)content
                           imgs:(NSString *)imgs
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }
    
    if (title) {
        [parameters setObject:title forKey:@"title"];
    }
    
    if (content) {
        [parameters setObject:content forKey:@"content"];
    }else{
        [parameters setObject:@"" forKey:@"content"];
    }
    
    if (imgs) {
        [parameters setObject:imgs forKey:@"imgs"];
    }else{
        [parameters setObject:@"" forKey:@"imgs"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_PublishFightBask];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 积分流水
 * type:类型[1.积分列表，2.夺宝币列表]
 */
- (void)getPointDetailInfoWithUserId:(NSString *)user_id
                                type:(NSString *)type
                             pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetPointDetailInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取积分兑换所需数据
 */
- (void)getPointDHWithUserId:(NSString *)user_id
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
   
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetTXPoundage];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 积分兑换
 * exchange_type:兑换类型[real(人民币),virtual(夺宝币)]
 */
- (void)putPointExchangeApplyWithUserId:(NSString *)user_id
                          exchange_type:(NSString *)exchange_type
                              pay_score:(NSString *)pay_score
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (exchange_type) {
        [parameters setObject:exchange_type forKey:@"exchange_type"];
    }
    
    if (pay_score) {
        [parameters setObject:pay_score forKey:@"pay_score"];
    }
    
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_PointExchange];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 邀请好友基本数据
 */
- (void)getInviteFriendsInfoWithUserId:(NSString *)user_id
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_InviteFriendsInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 邀请好友列表
 * level: 好友层级[1,2,3]
 */
- (void)getFriendsByLevelWithUserId:(NSString *)user_id
                              level:(NSString *)level
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (level) {
        [parameters setObject:level forKey:@"level"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetFriendsByLevel];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取优惠券
 * type:类型[1.未使用，2.已使用/失效]
 */
- (void)getCouponsListWithUserId:(NSString *)user_id
                            type:(NSString *)type
                         pageNum:(NSString *)pageNum
                        limitNum:(NSString *)limitNum
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetCouponList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 兑换优惠券
 */
- (void)exchangeCouponsWithUserId:(NSString *)user_id
                        couponsId:(NSString *)couponsId
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (couponsId) {
        [parameters setObject:couponsId forKey:@"id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ExchangeCouponList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取等级说明
 */
- (void)getMyLevelInfoWithUserId:(NSString *)user_id
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetMyLevelInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取充值记录
 */
- (void)getCZRecordWithUserId:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetCZReord];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 充值
 * type:[weixin/zhifubao]
 */
- (void)payCZWithUserId:(NSString *)user_id
                  money:(NSString *)money
                typeStr:(NSString *)typeStr
                success:(void (^)(NSDictionary *resultDic))success
                   fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (money) {
        [parameters setObject:money forKey:@"money"];
    }
    if (typeStr) {
        [parameters setObject:typeStr forKey:@"type"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_PayCZ];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 意见反馈
 */
- (void)putFeedBackWithUserId:(NSString *)user_id
                      content:(NSString *)content
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    [parameters setObject:@"" forKey:@"title"];
    
    if (content) {
        [parameters setObject:content forKey:@"content"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_Feedback];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


#pragma mark - 首页
/**
 * 获取首页商品数据
 *
 * order_by_name: 排序字段名称[now_people(人气),create_time(最新),progress(进度),need_people(总需人次)
 * order_by_rule: 排序规则[desc,asc]
 *
 */
- (void)getGoodsListWithpageNum:(NSString *)pageNum
                       limitNum:(NSString *)limitNum
                         number:(NSString *)number
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }
    if (number) {
        [parameters setObject:number forKey:@"number"];

    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetGoodsInfoList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取分类下商品列表
 *
 */
- (void)getGoodsListOfTypeWithGoodsTypeIde:(NSString *)goodsTypeId
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsTypeId) {
        [parameters setObject:goodsTypeId forKey:@"goodsTypeId"];
    }else{
        [parameters setObject:@"" forKey:@"goodsTypeId"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetGoodsListOfType];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 搜索商品
 *
 */
- (void)searchGoodsWithSearchKey:(NSString *)searchKey
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (searchKey) {
        [parameters setObject:searchKey forKey:@"searchKey"];
    }else{
        [parameters setObject:@"" forKey:@"searchKey"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_SearchGoodsInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 加载商品详情
 *
 */
- (void)loadGoodsDetailInfoWithGoodsId:(NSString *)goods_fight_id
                                userId:(NSString *)user_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_LoadGoodsDetailInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
//改动
- (void)loadProductsDetailInfoWithId:(NSString *)productid
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (productid) {
        [parameters setObject:productid forKey:@"productId"];
    }else{
        [parameters setObject:@"" forKey:@"productId"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_LoadGoodsDetailInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
//改动  晒单
-(void)loadProductdetailproductId:(NSString *)productId
                          pageNum:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (productId) {
        [parameters setObject:productId forKey:@"productId"];
    }else{
        [parameters setObject:@"" forKey:@"productId"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ShaiDanList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取夺宝记录（参与夺宝的所以人）
 *
 */
- (void)loadDuoBaoRecordWithGoodsId:(NSString *)goods_fight_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_LoadDuoBaoRecord];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
//评论
- (void)loadCommentWithGoodsId:(NSString *)goodsId
                       pageNum:(NSString *)pageNum
                      limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"goodsId"];
    }else{
        [parameters setObject:@"" forKey:@"goodsId"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_CommentsProductsInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
//中奖纪录
- (void)loadWinnerRecoardWithGoodsId:(NSString *)goodsId
                             pageNum:(NSString *)pageNum
                            limitNum:(NSString *)limitNum
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"goodsId"];
    }else{
        [parameters setObject:@"" forKey:@"goodsId"];
    }
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }

    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_WinnerRecord];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
//用户详情
- (void)loadUserDetailUserId:(NSString *)userId
                     success:(void (^)(NSDictionary *))success
                        fail:(void (^)(NSString *))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (userId) {
        [parameters setObject:userId forKey:@"id"];
    }else{
        [parameters setObject:@"" forKey:@"id"];
    }
    NSString *URLString = [self getURLbyKey:URL_UserDetail];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
//多个用户详情ID
- (void)loadMoreUserDetailUsersId:(NSString *)usersId
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (usersId) {
        [parameters setObject:usersId forKey:@"ids"];
    }else{
        [parameters setObject:@"" forKey:@"ids"];
    }
    NSString *URLString = [self getURLbyKey:URL_MoreUserDetail];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

- (void)loadPayUserId:(NSString *)userId payType:(NSString *)payType payment:(NSString *)payment productId:(NSString *)productId number:(NSString *)number success:(void (^)(NSDictionary *))success fail:(void (^)(NSString *))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        [parameters setObject:userId forKey:@"userId"];
    }else{
        [parameters setObject:@"" forKey:@"userId"];
    }
    if (payType) {
        [parameters setObject:payType forKey:@"payType"];
    }else{
        [parameters setObject:@"" forKey:@"payType"];
    }
    if (payment) {
        [parameters setObject:payment forKey:@"payment"];
    }else{
        [parameters setObject:@"" forKey:@"payment"];
    }
    if (productId) {
        [parameters setObject:productId forKey:@"productId"];
    }else{
        [parameters setObject:@"" forKey:@"productId"];
    }
    if (number) {
        [parameters setObject:number forKey:@"number"];
    }else{
        [parameters setObject:@"" forKey:@"number"];
    }
    NSString *URLString = [self getURLbyKey:URL_PayJinBao];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

- (void)loadReturnJifengUserId:(NSString *)userId
                       payment:(NSString *)payment
                     productId:(NSString *)productId
                        number:(NSString *)number
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        [parameters setObject:userId forKey:@"userId"];
    }else{
        [parameters setObject:@"" forKey:@"userId"];
    }
    if (payment) {
        [parameters setObject:payment forKey:@"payment"];
    }else{
        [parameters setObject:@"" forKey:@"payment"];
    }
    if (productId) {
        [parameters setObject:productId forKey:@"productId"];
    }else{
        [parameters setObject:@"" forKey:@"productId"];
    }
    if (number) {
        [parameters setObject:number forKey:@"number"];
    }else{
        [parameters setObject:@"" forKey:@"number"];
    }
    NSString *URLString = [self getURLbyKey:URL_ReturnJifen];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

- (void)loadGiftUserId:(NSString *)userId
            GiftNumber:(NSString *)giftNumber
               success:(void (^)(NSDictionary *resultDic))success
                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        [parameters setObject:userId forKey:@"userId"];
    }else{
        [parameters setObject:@"" forKey:@"userId"];
    }
    if (giftNumber) {
        [parameters setObject:giftNumber forKey:@"giftNumber"];
    }else{
        [parameters setObject:@"" forKey:@"giftNumber"];
    }
    NSString *URLString = [self getURLbyKey:URL_Gift];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

- (void)loadUserCommentUserId:(NSString *)userId
                      goodsId:(NSString *)goodsId
               commentContent:(NSString *)commentContent
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (userId) {
        [parameters setObject:userId forKey:@"userId"];
    }else{
        [parameters setObject:@"" forKey:@"userId"];
    }
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"goodsId"];
    }else{
        [parameters setObject:@"" forKey:@"goodsId"];
    }
    if (commentContent) {
        [parameters setObject:commentContent forKey:@"commentContent"];
    }else{
        [parameters setObject:@"" forKey:@"commentContent"];
    }
    NSString *URLString = [self getURLbyKey:URL_UserComment];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 查看夺宝号码
 *
 */
- (void)loadDuoBaoLuckNumWithGoodsId:(NSString *)goods_fight_id
                             user_id:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_LoadDuoBaoLuckNum];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 获取往期揭晓数据
 *
 */
- (void)getOldDuoBaoDataWithGoodsId:(NSString *)good_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (good_id) {
        [parameters setObject:good_id forKey:@"good_id"];
    }else{
        [parameters setObject:@"" forKey:@"good_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetOldDuoBaoData];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


-(void)getZoushi:(NSString *)good_id pageNum:(NSString *)pageNum limitNum:(NSString *)limitNum success:(void (^)(NSDictionary *))success fail:(void (^)(NSString *))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (good_id) {
        [parameters setObject:good_id forKey:@"good_id"];
    }else{
        [parameters setObject:@"" forKey:@"good_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetZoushi];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 查询是否有某期夺宝
 *
 */
- (void)queryPeriodWithGoodsId:(NSString *)good_id
                   good_period:(NSString *)good_period
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (good_id) {
        [parameters setObject:good_id forKey:@"good_id"];
    }else{
        [parameters setObject:@"" forKey:@"good_id"];
    }
    
    if (good_period) {
        [parameters setObject:good_period forKey:@"good_period"];
    }else{
        [parameters setObject:@"" forKey:@"good_period"];
    }
    
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_QueryPeriod];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 最新揭晓
/**
 * 获取最新揭晓数据
 *
 */
- (void)getZXJXWithPageNum:(NSString *)pageNum
                  limitNum:(NSString *)limitNum
                   success:(void (^)(NSDictionary *resultDic))success
                      fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetZXJX];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 赚钱列表
/**
 * 赠钱列表
 * ,pageTab:标签类型[1.推荐,2.最新,3.热门]
 *
 */
- (void)getShareListWithUserId:(NSString *)user_id
                       pageTab:(NSString *)pageTab
                       PageNum:(NSString *)pageNum
                      limitNum:(NSString *)limitNum
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    if (pageTab) {
        [parameters setObject:pageTab forKey:@"pageTab"];
    }else{
        [parameters setObject:@"" forKey:@"pageTab"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetShareList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
 * 分享回调
 *
 */
- (void)getShareBackWithUserId:(NSString *)user_id
                       news_id:(NSString *)news_id
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (news_id) {
        [parameters setObject:news_id forKey:@"news_id"];
    }    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetShareBack];
   
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 晒单
/**
 * 晒单列表
 *
 */
- (void)queryZoneListWithGoodsId:(NSString *)goods_fight_id
                  target_user_id:(NSString *)target_user_id
                         pageNum:(NSString *)pageNum
                        limitNum:(NSString *)limitNum
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goods_fight_id) {
        [parameters setObject:goods_fight_id forKey:@"goods_fight_id"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_id"];
    }
    
    if (target_user_id) {
        [parameters setObject:target_user_id forKey:@"target_user_id"];
    }else{
        [parameters setObject:@"" forKey:@"target_user_id"];
    }
    
    if (pageNum) {
        [parameters setObject:pageNum forKey:@"pageNum"];
    }else{
        [parameters setObject:@"" forKey:@"pageNum"];
    }
    
    if (limitNum) {
        [parameters setObject:limitNum forKey:@"limitNum"];
    }else{
        [parameters setObject:@"" forKey:@"limitNum"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetZoneList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 晒单详情
 *
 */
- (void)queryZoneDetailInfoWithGoodsId:(NSString *)bask_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (bask_id) {
        [parameters setObject:bask_id forKey:@"bask_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetZoneDetail];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 晒单分享回调或者app分享回调
 *
 */
- (void)getShaiDanOrAppShareBackWithUserId:(NSString *)user_id
                                      type:(NSString *)type
                                 target_id:(NSString *)target_id
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    
    if (target_id) {
        [parameters setObject:target_id forKey:@"target_id"];
    }
    else
    {
        [parameters setObject:@"" forKey:@"target_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetShaiDanOrAppShareBack];
    [self performSelector:@selector(tongzhiweb:) withObject:nil afterDelay:0];
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}
-(void)tongzhiweb:(NSNotification *)change
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"fenxiangchenggong" object:nil];
}

#pragma mark - 购物车



/**
 * 添加购物车
 *
 */
- (void)addGoodsForShopCartWithUserId:(NSString *)user_id
                            goods_ids:(NSString *)goods_ids
                       goods_buy_nums:(NSString *)goods_buy_nums
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (goods_ids) {
        [parameters setObject:goods_ids forKey:@"goods_ids"];
    }
    if (goods_buy_nums) {
        [parameters setObject:goods_buy_nums forKey:@"goods_buy_nums"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_AddShopCart];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取购物车列表
 *
 */
- (void)getShopCartListWithUserId:(NSString *)user_id
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
   
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetShopCarList];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 获取支付隐藏
 */
-(void)GetPayType:(NSString *)user_id success:(void (^)(NSDictionary *))success fail:(void (^)(NSString *))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetPAYtype];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}


/**
  获取发现列表
 */
-(void)GetFindList:(NSString *)user_id success:(void (^)(NSDictionary *))success fail:(void (^)(NSString *))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetPAYtype];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
    
}
/*
 获取更新接口
 */
-(void)GetFresh:(NSString *)user_id success:(void (^)(NSDictionary *))success fail:(void (^)(NSString *))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetFresh];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 修改购物车商品
 *
 */
- (void)changeShopCartListInfoWithGoodsId:(NSString *)goodsId
                                 goodsNum:(NSString *)goods_buy_num
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsId) {
        [parameters setObject:goodsId forKey:@"id"];
    }
    
    if (goods_buy_num) {
        [parameters setObject:goods_buy_num forKey:@"goods_buy_num"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_ChangeShopCarListInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 删除购物车
 *
 */
- (void)deleteShopCartListInfoWithGoodsId:(NSString *)goodsIds
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (goodsIds) {
        [parameters setObject:goodsIds forKey:@"ids"];
    }
    
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_DeleteShopCart];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 支付

/**
 * 支付接口
 *
 */
- (void)payOfbuyGoodsWithPayType:(NSString *)payType
                 goods_fight_ids:(NSString *)goods_fight_ids
                  goods_buy_nums:(NSString *)goods_buy_nums
                    is_shop_cart:(NSString *)is_shop_cart
                         user_id:(NSString *)user_id
                  ticket_send_id:(NSString *)ticket_send_id
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (payType) {
        [parameters setObject:payType forKey:@"payType"];
    }else{
        [parameters setObject:@"" forKey:@"payType"];
    }
    
    if (goods_fight_ids) {
        [parameters setObject:goods_fight_ids forKey:@"goods_fight_ids"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_ids"];
    }
    
    if (goods_buy_nums) {
        [parameters setObject:goods_buy_nums forKey:@"goods_buy_nums"];
    }else{
        [parameters setObject:@"" forKey:@"goods_buy_nums"];
    }
    
    if (is_shop_cart) {
        [parameters setObject:is_shop_cart forKey:@"is_shop_cart"];
    }else{
        [parameters setObject:@"" forKey:@"is_shop_cart"];
    }
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }else{
        [parameters setObject:@"" forKey:@"user_id"];
    }
    
    if (ticket_send_id) {
        [parameters setObject:ticket_send_id forKey:@"ticket_send_id"];
    }else{
        [parameters setObject:@"" forKey:@"ticket_send_id"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_Pay];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取支付详情（获取商品）
 *
 */
- (void)getPayDetailInfoWithUserId:(NSString *)user_id
                   goods_fight_ids:(NSString *)goods_fight_ids
                    goods_buy_nums:(NSString *)goods_buy_nums
                      is_shop_cart:(NSString *)is_shop_cart
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    if (goods_fight_ids) {
        [parameters setObject:goods_fight_ids forKey:@"goods_fight_ids"];
    }
    if (goods_buy_nums) {
        [parameters setObject:goods_buy_nums forKey:@"goods_buy_nums"];
    }
    if (is_shop_cart) {
        [parameters setObject:is_shop_cart forKey:@"is_shop_cart"];
    }
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetPayDetailInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取订单号
 * 当order_type为充值时，goods_fight_ids和goods_buy_nums传空字符串
 * order_type:订单类型(订单/充值)
 *
 */
- (void)getOrderNoWithUserId:(NSString *)user_id
                   total_fee:(NSString *)total_fee
             goods_fight_ids:(NSString *)goods_fight_ids
              goods_buy_nums:(NSString *)goods_buy_nums
                  order_type:(NSString *)order_type
                   all_price:(NSString *)all_price
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (user_id) {
        [parameters setObject:user_id forKey:@"user_id"];
    }
    
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    
    if (goods_fight_ids) {
        [parameters setObject:goods_fight_ids forKey:@"goods_fight_ids"];
    }else{
        [parameters setObject:@"" forKey:@"goods_fight_ids"];
    }
    
    if (goods_buy_nums) {
        [parameters setObject:goods_buy_nums forKey:@"goods_buy_nums"];
    }else{
        [parameters setObject:@"" forKey:@"goods_buy_nums"];

    }
    
    
    if (order_type) {
        [parameters setObject:order_type forKey:@"order_type"];
    }
    
    if (all_price) {
        [parameters setObject:all_price forKey:@"all_price"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetOrderNo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

/**
 * 获取微信支付参数
 *
 */
- (void)getWeiXinPayInfoWithOrderNo:(NSString *)out_trade_no
                          total_fee:(NSString *)total_fee
                   spbill_create_ip:(NSString *)spbill_create_ip
                               body:(NSString *)body
                             detail:(NSString *)detail
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (out_trade_no) {
        [parameters setObject:out_trade_no forKey:@"out_trade_no"];
    }
    
    if (total_fee) {
        [parameters setObject:total_fee forKey:@"total_fee"];
    }
    
    if (spbill_create_ip) {
        [parameters setObject:spbill_create_ip forKey:@"spbill_create_ip"];
    }else{
        [parameters setObject:@"" forKey:@"spbill_create_ip"];
    }
    
    if (body) {
        [parameters setObject:body forKey:@"body"];
    }else{
        [parameters setObject:@"" forKey:@"body"];
    }
    
    
    if (detail) {
        [parameters setObject:detail forKey:@"detail"];
    }else{
        [parameters setObject:@"" forKey:@"detail"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetWeiXinPayInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];

}


/**
 * 获取爱贝支付参数
 *
 */
- (void)getIPayInfoWithOrderNo:(NSString *)out_trade_no
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (out_trade_no) {
        [parameters setObject:out_trade_no forKey:@"out_trade_no"];
    }
    
    //拼接:URL_Server+keyURL
    NSString *URLString = [self getURLbyKey:URL_GetIPayInfo];
    
    [self postHttpWithDic:parameters urlStr:URLString success:success fail:fail];
}

#pragma mark - 底层 post数据请求和图片上传
/**
 * Post请求数据
 */
- (void)postHttpWithDic:(NSMutableDictionary *)parameter
                 urlStr:(NSString *)urlStr
                success:(void (^)(NSDictionary *resultDic))success //成功
                   fail:(void (^)(NSString *description))fail      //失败
{
    //当前时间戳 单位毫秒
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *requestTime = [NSString stringWithFormat:@"%lld",recordTime];
    [parameter setObject:requestTime forKey:@"request_time"];
    
    NSArray *allkeys = [parameter allKeys];
    NSString *sign = nil;
    for (NSString *mkey in allkeys)
    {
        NSObject *value = [parameter objectForKey:mkey];
        if (!sign) {
            sign = [NSString stringWithFormat:@"%@",value];
        }else{
            sign = [NSString stringWithFormat:@"%@|$|%@",sign,value];
        }
    }
    NSString *str = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAESData:sign]];
    [parameter setObject:str forKey:@"sign"];
    
    NSData *jsParameters = [NSJSONSerialization dataWithJSONObject:parameter  options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *aString = [[NSString alloc] initWithData:jsParameters encoding:NSUTF8StringEncoding];
    //改动。第一句输出
   // NSLog(@"json = 11111111%@",aString);
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:aString forKey:@"param"];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"json2222222:%@",responseObject);
        if (success) {
            success((NSDictionary *)responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"网络请求失败了");
        }
    }];
}

/**
 * Post 上传图片
 */
- (void)postImageHttpWithImage:(UIImage*)image
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    
    
    //当前时间戳 单位毫秒
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *requestTime = [NSString stringWithFormat:@"%lld",recordTime];
    
    [parameter setObject:requestTime forKey:@"request_time"];
    NSArray *allkeys = [parameter allKeys];
    NSString *sign = nil;
    for (NSString *mkey in allkeys)
    {
        NSObject *value = [parameter objectForKey:mkey];
        if (!sign) {
            sign = [NSString stringWithFormat:@"%@",value];
        }else{
            sign = [NSString stringWithFormat:@"%@|$|%@",sign,value];
        }
    }
    NSString *str = [SecurityUtil encodeBase64Data:[SecurityUtil encryptAESData:sign]];
    [parameter setObject:str forKey:@"sign"];
    
    NSData *jsParameters = [NSJSONSerialization dataWithJSONObject:parameter  options:NSJSONWritingPrettyPrinted error:nil];
    NSString *aString = [[NSString alloc] initWithData:jsParameters encoding:NSUTF8StringEncoding];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:aString forKey:@"param"];
    [parameters setValue:[NSString stringWithFormat:@"%@",[ShareManager shareInstance].userinfo.id] forKey:@"id"];
    
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    NSString *URLString = [self getURLbyKey:URL_UpdateImageUrl];
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(image)
        {
            NSData *imageData = UIImageJPEGRepresentation(image,0.5);
            [formData appendPartWithFileData:imageData name:@"file" fileName:@"111.jpg" mimeType:@"image/jpg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success((NSDictionary *)responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (fail) {
            fail(@"网络请求失败了");
        }
    }];
    
}



/**
 *获取公共资源 get请求
 */

- (void)getHttpWithUrlStr:(NSString *)urlStr
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail
{
    NSString *URLString = [self getURLbyKey:urlStr];
    
    
    [self getHttpBaseQuestWithUrl:URLString success:success fail:fail];
}


- (void)getHttpBaseQuestWithUrl:(NSString *)urlstr
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail
{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [self postHttpWithDic:parameters urlStr:urlstr success:success fail:fail];
}

@end
