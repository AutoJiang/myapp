//
//  data.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/10.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "data.h"

@implementation data

-(void)dataFromArray:(NSArray*)array{
    self.title = array[0];
    self.answer =[array lastObject];
    for (int i = 0; i < array.count-2; i++) {
        self.opArray[i] = array[i+1];
    }
}
@end
