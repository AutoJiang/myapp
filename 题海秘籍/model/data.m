//
//  data.m
//  学渣思政
//
//  Created by jiang aoteng on 16/5/10.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "data.h"
#define kopArray @"opArray"
#define ktitle @"title"
#define kanswer @"answer"
#define kstatusArray @"statusArray"
#define kdone @"done"
#define kisRight @"isRight"

@interface data ()<NSCoding>

@end

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
#pragma mark - NSCoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_title forKey:ktitle];
    [aCoder encodeObject:_opArray forKey:kopArray];
    [aCoder encodeObject:_answer forKey:kanswer];
    [aCoder encodeObject:_statusArray forKey:kstatusArray];
    [aCoder encodeBool:_done forKey:kdone];
    [aCoder encodeBool:_isRight forKey:kisRight];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        _title = [aDecoder decodeObjectForKey:ktitle];
        _opArray = [aDecoder decodeObjectForKey:kopArray];
        _answer = [aDecoder decodeObjectForKey:kanswer];
        _statusArray = [aDecoder decodeObjectForKey:kstatusArray];
        _done = [aDecoder decodeBoolForKey:kdone];
        _isRight = [aDecoder decodeBoolForKey:kisRight];
    }
    return self;
}

@end
