//
//  Global_Url.h
//  jiuhaohealth4.1
//
//  Created by xjs on 15/9/9.
//  Copyright (c) 2015年 xuGuohong. All rights reserved.
//

#ifndef jiuhaohealth4_1_Global_Url_h
#define jiuhaohealth4_1_Global_Url_h


#define SERVER_URL @"http://v4.api.kangxun360.com"



#define Share_Server_URL             @"http://wx.kangxun360.com/static/share_kangxun360/"
#define NOTICE_DETAIL_URL			@"http://admin.kangxun360.com/"



#define HEALP_SERVER_DAYINFO @"http://dict-mobile.iciba.com/new/index.php?mod=infor&act=showInforContent&cid=" //资讯说明
#define HEALP_SERVER_baseSource @"http://cdn.iwordnet.com/content_edit/source/article/volumn/" //lrc和MP3
#define HEALP_SERVER_basePic @"http://cdn.iwordnet.com/content_edit/source/article/files/" //pic

#define HEALP_SERVER_AdUrl @"http://dwz.cn/" //广告
#define HEALP_SERVER_youku @"http://v.youku.com/v_show/id_" //优酷
#define HEALP_SERVER_bmob @"http://file.bmob.cn/" //bmob

#define REQUEST_PAGE_NUM @"20"

//七牛下载图片前缀
#define QINIUURL @"http://7mnn49.com2.z0.glb.clouddn.com/"
//#define QINIUURL1 @"http://7mnn49.com2.z0.glb.clouddn.com"


//发送消息到服务器
#define UploadUserTokenId   @"/user/uploaduserTokenid"

//查有没有新版本
#define versioncheck_xhtml @"/app/versioncheck.xhtml"

/* 热线电话  */
#define HOTLINEPHONE @"781998178"


//发送验证第三方第三方登录绑定手机号第一步接口说明
#define SEND_THIRD_STEP_ONE @"/user/thirdAccountBindPhoneStep1.xhtml"

//发送验证第三方第三方登录绑定手机号第二步接口说明
#define SEND_THIRD_STEP_TWO @"/user/thirdAccountBindPhoneStep2.xhtml"

//发送验证第三方第三方登录绑定手机号第三步接口说明
#define SEND_THIRD_STEP_THREE @"/user/thirdAccountBindPhoneStep3.xhtml"

//修改用户信息
#define UPDATE_USER_INFO @"/user/mod.xhtml"

//首页
#define GET_HOME_DATA @"/news/getHomeNews.xhtml"

//判断是否第一次进入配餐
#define GET_JUDGE_CATERING @"/food/getCheckUserBasicInfo.xhtml"

//获取个人基本信息
#define GET_PERSONAL_BASIC @"/food/getUserActivityInfo.xhtml"

//添加家庭成员
#define ADD_FAMILY @"/api/user/info/family/add"

//顾问信息
#define SHOW_CONSULT_INFO @"/doctor/getDoctorDetailByid.xhtml"

//获取广告数据
#define GET_ADVERT_LIST @"/advert/getAdvert.xhtml"

//获取所有的话题
#define GET_ALL_POST_LIST @"/post/getAllPostList.xhtml"

//获取某个医生下班所有的帖子
#define GET_POSTLISTBYDOCTORID @"/post/getPostListByDoctorid.xhtml"

//更新本地数据库
#define UPDATE_DATA_DB @"/applocallib/sync.xhtml"

//统计
#define Send_Log @"/logger/sendLog.xhtml"

//会员申请接口
#define applyBind_XHTML @"/applyBind/user/applyBind.xhtml"

//后台启动获取积分
#define getPointsByChannel @"/point/getPointsByChannel.xhtml"

//获取商铺列表
#define URL_getCommunityList @"/api/group/getGroupList"


#pragma make ---
//获取token
#define GET_QINIU_TOKEN @"/api/tertiary/getQiNiuToken"


//设置首页各个模块的顺序
#define SET_HOME_SEQUENCE @"/news/setHomeSequence.xhtml"

//获得用户信息
#define GETUSERINFO @"/assistant/home/getAssistantInfoByAssistantid/"

/* 获取好友信息 */
#define GET_FRIENDDETAIL @"/docapp/getUserInfoByQrCode.xhtml"

//点赞
#define GET_ADDPRAISE_BY_DETAIL @"/hug/addHug.xhtml"

//取消点赞
#define GET_DELAGATEPRAISE_BY_DETAIL @"/hug/delHug.xhtml"

//删除消息
#define GET_MYMESSAGEDELETE_BY_ID @"/mymessage/deleteByid.xhtml"

//消息标记以读
#define GET_UPDATEMYMESSAGE_BY_ID @"/mymessage/updateToRead.xhtml"

//意见反馈
#define FEEDBACK_BY_USERID @"/api/feedback/add"


/**
 *  新闻接口
 */

#define NEWS_List @"/news/getNewsList.xhtml"
#define NEWS_Detail @"/news/getNewsByid.xhtml"
#define NEWS_Title @"/news/getSubfieldList.xhtml"

//新闻广告
#define NEWS_Advertising @"/news/getNewsAdvert.xhtml"

/**
 *  话题接口
 *
 */
#define Get_One_Expert_Topic_List @"/theme/getThemeDetailsList.xhtml"

/**
 *  我的信箱接口
 */
//系统信息详细
#define SystemDetail @"/sysmsg/view/"

#define GetDiaryHistory @"/api/record/statistics"

// 记一下
#define FAMILY_List @"/family/list.xhtml"

// 饮食推荐首页接口
#define GET_FOODHOME @"/food/getFoodHome.xhtml"

// 每日饮食推荐详情
#define GET_FOODHOME_DETAIl @"/food/foodsRecommendedDaily.xhtml"

//订阅期数
#define GETPROGRESS_PLAN_BY_ID @"/planuser/planListInfo.xhtml"


//订阅或取消订阅
#define SUBSCRIBE_PLAN_BY_ID @"/planuser/subscribe.xhtml"

//订阅人数
#define PERPLOE_PLAN_BY_ID @"/planuser/planUserCount.xhtml"

//查看评论列表接口说明
#define GET_COMMONTLIST @"/discuss/getDiscussListByid.xhtml"

//评论人
#define SEND_COMMONTTOPERSON @"/discuss/addDiscussDetail.xhtml"

//点赞接口
#define SEND_SUPPORT @"/hug/addHug.xhtml"

//获取我得设备
#define Get_MYDEVICE_List_Count @"/api/user/info/device/list"

//设备绑定更换用户
#define Update_MYDEVICE @"/user/changeDeviceBind.xhtml"

//获取我得设备
#define Get_DELEGATEMYDEVICE_List_Count @"/user/delMyDevice.xhtml"

//获取我得进餐时段
#define Get_DINNERTIME_List_Count @"/user/getUserEatTime.xhtml"

/**
 *  运动接口
 */

//解绑PK对象
#define RemovePKRelation @"/pedometer/relievePK.xhtml"

//PK挑战书jiekou
#define GetLetterOfChallenge @"/api/pedometer/getChallengeBookDetail"

//挑战同意、拒绝
#define UpdateChallenge @"/pedometer/updateChallenge.xhtml"

//解除pk
#define RemovePK @"/pedometer/removePK.xhtml"

#define GetFriendInfo  @"/user/getUserFriendDetailByid.xhtml"

//解除好友关系
#define kRemoveFriend @"/api/friend/removeFriend"

//帖子列表
#define GetGroupPostList  @"/api/group/getGroupPostList"

//关注圈子
#define  JoinGroupRequest @"/api/group/joinGroup"

//获得圈子信息
#define  GetGroupInfo @"/api/group/getGroupInfo"

//应战
#define ConfirmChallengeRequest @"/api/pedometer/confirmChallenge"
//拒绝
#define RefuseChallengeRequest @"/api/pedometer/refuseChallenge"

//发起PK
#define LaunchPK  @"/api/pedometer/challenge"

//PK列表
#define GetStepPKList @"/api/pedometer/getJoinedChallenges"

//糖友档案
#define GetStepUserInfo @"/api/pedometer/getPedometerInfo"

//日排名
#define GetTopListForDay @"/api/pedometer/getDailyRank"

//走走团
//---全部列表
#define GetALLGGTList  @"/api/pedometer/getAllActivity"

//获取团信息
#define GetTInfo  @"/api/pedometer/getActivityInfo"

//获取团成员列表
#define GetTMemList @"/api/pedometer/getActivityMember"

//我的团列表
#define GetMyGGTList  @"/api/pedometer/getAllActivityByAccount"

//加入团
#define AddTeamMem @"/api/pedometer/joinActivityApply"

//退出团
#define DeleteTeamFromMyList @"/api/pedometer/exitActivity"

//获得排名
#define GetTopList @"/api/pedometer/getTotalRank"

//查询异常设备接口
#define CheckExceptionPedometer  @"/api/pedometer/checkTodayDeviceNo"

//上传数据接口
#define StepDataUploadRequest @"/api/pedometer/upload"

//切换设备接口
#define AlterDeviceNo @"/api/pedometer/updateTodayDeviceNo"

//计步明细
#define GetPedometerItem @"/api/pedometer/getPedometerHistory"

//最近血糖开关
#define BSValueSwitch @"/api/pedometer/triggerShowSwitch"

//获得规则和积分
#define GetRuleAndPoint @"/api/pedometer/getChallengeRule"

//查找注册好友
#define QueryRegisterFriend  @"/api/user/rel/view"



//5.13. 详细查询
#define kGetRecordDetail @"/api/record/detail"

//5.13.	获取用户记录
#define kGetUserRecord @"/api/record/getUserHistoryRecord"

//5.9.	获取帖子列表
#define kGetGroupPostCommentsList @"/api/group/getGroupPostCommentsList"

//5.3.	用户帖子/评论点赞接口说明
#define kAddPostPraise @"/api/group/addPostPraise"

//5.11.	用户删除评论
#define kDelGroupPostComments @"/api/group/delGroupPostComments"

//5.7.	用户添加评论回复
#define kAddGroupPostCommentsReply @"/api/group/addGroupPostCommentsReply"

//5.6.	用户添加评论
#define kAddGroupPostComments @"/api/group/addGroupPostComments"

//5.13.	获取评论回复详情列表
#define kGetGroupPostCommentsReplyList @"/api/group/getGroupPostCommentsReplyList"

//5.4.	用户举报帖子
#define kReportPost @"/api/group/reportPost"

//发帖
#define ADDGROUP_POST_URL @"/api/group/addGroupPost"

//获取我的帖子
#define URL_getMyPost @"/api/group/getMyPost"

//5.13.	获取评论回复详情列表
#define kDelGroupPost @"/api/group/delGroupPost"


//获取首页
#define URL_getHomeList @"/api/home/index"

//签到
#define URL_checkin @"/api/continuous/addUserRegistration"

//医友

/* 添加好友 */
#define ADD_FRIEND_URL @"/api/friend/addFriendApply"

/* 获取好友申请列表 */
#define GET_FRIENDAPPLY_LIST @"/api/friend/getFriendApplyList"

/* 获取好友列表 */
#define GET_FRIEND_LIST @"/api/friend/getFriendList"

/* 接受好友请求 */
#define APPROVE_FRIEND_URL @"/api/friend/approveFriendApply"

/* 拒绝好友请求 */
#define REJICT_FRIEND_URL @"/api/friend/applyRejectById"

/* 删除好友 */
#define REMOVE_FRIEND_URL @"/api/friend/removeFriend"

/* 好友聊天 */
#define SEND_FRIEND_MSG @"/api/friend/sendChatMsg"

/* 获取好友聊天聊天记录 */
#define GET_FRIENDCHAT_MSG @"/api/friend/getChatMsgList"

/* 获取好友详情 */
#define GET_FRIEND_DATA @"/api/user/rel/view"

//获取好友申请列表
#define getFriendApplyList @"/api/friend/getFriendApplyList"

//	好友聊天
#define sendChatMsg @"/api/friend/sendChatMsg"

//	获取聊天记录
#define getChatMsgList @"/api/friend/getChatMsgList"

/* 修改好友备注信息 */
#define MODIFY_FRIEND @"/api/friend/updateCommentName"

//雷达获取糖友列表
#define FIND_FriendList @"/api/friend/scanFriend"

//查看医生详情
#define GET_DOCTOR_DATA @"/api/user/rel/view_doctor"

//查看个人信息详情
#define kGET_PedometerInfoHasActivity @"/api/pedometer/getPedometerInfoHasActivity"

//推送开关接口
#define SET_PUSH_OPEN_OR_CLOSE @"/api/user/info/config/m_field"


#pragma mark - 人个中心
//5.14.	获取用户信箱列表
#define URL_getBroadcastList @"/api/broadcast/getBroadcastList"

//1.1.	获取用户信箱详情
#define URL_getBroadcastDetail @"/api/broadcast/getBroadcastDetail"

//收藏
#define COLLECT_ADD_API @"/api/user/collect/add"

//取消收藏
#define COLLECT_REMOVE_API @"/api/user/collect/del"

//获取收藏列表
#define COLLECT_LIST_API @"/api/user/collect/list"

//获取积分和未读消息
#define GET_MSG_NOT_READ_COUNT @"/api/user/info/dynamic"

#pragma end

//查有没有新版本
#define URL_getCheck @"/api/version/check"

//5.30.	启动广告图接口
#define URL_getadv @"/api/ad/index"

#pragma mark - 新的概念 ------------------------------------------------------------------
//下载书籍
#define  kDownloadurl @"http://f1.m.hjfile.cn/resource/nce/android/all/NCE"

#define  KDownloadUKWordurl @"http://tts.yeshj.com/uk/s/"//英国

#define  KDownloadUSWordurl @"http://tts.yeshj.com/s/" //美国

#define  KGetWordurl @"http://dict-co.iciba.com/api/dictionary.php?w=" //美国
#define  KGetWordurlTwo @"https://api.shanbay.com/bdc/search/?word="//主要

//百度翻译
//#define  KTranslateWordurl @"http://openapi.baidu.com/public/2.0/bmt/translate?client_id=RKTUI9fLhHwWnDjhE0UN7kiO&q=" //美国

#define  KTranslateWordurl @"http://fanyi.youdao.com/translate?i=" //美国
//机器人
#define  KRobotViewUrl @"http://www.pandorabots.com/pandora/talk?botid=ea373c261e3458c6"

//查单词
#define  KSearchWordUrl @"http://dict.youdao.com/m/search?keyfrom=dict.mindex&le=eng&vendor=&q="

//查单词Db
#define  KSearchWordDbUrl @"http://file.bmob.cn/M01/9B/B7/"

//每日一句
#define  KGetDayWordUrl @"http://dict-mobile.iciba.com/new/index.php?act=list&k=af164df2429ab67de7ea6d9bc461de25"

//voa
#define  KGetDayVOAUrl @"http://voa.iciba.com/index.php?app=voaapi&act=list"

//每日资讯
#define  KGetDayInfoUrl @"http://dict-mobile.iciba.com/new/index.php?mod=infor&act=lst&k=3ed54fe60ef9134d62944a72fa0f25f5"

//下载背单词
#define  kLearnWordurl @"http://nce.file.alimmdn.com/recite/"

//下载背单词
#define  kLearnWordDBurl @"http://file.bmob.cn/M02/0B/54/oYYBAFZ2jOmAWzIpAHrNGkEp6yU157.eng"

#endif
