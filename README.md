# WYHEpubReader
这是一个电子书阅读器的开发项目
#一，第三方库的问题
为什么我项目名叫Struggle就是用TouchXML总是找不到```<tree.h>```
cocospod是一个很重要的东西，我在配置TouchXML与Zip还有等待动画的时候花了很多时间莫名找不到一些头文件```<tree.h>``` ，但是用cocospod分分钟解决。
用第三方库的时候要注意他是ARC的还是MRC的这个非常重要，TouchXML-feature-ARC与TouchXML-master就是这样。
有各种release,dealloc就不是ARC,这几个关键字在ARC禁用
```
- (void)dealloc {
    self.toolbar = nil;
	self.webView = nil;
	self.chapterListButton = nil;
	self.decTextSizeButton = nil;
	self.incTextSizeButton = nil;
	self.pageSlider = nil;
	self.currentPageLabel = nil;
	[loadedEpub release];
	[chaptersPopover release];
	[searchResultsPopover release];
	[searchResViewController release];
	[currentSearchResult release];
    [super dealloc];
}
```
#二，版本一的理解

总体流程
##A 这里是在EBook类里做的就是打开电子书存到章数组里
 1. 用zip解压工具解压
 2. 用TouchXML解析两个关键文件
 3. 解析container.xml
 4. 解析OPS/epb.opf
 5. 解析//opf:itemref找到目录
 6. 把目录存到一个EChapter类数组里
 
##B 这里是在EChapter里存的东西
 7. EChapter类里存放
 (1)spinePath 当前章节路径
 (2)title 当前章节标题
 (3)chapterIndex 当前章节的页数
  //目前简版并没有加后面三个
 (4)pageCount 当前章节页数（这个是为获取总页数准备的）
 (5)text 当前章节的文本（这个为的是后面查询准备的）
 (6) CGRect windowSize 这个是调整webview窗口用的
 (7)int fontPercentSize 这个是调整字号用的
 
##C 这里需要一个View放上Webview,scrollView
WebView上需要两个手势，左拽右拽，两个重要组件。
这个view的代理需要放在放view的那个viewcontroller上面实现
```
@protocol EPubViewDelegate <NSObject>

@required
- (void)gotoPrevSpine;
- (void)gotoNextSpine;

@optional
- (void)epubViewLoadFinished;

@end
```
8. 整体结构到这里是先搞一个ViewController然后上面放上一个View这个View里面有一个webview,通过webview按章加载xml,并配置左右拖动事件。
功能实现
第一是要加载页面，二左右滑动
第二是要实现章节跳转
第三是要实现查找 
怎么实现全章搜索并没有思路
目前感觉谜题隐藏在任意页面跳转与WebView里插入JS

(1)放一个webView并设置这些属性
 
```
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

```


(2)这里是加载某章到WebView
 
```
- (void)loadChapter:(EPubChapter *)chapter
{
    NSURL *url = [NSURL fileURLWithPath:chapter.spinePath];
    NSLog(@"%@",url);
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}
```
(3)WebView的重要代理
```
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

```

(4)scrollView怎么用scrollView的offset是什么啊
这里不能理解！！！！！！！
```

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
    //这里就是说把拖拽的事件触调用两个代理的方法去
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
```

View的setHidden:NO是一个很有用的属性
可以做出点击打开，点击关闭的效果。
