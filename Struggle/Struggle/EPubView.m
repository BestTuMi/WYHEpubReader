//
//  EPubView.m
//  ReadLite
//
//  Created by wangyuheng on 15/11/3.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//

#import "EPubView.h"
#import "EPubChapter.h"


@interface EPubView () <UIScrollViewDelegate, UIWebViewDelegate>
@property (assign, nonatomic) CGPoint touchBeginPoint;

@end


@implementation EPubView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor orangeColor];
        /*
        CGRect webViewFrame = self.bounds;
        webViewFrame.size.height=webViewFrame.size.height-10;
        webViewFrame.size.width=webViewFrame.size.width-10;
         */
        _webView = [[UIWebView alloc] initWithFrame:self.bounds];
        _webView.delegate = self;
        _webView.scrollView.alwaysBounceHorizontal = YES;
        _webView.scrollView.alwaysBounceVertical = NO;
        _webView.scrollView.bounces = YES;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.delegate = self;
        _webView.scrollView.pagingEnabled = YES;
        _webView.backgroundColor = [UIColor clearColor];
        _webView.scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.webView];
        
        _fontSize = 100;
        _next = YES;
    }
    return self;
}

- (void)loadChapter:(EPubChapter *)chapter
{
    NSURL *url = [NSURL fileURLWithPath:chapter.spinePath];
    NSLog(@"%@",url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)gotoPage:(int)pageIndex
{
    _currentPageIndex = pageIndex;
    float pageOffset = pageIndex * self.webView.bounds.size.width;
    [self.webView.scrollView setContentOffset:CGPointMake(pageOffset, 0) animated:NO];;
}

- (void)setFontSize:(int)fontSize
{
    
    if(_fontSize <= 200 || _fontSize >= 50)
    {
        _fontSize = fontSize;
        [self loadChapter:self.chapter];
    }
}


#pragma mark - WebView Delegate Method

- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    NSString *varMySheet = @"var mySheet = document.styleSheets[0];";
    NSString *addCSSRule =  @"function addCSSRule(selector, newRule) {"
    "if (mySheet.addRule) {"
    "mySheet.addRule(selector, newRule);"								// For Internet Explorer
    "} else {"
    "ruleIndex = mySheet.cssRules.length;"
    "mySheet.insertRule(selector + '{' + newRule + ';}', ruleIndex);"   // For Firefox, Chrome, etc.
    "}"
    "}";
    
    NSString *insertRule1 = [NSString stringWithFormat:@"addCSSRule('html', 'padding: 10px; height: %fpx; -webkit-column-gap: 20px; -webkit-column-width: %fpx;')", self.webView.frame.size.height - 20, self.webView.frame.size.width - 20];
    NSString *insertRule2 = [NSString stringWithFormat:@"addCSSRule('p', 'text-align: justify;')"];
    NSString *setTextSizeRule = [NSString stringWithFormat:@"addCSSRule('body', '-webkit-text-size-adjust: %d%%;')", _fontSize];
    
    [self.webView stringByEvaluatingJavaScriptFromString:varMySheet];
    [self.webView stringByEvaluatingJavaScriptFromString:addCSSRule];
    [self.webView stringByEvaluatingJavaScriptFromString:insertRule1];
    [self.webView stringByEvaluatingJavaScriptFromString:insertRule2];
    [self.webView stringByEvaluatingJavaScriptFromString:setTextSizeRule];
    
    int totalWidth = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.scrollWidth"] intValue];
    _pageCount = ceil(totalWidth / self.webView.bounds.size.width);
    _currentPageIndex = 0;
    if ([self.delegate respondsToSelector:@selector(epubViewLoadFinished)])
    {
        [self.delegate epubViewLoadFinished];
    }
}


#pragma mark - ScrollView Delegate Method

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    self.touchBeginPoint = scrollView.contentOffset;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat   pageWidth   = scrollView.frame.size.width;
    _currentPageIndex = ceil(scrollView.contentOffset.x / pageWidth);
    
    CGPoint touchEndPoint = scrollView.contentOffset;
    _next = self.touchBeginPoint.x > touchEndPoint.x + 5;
    
    if (!self.next)
    {
        if (_currentPageIndex == 0)
        {
            [self.delegate gotoPrevSpine];
        }
    }
    else
    {
        if(_currentPageIndex + 1 == _pageCount)
        {
            [self.delegate gotoNextSpine];
        }
    }        
}


@end
