//
//  ABUrlDefine.h
//  Axiba
//
//  Created by Peter on 16/6/7.
//  Copyright © 2016年 Peter. All rights reserved.
//

// 线上
#define     _host_          @"http://106.15.36.80:8080"
// 本地
//#define     _host_          @"http://192.168.1.78:8080"

#define     _API_           [NSString stringWithFormat:@"%@/jf/app",_host_]
#define urlApp              @"https://itunes.apple.com/us/app/cui-bing-lu-xing/id1137496808?l=zh&ls=1&mt=8"
#define urlAppRate          @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1137496808"
#define urlAppService        [NSString stringWithFormat:@"%@/agreement/agreement.html", _host_]


//#define urlVideoShare(_contentId) [NSString stringWithFormat:@"http://m.hiohmo.com/app.html#/detail/%@", _contentId]
//#define urlChannelShare(_contentId   ,_name) [NSString stringWithFormat:@"http://m.hiohmo.com/app.html#/channel/1/%@/%@", _contentId,_name]

#define urlVideoShare(_contentId) [NSString stringWithFormat:@"http://static.hiohmo.com/qidian/share/detail.html#/%@", _contentId]
#define urlChannelShare(_contentId) [NSString stringWithFormat:@"http://static.hiohmo.com/qidian/share/channel.html#/%@", _contentId]

//#define urlVideoShare(_contentId) [NSString stringWithFormat:@"http://192.168.1.58:8080/share/detail.html#/%@", _contentId]
//#define urlChannelShare(_contentId) [NSString stringWithFormat:@"http://192.168.1.58:8080/share/channel.html#/%@", _contentId]

#define urlMineShare(_uid)   [NSString stringWithFormat:@"%@/H5/share/index.html?#/personal?=1&uid=%@", _host_, _uid]

#define urlThird            @"/user/thirdLogin"
#define urlLogin            @"/user/login"
#define urlLogout           @"/user/loginout"
#define urlReg              @"/user/register"
#define urlFindPass         @"/user/resetpwd"
#define urlProfile          @"/user/modifyUserInfo"
#define urlUpload           @"/user/updateProfile"
#define urlEditPass         @"/user/modifyPwd"
#define urlMeOrOther        @"/user/profile"
#define urlGetCaptcha       @"/user/getCaptcha"
#define urlUpdateData       @"/common/uploadUserData"
#define urlFeedback         @"/appfeedback/save"
#define urlChannelList      @"/appchannel/getLikeChannel"
#define urlCollectList      @"/appcollection"

#define urlDelete           @"/jf/app/appcollection/delete"             // 批量删除
#define urlSearchHot        @"/jf/app/common/hotSearch"                 // 搜索热门
#define urlLikeComment      @"/jf/app/commentPraise/update"             // 点赞评论
#define urlHomeSelect       @"/jf/app/home/selected"                    // 首页精选
#define urlPraiseOrUpdate   @"/jf/app/commentPraise/update"             // 点赞或者取消
#define urlPraiseList       @"/jf/app/apppraise/list"                   // 获取点赞列表
#define urlCommentList      @"/jf/app/comment/commentList"              // 评论lb
#define urlAdSever          @"/jf/app/ad/getAd"                         // 广告
#define urlAdTopReport      @"/jf/app/ad/reportParam"                   // 广告上报

#define urlDataIndex        @"/index"
#define urlComments         @"/comment/list"
#define urlBannerList       @"/banner/list"
#define urlContentList      @"/content"
#define urlVideoDetail      @"/content/detail"
#define urlSearchResult     @"/common/search"
#define urlCollectionState  @"/appcollection/update"
#define urlSendReview       @"/comment/send"
#define urlSetRedDot        @"/comment/setRedDot"
#define urlGetRedDot        @"/comment/getRedDot"
#define urlReviewList       @"/comment/list"
#define urlLikeList         @"/apppraise"
#define urlChannelInfo      @"/appchannel/info"
#define urlActionLike       @"/apppraise/update"
#define urlAddView          @"/content/setContentViews"
#define urlAddShare         @"/content/setContentShare"
