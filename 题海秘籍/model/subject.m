//
//  subject.m
//  刷题宝
//
//  Created by jiang aoteng on 15/11/10.
//  Copyright © 2015年 Auto. All rights reserved.
//

#import "subject.h"

@implementation subject
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.bookName = [[NSMutableArray alloc]initWithObjects:@"思想道德与法律",@"毛泽东思想I",@"毛泽东思想II",@"中国近代史纲要",@"马克思基本原理",nil];
        self.bookarr =[[NSArray alloc]initWithObjects:@"thought",@"mao1",@"mao2",@"history",@"marx", nil];
        self.image = @[@"exer_icon_sx", @"exer_icon_mg_1", @"exer_icon_mg_2", @"exer_icon_jds", @"exer_icon_mks"];
    }
    return self;
}

@end
