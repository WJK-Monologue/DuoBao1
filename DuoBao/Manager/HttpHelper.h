//
//  HttpHelper.h
//  DuoBao
//
//  Created by gthl on 16/2/11.
//  Copyright © 2016年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpHelper : NSObject

#pragma mark - common
/**
 *获取公共资源 get请求
 */

- (void)getHttpWithUrlStr:(NSString *)urlStr
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail;

#pragma mark - 登录、注册、找回密码

/**
 * 获取验证码
 */
- (void)getVerificationCodeByMobile:(NSString *)mobile
                               type:(NSString *)type
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;
/**
 * 注册
 */
- (void)registerByWithMobile:(NSString *)mobile
                    password:(NSString *)password
           recommend_user_id:(NSString *)recommend_user_id
                   auth_code:(NSString *)auth_code
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;
/**
 * 登录
 */
- (void)loginByWithMobile:(NSString *)mobile
                 password:(NSString *)password
                 jpush_id:(NSString *)jpush_id
                  success:(void (^)(NSDictionary *resultDic))success
                     fail:(void (^)(NSString *description))fail;

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
                           fail:(void (^)(NSString *description))fail;

/**
 * 找回密码
 */
- (void)findPwdByWithMobile:(NSString *)mobile
                   password:(NSString *)password
                  auth_code:(NSString *)auth_code
                    success:(void (^)(NSDictionary *resultDic))success
                       fail:(void (^)(NSString *description))fail;

/**
 * 第三方绑定
 */
- (void)bangDingByWithLoginId:(NSString *)app_login_id
                         type:(NSString *)type
                      url_tel:(NSString *)url_tel
                    auth_code:(NSString *)auth_code
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

#pragma mark - 首页、商品
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
                                 fail:(void (^)(NSString *description))fail;

/**
 * 获取分类下商品列表
 *
 */
- (void)getGoodsListOfTypeWithGoodsTypeIde:(NSString *)goodsTypeId
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail;

/**
 * 搜索商品
 *
 */
- (void)searchGoodsWithSearchKey:(NSString *)searchKey
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;


/**
 * 加载商品详情
 *
 */
- (void)loadGoodsDetailInfoWithGoodsId:(NSString *)goods_fight_id
                                userId:(NSString *)user_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;
//商品详情
- (void)loadProductsDetailInfoWithId:(NSString *)productid
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;
/**
 * 获取夺宝记录（参与夺宝的所以人）
 *
 */
- (void)loadDuoBaoRecordWithGoodsId:(NSString *)goods_fight_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;
//评论记录
- (void)loadCommentWithGoodsId:(NSString *)goodsId
                       pageNum:(NSString *)pageNum
                      limitNum:(NSString *)limitNum
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;
//中奖纪录
- (void)loadWinnerRecoardWithGoodsId:(NSString *)goodsId
                             pageNum:(NSString *)pageNum
                            limitNum:(NSString *)limitNum
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;
//用户详情
- (void)loadUserDetailUserId:(NSString *)userId
                             success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;
//多个用户详情
- (void)loadMoreUserDetailUsersId:(NSString *)usersId
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;
//猜拳支付
- (void)loadPayUserId:(NSString *)userId
              payType:(NSString *)payType
              payment:(NSString *)payment
            productId:(NSString *)productId
               number:(NSString *)number
              success:(void (^)(NSDictionary *resultDic))success
                 fail:(void (^)(NSString *description))fail;;
//归还积分
- (void)loadReturnJifengUserId:(NSString *)userId
                      payment:(NSString *)payment
                     productId:(NSString *)productId
                        number:(NSString *)number
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;
//礼物
- (void)loadGiftUserId:(NSString *)userId
            GiftNumber:(NSString *)giftNumber
               success:(void (^)(NSDictionary *resultDic))success
                  fail:(void (^)(NSString *description))fail;
//用户评论URL_UserComment
- (void)loadUserCommentUserId:(NSString *)userId
                     goodsId:(NSString *)goodsId
               commentContent:(NSString *)commentContent
               success:(void (^)(NSDictionary *resultDic))success
                  fail:(void (^)(NSString *description))fail;
//晒单
-(void)loadProductdetailproductId:(NSString *)productId
                          pageNum:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 查看夺宝号码
 *
 */
- (void)loadDuoBaoLuckNumWithGoodsId:(NSString *)goods_fight_id
                             user_id:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;

/**
 * 获取往期揭晓数据
 *
 */
- (void)getOldDuoBaoDataWithGoodsId:(NSString *)good_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;

/**
 * 查询是否有某期夺宝
 *
 */
- (void)queryPeriodWithGoodsId:(NSString *)good_id
                   good_period:(NSString *)good_period
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

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
                            fail:(void (^)(NSString *description))fail;

/**
 * 晒单详情
 *
 */
- (void)queryZoneDetailInfoWithGoodsId:(NSString *)bask_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;

/**
 * 晒单分享回调或者app分享回调
 *
 */
- (void)getShaiDanOrAppShareBackWithUserId:(NSString *)user_id
                                      type:(NSString *)type
                                 target_id:(NSString *)target_id
                                   success:(void (^)(NSDictionary *resultDic))success
                                      fail:(void (^)(NSString *description))fail;

#pragma mark - 购物车


/**
 * 添加购物车
 *
 */
- (void)addGoodsForShopCartWithUserId:(NSString *)user_id
                            goods_ids:(NSString *)goods_ids
                       goods_buy_nums:(NSString *)goods_buy_nums
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

/**
 * 获取购物车列表
 *
 */
- (void)getShopCartListWithUserId:(NSString *)user_id
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 修改购物车商品
 *
 */
- (void)changeShopCartListInfoWithGoodsId:(NSString *)goodsId
                                 goodsNum:(NSString *)goods_buy_num
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail;

/**
 * 删除购物车
 *
 */
- (void)deleteShopCartListInfoWithGoodsId:(NSString *)goodsIds
                                  success:(void (^)(NSDictionary *resultDic))success
                                     fail:(void (^)(NSString *description))fail;

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
                            fail:(void (^)(NSString *description))fail;

/**
 * 获取支付详情
 *
 */
- (void)getPayDetailInfoWithUserId:(NSString *)user_id
                   goods_fight_ids:(NSString *)goods_fight_ids
                    goods_buy_nums:(NSString *)goods_buy_nums
                      is_shop_cart:(NSString *)is_shop_cart
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;

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
                        fail:(void (^)(NSString *description))fail;

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
                               fail:(void (^)(NSString *description))fail;

/**
 * 获取爱贝支付参数
 *
 */
- (void)getIPayInfoWithOrderNo:(NSString *)out_trade_no
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;


#pragma mark - 我的

/**
 * 获取大转盘的大奖历史
 */
- (void)getRotaryGameHistoryWithPageNum:(NSString *)pageNum
                               limitNum:(NSString *)limitNum
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail;

/**
 * 签到
 */
- (void)userSignWithUserId:(NSString *)user_id
                   success:(void (^)(NSDictionary *resultDic))success
                      fail:(void (^)(NSString *description))fail;

/**
 * 获取用户信息
 */
- (void)getUserInfoWithUserId:(NSString *)user_id
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

/**
 * 收获地址列表
 */
- (void)receiveAddressListWithUserId:(NSString *)user_id
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;

/**
 * 修改默认地址
 */
- (void)changeDefaultAddressWithUserId:(NSString *)user_id
                             addressId:(NSString *)addressId
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;

/**
 *添加我的收获地址
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
                        fail:(void (^)(NSString *description))fail;

/**
 * 获取城市列表
 */
- (void)getCityInfoWithProvinceId:(NSString *)provinceId
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 删除地址
 */
- (void)deleteAddressWithAddressId:(NSString *)addressId
                           success:(void (^)(NSDictionary *resultDic))success
                              fail:(void (^)(NSString *description))fail;

/**
 * Post 上传图片
 */
- (void)postImageHttpWithImage:(UIImage*)image
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

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
                            fail:(void (^)(NSString *description))fail;

/**
 * 获取系统消息
 */
- (void)getSystemMessageWithPageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                             userId:(NSString *)userId
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;

/**
 * 获取夺宝记录
 * status: 夺宝状态[全部、已揭晓、进行]
 */
- (void)getDuoBaoRecordWithUserid:(NSString *)user_id
                           status:(NSString *)status
                          pageNum:(NSString *)pageNum
                         limitNum:(NSString *)limitNum
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 我的中奖记录
 */
- (void)getZJRecordWithUserid:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

/**
 * 修改订单地址
 */
- (void)changeOrderAddressWithOrderId:(NSString *)orderId
                       consignee_name:(NSString *)consignee_name
                        consignee_tel:(NSString *)consignee_tel
                    consignee_address:(NSString *)consignee_address
                              success:(void (^)(NSDictionary *resultDic))success
                                 fail:(void (^)(NSString *description))fail;

/**
 * 发布晒单
 */
- (void)publicShaiDanWithUserId:(NSString *)user_id
                 goods_fight_id:(NSString *)goods_fight_id
                          title:(NSString *)title
                        content:(NSString *)content
                           imgs:(NSString *)imgs
                        success:(void (^)(NSDictionary *resultDic))success
                           fail:(void (^)(NSString *description))fail;

/**
 * 积分流水
 * type:类型[1.积分列表，2.夺宝币列表]
 */
- (void)getPointDetailInfoWithUserId:(NSString *)user_id
                                type:(NSString *)type
                             pageNum:(NSString *)pageNum
                            limitNum:(NSString *)limitNum
                             success:(void (^)(NSDictionary *resultDic))success
                                fail:(void (^)(NSString *description))fail;

/**
 * 获取积分兑换所需数据
 */
- (void)getPointDHWithUserId:(NSString *)user_id
                     success:(void (^)(NSDictionary *resultDic))success
                        fail:(void (^)(NSString *description))fail;

/**
 * 积分兑换
 * exchange_type:兑换类型[real(人民币),virtual(夺宝币)]
 */
- (void)putPointExchangeApplyWithUserId:(NSString *)user_id
                          exchange_type:(NSString *)exchange_type
                              pay_score:(NSString *)pay_score
                                success:(void (^)(NSDictionary *resultDic))success
                                   fail:(void (^)(NSString *description))fail;

/**
 * 邀请好友基本数据
 */
- (void)getInviteFriendsInfoWithUserId:(NSString *)user_id
                               success:(void (^)(NSDictionary *resultDic))success
                                  fail:(void (^)(NSString *description))fail;

/**
 * 邀请好友列表
 * level: 好友层级[1,2,3]
 */
- (void)getFriendsByLevelWithUserId:(NSString *)user_id
                              level:(NSString *)level
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;


/**
 * 获取优惠券
 * type:类型[1.未使用，2.已使用/失效]
 */
- (void)getCouponsListWithUserId:(NSString *)user_id
                            type:(NSString *)type
                         pageNum:(NSString *)pageNum
                        limitNum:(NSString *)limitNum
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;

/**
 * 兑换优惠券
 */
- (void)exchangeCouponsWithUserId:(NSString *)user_id
                        couponsId:(NSString *)couponsId
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 * 获取等级说明
 */
- (void)getMyLevelInfoWithUserId:(NSString *)user_id
                         success:(void (^)(NSDictionary *resultDic))success
                            fail:(void (^)(NSString *description))fail;

/**
 * 获取充值记录
 */
- (void)getCZRecordWithUserId:(NSString *)user_id
                      pageNum:(NSString *)pageNum
                     limitNum:(NSString *)limitNum
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;

/**
 * 充值
 * type:[weixin/zhifubao]
 */
- (void)payCZWithUserId:(NSString *)user_id
                  money:(NSString *)money
                typeStr:(NSString *)typeStr
                success:(void (^)(NSDictionary *resultDic))success
                   fail:(void (^)(NSString *description))fail;


/**
 * 意见反馈
 */
- (void)putFeedBackWithUserId:(NSString *)user_id
                      content:(NSString *)content
                      success:(void (^)(NSDictionary *resultDic))success
                         fail:(void (^)(NSString *description))fail;



#pragma mark - 最新揭晓
/**
 * 获取最新揭晓数据
 *
 */
- (void)getZXJXWithPageNum:(NSString *)pageNum
                  limitNum:(NSString *)limitNum
                   success:(void (^)(NSDictionary *resultDic))success
                      fail:(void (^)(NSString *description))fail;

/**
 * 分享回调
 *
 */
- (void)getShareBackWithUserId:(NSString *)user_id
                       news_id:(NSString *)news_id
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

#pragma mark - 赚钱列表
/**
 * 赠钱列表
 *
 */
- (void)getShareListWithUserId:(NSString *)user_id
                       pageTab:(NSString *)pageTab
                       PageNum:(NSString *)pageNum
                      limitNum:(NSString *)limitNum
                       success:(void (^)(NSDictionary *resultDic))success
                          fail:(void (^)(NSString *description))fail;

/**
 获取支付隐藏
 */
- (void)GetPayType:(NSString *)user_id
                          success:(void (^)(NSDictionary *resultDic))success
                             fail:(void (^)(NSString *description))fail;

/**
 获取发现列表
 */
- (void)GetFindList:(NSString *)user_id
           success:(void (^)(NSDictionary *resultDic))success
              fail:(void (^)(NSString *description))fail;

/**
 获取更新接口
 */
-(void)GetFresh:(NSString *)user_id
 success:(void (^)(NSDictionary *resultDic))success
 fail:(void (^)(NSString *description))fail;

/**
 获取走势图
 */
- (void)getZoushi:(NSString *)good_id
                            pageNum:(NSString *)pageNum
                           limitNum:(NSString *)limitNum
                            success:(void (^)(NSDictionary *resultDic))success
                               fail:(void (^)(NSString *description))fail;
@end