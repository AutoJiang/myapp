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
        [self.opArray addObject:array[i+1]];
        [self.statusAraay addObject:[NSNumber numberWithInt:statusNomal]];
    }
}

-(NSMutableArray *)opArray{
    if (_opArray == nil) {
        _opArray = [NSMutableArray array];
    }
    return _opArray;
}

-(NSMutableArray *)statusAraay{
    if (_statusArray == nil) {
        _statusArray = [NSMutableArray array];
    }
    return _statusArray;
}

@end
