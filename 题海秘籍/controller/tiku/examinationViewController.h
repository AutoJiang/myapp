//
//  examinationViewController.h
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/30.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATViewController.h"

@interface examinationViewController : ATViewController

@property (nonatomic,strong)NSMutableArray *singleTpic;
@property (nonatomic,strong)NSMutableArray *doubleTpic;

@property(nonatomic ,strong)NSString *name;

@end
