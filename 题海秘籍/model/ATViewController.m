//
//  ATViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/3/20.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATViewController.h"

@interface ATViewController ()

@end

@implementation ATViewController
-(void)didMyFont{
    if (self.view.frame.size.height == 480) {
        _myfont = 13;
        _interval = 40;
    }
    else if(self.view.frame.size.height == 568){
        _myfont = 14;
        _interval = 48;
    }
    else if(self.view.frame.size.height == 667){
        _myfont = 15;
        _interval = 50;
    }
    else{
        _myfont = 15;
        _interval =50;
    }
    _font = [UIFont systemFontOfSize:_myfont];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self didMyFont];
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
