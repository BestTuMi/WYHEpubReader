//
//  EPubConfig.h
//  ReadLite
//
//  Created by wangyuheng on 15/11/3.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//

#ifndef ReadLite_EPubConfig_h
#define ReadLite_EPubConfig_h
#import <Foundation/Foundation.h>

#define kAPPName    [[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleDisplayName"]
#define kDocuments  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

//数据库地址，用于保存书签等
#define kEPubDBPath     [NSString stringWithFormat:@"%@/%@", kDocuments, @"EPub.db"]



#endif
