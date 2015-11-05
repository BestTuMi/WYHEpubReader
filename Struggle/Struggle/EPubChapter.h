//
//  EPubChapter.h
//  ReadLite
//
//  Created by wangyuheng on 15/11/3.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EPubChapter : NSObject
//章节的标题、目录完整路径、章节在整本书中的索引位置
@property (nonatomic, strong) NSString  *title;
@property (nonatomic, strong) NSString  *spinePath;
@property (nonatomic, assign) NSInteger spineIndex;


@end
