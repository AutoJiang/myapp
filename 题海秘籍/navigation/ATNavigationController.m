//
//  ATNavigationController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/4/29.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATNavigationController.h"

@interface ATNavigationController ()

@end

@implementation ATNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count>0) {
        viewController.hidesBottomBarWhenPushed =YES;
    }
    [super pushViewController:viewController animated:true];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
