//
//  EPubChapterListView.m
//  Struggle
//
//  Created by wangyuheng on 15/11/4.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//
#import "EPubChapterListView.h"
#import "EPubChapter.h"


#define kChapterListCellIdentifer   @"chapterListCellIdentifer"

@interface EPubChapterListView () <UITableViewDataSource, UITableViewDelegate>


@end


@implementation EPubChapterListView

- (id)initWithFrame:(CGRect)frame andSpineArray:(NSArray *)spineArray
{
    self = [self initWithFrame:frame];
    
    _spineArray = [spineArray mutableCopy];
    
    _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kChapterListCellIdentifer];
    [self addSubview:self.tableView];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {    }
    return self;
}


#pragma mark - TableView Delegate && DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.spineArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kChapterListCellIdentifer];
    EPubChapter *chapter = [self.spineArray objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [cell.textLabel setText:chapter.title];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EPubChapter *chapter = [self.spineArray objectAtIndex:indexPath.row];
    [self.delegate selectChapter:chapter];
}

@end
