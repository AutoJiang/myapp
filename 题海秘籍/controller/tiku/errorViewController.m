//
//  errorViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/13.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "errorViewController.h"

@interface errorViewController ()

@end

@implementation errorViewController

@synthesize datas =_datas;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(instancetype)init{
    if(self =[super init]){
        
    }
    return self;
}

-(void)delRight{
    if ([self.delegate respondsToSelector:@selector(deleteRightTpic:right:pos:)]) {
        [self.delegate deleteRightTpic:self right:self.tpArray[self.index]pos:self.index];
    }
}

-(NSMutableArray *)datas{
    if (_datas == nil) {
        _datas = [NSMutableArray array];
        for(int i = 0 ; i < self.tpArray.count;i++){
            data *da = [[data alloc]init];
            [da dataFromArray:self.tpArray[i]];
            [_datas addObject:da];
        }
    }
    return _datas;
}


@end
