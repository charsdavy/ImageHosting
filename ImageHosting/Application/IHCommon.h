//
//  IHCommon.h
//  ImageHosting
//
//  Created by chars on 16/9/7.
//  Copyright © 2016年 chars. All rights reserved.
//

#ifndef IHCommon_h
#define IHCommon_h

//自定义日志输出
#ifdef DEBUG
//调试状态
#define IHLog(...) NSLog(@"%s line:%d\n %@ \n\n", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__])
#else
//发布状态
#define IHLog(...)
#endif


#endif /* IHCommon_h */
