//
//  userDefault.m
//  刷题宝
//
//  Created by jiang aoteng on 15/11/10.
//  Copyright © 2015年 Auto. All rights reserved.
//

#import "userDefault.h"

@implementation userDefault
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"name";
        self.key = @"key";
        self.leftSwicth = @"leftSwicth";
        self.rightSwicth = @"rightSwicth";
        self.voice = @"voice";
        self.shake = @"shake";
    }
    return self;
}

@end
