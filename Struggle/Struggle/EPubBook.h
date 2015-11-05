//
//  EPubBook.h
//  ReadLite
//
//  Created by wangyuheng on 15/11/3.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TouchXML.h"

//解析EPub，返回书的章节集合等属性


@interface EPubBook : NSObject
//书名
@property (nonatomic, readonly) NSString *bookName;
//章节集合数目
@property (nonatomic, readonly) NSArray  *spineArray;
//书文件路径
@property (nonatomic, readonly) NSString *bookPath;
//判断是否解析成功
@property (nonatomic, readonly) BOOL     parseSucceed;
//解压后书的基目录
@property (nonatomic, readonly) NSString *bookBasePath;

- (id)initWithEPubBookPath:(NSString *)bookPath;


@end
