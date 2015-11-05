//
//  ViewController.m
//  Struggle
//
//  Created by wangyuheng on 15/11/3.
//  Copyright (c) 2015年 wangyuheng. All rights reserved.
//

#import "ViewController.h"
#import "EPubController.h"
@interface ViewController ()
@property (strong, nonatomic) EPubController *epubController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    // Do any additional setup after loading the view, typically from a nib.
    NSString *bookPath = [[NSBundle mainBundle] pathForResource:@"two" ofType:@"epub"];
   // NSLog(@"Screen: %f; navigation:%f: vc:%f navigationbar: %f",[UIScreen mainScreen].bounds.size.height, self.navigationController.view.frame.size.height, self.view.frame.size.height, self.navigationController.navigationBar.frame.size.height);
    //CGRect showFrame=CGRectMake(0, self.navigationController.navigationBar.frame.size.height, [UIScreen mainScreen].bounds.size.width,self.view.frame.size.height);
    self.epubController = [[EPubController alloc] init];
   // [self.epubController openBook:bookPath atView:self.view withPageFrame:showFrame];
    [self.epubController openBook:bookPath atView:self.view withPageFrame:self.view.bounds];
    UIBarButtonItem *leftOneItem= [[UIBarButtonItem alloc] initWithTitle:@"目录" style:UIBarButtonItemStylePlain target:self action:@selector(showChapterList)];
     UIBarButtonItem *leftTwoItem= [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:nil];
    //UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] initWithCustomView:self.testbutton2];
    
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:leftOneItem, leftTwoItem,nil]];

    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showChapterList
{
    static BOOL open = NO;
    if (!open)
    {
        [self.epubController showChapterListAtView:self.view withFrame:self.view.bounds];
        open = YES;
    }
    else
    {
        [self.epubController hideChapterListView];
        open = NO;
    }
}


@end
