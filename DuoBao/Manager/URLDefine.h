//
//  URLDefine.h
//  Esport
//
//  Created by linqsh on 15/5/12.
//  Copyright (c) 2015年 linqsh. All rights reserved.
//

#import <Foundation/Foundation.h>
/*** Server URL ***/

//自己的接口
//#define URL_Server @"http://119.23.144.229:51001/GetTreasureWw/"

//http://192.168.1.11:8080/GetTreasureWw/  本地的接口
//http://119.23.144.229:51001/GetTreasureWw/  阿里云的接口
//改动之前的接口
//#define URL_ShareServer @"http://119.23.144.229:51001/GetTreasureWw/"

#define URL_Server @"http://192.168.1.118:8080/GetTreasureWw/"
#define URL_ShareServer @"http://192.168.1.118:8080/GetTreasureWw/"

#define URL_IP @"192.168.1.118"  //socket

//标记 。 与后台交互的接口

//图片地址
#define URL_UpdateImageUrl @"appInterface/uploadImg.jhtml"

//上架接口，判断是否隐藏第三方登录
#define URL_GetIsSJ @"appInterface/getStaticData.jhtml"

#pragma mark  wap地址
//大转盘
#define Wap_RotaryGameUrl @"appInterface/rotaryGame.jhtml?"

//赚钱帮助页面
#define Wap_HelpUrl @"appInterface/newHelpIndexInfo.jhtml"

//关于我们
#define Wap_AboutDuobao @"appInterface/aboutUsContentInfo.jhtml?"

//分享app
#define Wap_ShareDuobao @"appInterface/showShareContent.jhtml?"

//常见问题
#define Wap_CJWT @"appInterface/commonProblemInfo.jhtml"

//计算详情
#define Wap_JSXQ @"appInterface/countInfo.jhtml?"

//跳转支付页面
#define Wap_PayMoneyView @"appInterface/paymentGoodsFightIndex.jhtml?"

#pragma mark  登录注册模块

//获取验证码
#define URL_GetVerificationCode @"appInterface/getCode.jhtml"

//注册
#define URL_Register @"appInterface/register.jhtml"

//登陆
#define URL_Login @"appInterface/userLogin.jhtml"

//第三方登陆
#define URL_ThirdLogin @"appInterface/otherRegister.jhtml"

//找回密码
#define URL_FindPwd @"appInterface/updateUserPassword.jhtml"

//第三方绑定接口
#define URL_BangDing @"appInterface/otherUserFirstLogin.jhtml"

#pragma mark  首页 商品
//获取首页数据
#define URL_GetHomePageData @"appInterface/getIndexDataAll.jhtml"

//改动接口  新增热门商品
#define  URL_GetHotProduct @"appInterface/appProduct/getIsHotProduct.jhtml"

//获取首页数据
//#define URL_GetGoodsInfoList @"appInterface/getIndexGoodsList.jhtml"
//改动接口  首页数据  商品
#define URL_GetGoodsInfoList @"appInterface/appProduct/getAllProduct.jhtml"

//获取分类数据
#define URL_GetGoodsType @"appInterface/getGoodsTypeData.jhtml"

//获取分类下商品列表
#define URL_GetGoodsListOfType @"appInterface/getGoodsTypeList.jhtml"

//获取热门搜索
#define URL_GetHotSearchData @"appInterface/getHotSearchData.jhtml"

//搜索商品
#define URL_SearchGoodsInfo @"appInterface/getGoodsSearchList.jhtml"

//加载商品详情
//#define URL_LoadGoodsDetailInfo @"appInterface/getGoodsInfoData.jhtml"
//改动接口 商品详情
#define URL_LoadGoodsDetailInfo @"appInterface/appProduct/getProductDetails.jhtml"
//改动  新增接口 评论
#define URL_CommentsProductsInfo @"appInterface/appProduct/getTGoodsComment.jhtml"
//改动  新增接口  中奖纪录
#define URL_WinnerRecord @"appInterface/appProduct/getTWinRecord.jhtml"
//改动  新增接口  用户详情
#define URL_UserDetail @"appInterface/appProduct/getLoginUser.jhtml"
//改动  新增接口  多个ID用户详情
#define URL_MoreUserDetail @"appInterface/appProduct/getAllLoginUser.jhtml"
//改动  新增接口  猜拳支付
#define URL_PayJinBao @"appInterface/appCqjbPay/paymentTProduct.jhtml"
//改动  新增接口  退赛还积分
#define URL_ReturnJifen @"appInterface/appCqjbPay/paymentRefund.jhtml"
//改动  新增接口  礼物
#define URL_Gift @"appInterface/appCqjbPay/payGiftPrice.jhtml"
//改动  新增接口  用户评论
#define URL_UserComment @"appInterface/appProduct/setTGoodsComment.jhtml"
//改动  新增接口  晒单列表
#define URL_ShaiDanList @"appInterface/cqjbGoodsBaskList.jhtml"

//加载夺宝记录
#define URL_LoadDuoBaoRecord @"appInterface/getFightRecordList.jhtml"

//查看夺宝号码
#define URL_LoadDuoBaoLuckNum @"appInterface/getMoreFightNum.jhtml"

//获取往期揭晓数据
#define URL_GetOldDuoBaoData @"appInterface/getHistoryGoodsFightList.jhtml"

//获取走势图
#define URL_GetZoushi @"appInterface/getHistoryGoodsFightListChart.jhtml"

//查询是否有某期夺宝
#define URL_QueryPeriod @"appInterface/getGoodsFightIdByPeriod.jhtml"

#pragma mark - 晒单

//晒单列表
#define URL_GetZoneList @"appInterface/getBaskList.jhtml"

//晒单分享详情
#define URL_GetZoneDetail @"appInterface/getBaskContent.jhtml"

//晒单分享回调或者app分享回调
#define URL_GetShaiDanOrAppShareBack @"appInterface/shareReturn.jhtml"

#pragma mark -  支付

//支付
#define URL_Pay @"appInterface/appCqjbPay/paymentTProduct.jhtml"

//获取支付详情
#define URL_GetPayDetailInfo @"appInterface/getOrderIndexData.jhtml"

//获取订单号
#define URL_GetOrderNo @"appInterface/genOrder.jhtml"

//支付宝回调
#define URL_AllipayNotify  @"appInterface/allipay/appNotify.jhtml"

//获取微信支付参数
#define URL_GetWeiXinPayInfo  @"appInterface/unifiedorder.jhtml"

//获取爱贝支付参数
#define URL_GetIPayInfo  @"appInterface/apayUnifiedorder.jhtml"

#pragma mark - 购物车

//添加购物车
#define URL_AddShopCart @"appInterface/addShopCart.jhtml"

//获取购物车列表
#define URL_GetShopCarList @"appInterface/getShopCartList.jhtml"

//修改购物车商品
#define URL_ChangeShopCarListInfo @"appInterface/updateShopCart.jhtml"

//删除购物车
#define URL_DeleteShopCart @"appInterface/delShopCart.jhtml"

#pragma mark  － 最新揭晓

//获取最新揭晓
#define URL_GetZXJX @"appInterface/getWillDoGoodsList.jhtml"

#pragma mark  － 赠钱
//挣钱列表
#define URL_GetShareList @"appInterface/getFindList.jhtml"

//获取支付类型
#define URL_GetPAYtype @"appInterface/getPayTypeList.jhtml"

//获取发现列表
#define URL_GetFindList @"appInterface/getFindList.jhtml"

//获取更新接口
#define URL_GetFresh @"appInterface/getRepairInform.jhtml"

//分享后回调
#define URL_GetShareBack @"appInterface/saveNewsShare.jhtml"

#pragma mark  我的

//获取大转盘的大奖历史
#define URL_GetRotaryGameHistory @"appInterface/getRotaryGameHistory.jhtml"

//签到
#define URL_Sign @"appInterface/signIn.jhtml"

//获取用户信息
#define URL_GetUserInfo @"appInterface/getUserData.jhtml"

//获取收货地址列表
#define URL_GetAdressList @"appInterface/getUserAddressListData.jhtml"

//修改默认地址接口
#define URL_ChangeDefaultAddress @"appInterface/changeDefaultAddress.jhtml"

//新增收货地址
#define URL_AddAddress @"appInterface/saveAddress.jhtml"

//获取城市列表
#define URL_GetCityInfo @"appInterface/getCityByProvince.jhtml"

//删除地址
#define URL_DeleteMyAddress @"appInterface/delAddress.jhtml"

//修改用户信息
#define URL_ChangeUserInfo @"appInterface/updateUser.jhtml"

//获取系统消息
#define URL_SystemMessage @"appInterface/getMessageInfoList.jhtml"

//夺宝记录
#define URL_GetDuoBaoRecordList @"appInterface/getFightRecordInfoList.jhtml"

//中奖记录
#define URL_GetZJRecord @"appInterface/getFightWinRecordList.jhtml"

//修改中奖地址
#define URL_ChangeOrderAddress @"appInterface/saveOrderAddress.jhtml"

//发布晒单
#define URL_PublishFightBask @"appInterface/publishFightBask.jhtml"

//积分流水
#define URL_GetPointDetailInfo @"appInterface/getScoreOrMoneyHistoryList.jhtml"

//积分页面所需数据
#define URL_GetTXPoundage @"appInterface/getExchangeData.jhtml"

//积分兑换
#define URL_PointExchange @"appInterface/exchangeInMoney.jhtml"

//邀请好友基本数据
#define URL_InviteFriendsInfo @"appInterface/friendsInfo.jhtml"

//获取好友列表
#define URL_GetFriendsByLevel @"appInterface/getFriendsByLevel.jhtml"

//获取优惠券列表
#define URL_GetCouponList @"appInterface/getMyTicketList.jhtml"

//兑换优惠券
#define URL_ExchangeCouponList @"appInterface/addTicketById.jhtml"

//任务大厅
#define URL_TaskList @"appInterface/taskIndex.jhtml"

//等级说明
#define URL_GetMyLevelInfo @"appInterface/getUserLevelInfoData.jhtml"

//充值记录
#define URL_GetCZReord @"appInterface/getMyAlreadyPayList.jhtml"

//充值接口
#define URL_PayCZ @"appInterface/rechargeInMoney.jhtml"

//意见反馈
#define URL_Feedback @"appInterface/saveSuggest.jhtml"



@interface URLDefine : NSObject

@end
