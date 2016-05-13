//
//  randomViewController.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/13.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "randomViewController.h"

@interface randomViewController ()

@property(nonatomic,strong) NSMutableArray *array;

@end

@implementation randomViewController

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

-(NSMutableArray *)datas{
//    NSMutableArray *datas =[super datas];
    if ( _datas == nil) {
        NSString *path = [self filePath];
        _datas = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        if (_datas == nil) {
            _datas = [NSMutableArray array];
            self.array = [self.tpArray mutableCopy];
            for(int i = 0 ; i < self.tpArray.count;i++){
                NSInteger n = arc4random() % self.array.count;
                data *da = [[data alloc]init];
                [da dataFromArray:self.array[n]];
                [_datas addObject:da];
                [self.array removeObjectAtIndex:n];
            }
        }
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:self.record]!=nil) {
            self.index = [defaults integerForKey:self.record];
        }
    }
    return _datas;
}

@end
