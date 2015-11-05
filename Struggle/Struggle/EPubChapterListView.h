//
//  EPubChapterListView.h
//  Struggle
//
//  Created by wangyuheng on 15/11/4.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EPubChapter;
@protocol ChapterListViewDelegate <NSObject>

@required
- (void)selectChapter:(EPubChapter *)chapter;

@end

@interface EPubChapterListView : UIView

@property (weak, nonatomic) id <ChapterListViewDelegate> delegate;
//显示章节视图
@property (strong, nonatomic, readonly) UITableView    *tableView;
//章节数组
@property (strong, nonatomic, readonly) NSMutableArray *spineArray;
- (id)initWithFrame:(CGRect)frame andSpineArray:(NSArray *)spineArray;

@end
