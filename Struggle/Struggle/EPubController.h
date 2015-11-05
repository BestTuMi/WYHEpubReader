//
//  EPubController.h
//  ReadLite
//
//  Created by wangyuheng on 15/11/3.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class EPubChapterListView;
@class EPubBook;
@class EPubView;
@class EPubChapter;


@interface EPubController : NSObject
//已加载的epub书。
@property (nonatomic, readonly) EPubBook            *epubBook;
//EPub阅读视图。
@property (nonatomic, readonly) EPubView            *epubView;
//EPub章节列表视图
@property (nonatomic, readonly) EPubChapterListView *chapterListView;

//当前章节在书中的索引值，从0开始
@property (nonatomic, readonly) int                 currentSpineIndex;
//书籍总页数，等于所有章节页数之和
@property (nonatomic, readonly) int                 totalPagesCount;


//打开、关闭书籍
- (void)openBook:(NSString *)bookPath atView:(UIView *)view withPageFrame:(CGRect)pageFrame;
- (void)closeBook;

//显示、隐藏章节列表
- (void)showChapterListAtView:(UIView *)view withFrame:(CGRect)rect;
- (void)hideChapterListView;

////控制文本字号增减
//- (void)increaseTextFontSize:(NSInteger)size;
//- (void)decreaseTextFontSize:(NSInteger)size;

//跳转到当前章节的某一页
- (void)gotoPageInCurrentSpine:(int)pageIndex;
- (void)gotoPage:(int)pageIndex inSpine:(int)spineIndex;

//- (void)addBookmark;
//- (void)deleteBookmark:(EPubBookmark *)bookmark;

@end
