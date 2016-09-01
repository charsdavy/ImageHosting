//
//  const.h
//  ImageHosting
//
//  Created by dengw on 16/8/20.
//  Copyright © 2016年 chars. All rights reserved.
//

#ifndef const_h
#define const_h

typedef NS_ENUM(NSUInteger, IHAlertStyle) {
    IHAlertStyleNone,
    IHAlertStyleWarning,
    IHAlertStyleInformational,
    IHAlertStyleCritical
};

#define AK_KEY                  @"ak"
#define SK_KEY                  @"sk"
#define BUCKET_KEY              @"bucket"
#define TYPE_KEY                @"type"
#define REGION_KEY              @"region"

#define REGION_EAST_CHINA       @"east_china"
#define REGION_NORTH_CHINA      @"north_china"

#define CURRENT_ACCOUNT_KEY     @"current_account"
#define ACCOUNTS_KEY            @"accounts"

#define SYSTEM_NOTIFICATION_KEY @"system_notification"

#endif /* const_h */
