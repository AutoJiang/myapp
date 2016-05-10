//
//  AppDelegate.m
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/10.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import "AppDelegate.h"

BOOL isOut;
@interface AppDelegate ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIViewController *vc;
@property (strong ,nonatomic)UIPageControl *pageControl;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:0.7];
    NSString *version = @"CFBundleVersion";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastVersion = [defaults stringForKey:version];
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[version];
//    NSLog(@"%@",[NSBundle mainBundle].infoDictionary);
    isOut = [currentVersion isEqualToString:lastVersion];
//    isOut = [defaults boolForKey:@"first"];
    
    if (!isOut) {
//        [self gotoMain];
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        // Override point for customization after application launch.
        self.window.backgroundColor = [UIColor whiteColor];
        
        self.vc = [[UIViewController alloc]init];
        
        self.window.rootViewController =self.vc;
        [self makeLaunchView];
        [defaults setObject:currentVersion forKey:version];
        [defaults synchronize];
    }
    [self.window makeKeyAndVisible];
    //设置tab bar 颜色
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:227.0/255.0 green:28.0/255.0 blue:31.0/255.0 alpha:1]];
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    [[UINavigationBar appearance]setBarTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
    return YES;
}

//假引导页面
-(void)makeLaunchView{
    NSArray *arr=[NSArray arrayWithObjects:@"f1",@"f2",@"f3",@"f4",@"f5", nil];
    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:self.window.bounds];
    CGFloat width = self.window.frame.size.width;
    CGFloat height = self.window.frame.size.height;
    scr.contentSize=CGSizeMake( width*arr.count, height);
    scr.pagingEnabled = YES;
    scr.delegate=self;
    scr.showsHorizontalScrollIndicator = NO;
    [self.vc.view addSubview:scr];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*width, 0, width, self.window.frame.size.height)];
        img.image=[UIImage imageNamed:arr[i]];
        [scr addSubview:img];
    }
    self.pageControl = [[UIPageControl alloc]init];
    self.pageControl.center = CGPointMake(width/2, height*0.93);
    self.pageControl.numberOfPages = arr.count;
    self.pageControl.currentPageIndicatorTintColor = [UIColor brownColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
//    self.pageControl.backgroundColor = [UIColor redColor];
    [self.vc.view addSubview:self.pageControl];
    
}

#pragma mark scrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = self.window.frame.size.width;
    self.pageControl.currentPage = (int)(scrollView.contentOffset.x/width+0.5);
    if (scrollView.contentOffset.x> 4*width+30) {
        isOut=YES;
        
    }
}
//停止滑动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (isOut) {
        //这里添加了一个动画，（可根据个人喜好）
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.alpha=0;//让scrollview 渐变消失
        }completion:^(BOOL finished) {
            [scrollView  removeFromSuperview];//将scrollView移
            [self.vc removeFromParentViewController];
            [self gotoMain];//进入主界面
        } ];
    }
    
}

-(void)gotoMain{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setBool:YES forKey:@"first"];
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@ "Main" bundle: nil ];
    UITabBarController *vc = [storyboard instantiateViewControllerWithIdentifier:@"tab"];
    self.window.rootViewController = vc;
    self.window.rootViewController.view.alpha = 0;
    [UIView animateWithDuration:0.5 animations:^{
        self.window.rootViewController.view.alpha = 1;
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
