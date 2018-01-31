//
//  TXBYKit.h
//  TXBYKit
//
//  Created by mac on 16/4/26.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import <UIKit/UIKit.h>

// 医院ID
NSString *TXBYHospital;
// app_type
NSString *TXBYApp_type;
// 医院分支
NSString *TXBYBranch;

// 导航栏高度
CGFloat const TXBYNavH = 44;
// tabbar高度
CGFloat const TXBYTabbarH = 49;
// cell之间的间距
CGFloat const TXBYCellMargin = 10;
// 接口调用成功
NSString *const TXBYSuccessCode = @"0";

// 刷新token网络标识
NSString *const TXBYRefreshTokenNetIdentifier = @"TXBYRefreshTokenNetIdentifier";
// 注销token网络标识
NSString *const TXBYRevokeTokenNetIdentifier = @"TXBYRevokeTokenNetIdentifier";
// 变更DeviceToken网络标识
NSString *const TXBYDeviceTokenNetIdentifier = @"TXBYDeviceTokenNetIdentifier";

#pragma mark - 智能分诊接口
// 智能分诊症状列表
NSString *const TXBYTriageSymptomListAPI = @"/v2/smart_triage/symptom";
// 智能分诊疾病列表
NSString *const TXBYTriageIllListAPI = @"/v2/smart_triage/disease";

#pragma mark - 问答接口
// 问题列表
NSString *const TXBYQuestListAPI = @"/v2/quest/quests";
// 问题详情
NSString *const TXBYQuestDetailAPI = @"/v2/quest/show";
// 提问
NSString *const TXBYQuestAddAPI = @"/v2/quest/create";
// 回复问题
NSString *const TXBYQuestReplyAPI = @"/v2/quest/reply";
// 我的问题
NSString *const TXBYMyQuestAPI = @"/v2/quest/my";

#pragma mark - 科室接口
// 科室介绍列表
NSString *const TXBYDeptIntroduceListAPI = @"/v2/dept/depts";
// 科室介绍详情
NSString *const TXBYDeptIntroduceDetailAPI = @"/v2/dept/show";

#pragma mark - 交流区接口
// 交流区分类
NSString *const TXBYCommunityGroupAPI = @"/v2/quest/group";
// 交流区列表
NSString *const TXBYCommunityListAPI = @"/v2/quest/quests";
// 交流区thumb图片
NSString *const TXBYCommunityThumbAPI = @"http://cloud.eeesys.com/pu/thumb.php";
// 交流区点赞和踩
NSString *const TXBYCommunityLoveAPI = @"/v2/operate/create";
// 交流区取消点赞和踩
NSString *const TXBYCommunityCancelLoveAPI = @"/v2/operate/cancel";
// 交流区点赞和点踩人数
NSString *const TXBYCommunityPersonAPI = @"/v2/quest/love";
// 交流区上传请求
NSString *const TXBYCommunityUploadImageAPI = @"http://cloud.eeesys.com/pu/upload.php";
// 已回答API
NSString *const TXBYReadQuestAPI = @"/v2/quest/answered";
// 未回答API
NSString *const TXBYUnReadQuestAPI = @"/v2/quest/to_answer";

#pragma mark - 其他接口
// 服务条款
NSString *const TXBYAgreementAPI = @"/v2/agree/agreement";
// 药价公示
NSString *const TXBYDrugListAPI = @"http://www.szyyjg.com/androidapi/medic_prices.jsp";
// 服务价格
NSString *const TXBYServiceAPI = @"http://www.szyyjg.com/androidapi/jqm/ServiceTypeQuery.jsp";
