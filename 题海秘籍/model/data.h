//
//  data.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/10.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,status){
    statusNomal ,
    statusSelect,
    statusRight ,
    statusError
};
@interface data : NSObject


@property (nonatomic, copy)NSMutableArray *opArray;

@property (nonatomic, copy)NSString *title;

@property (nonatomic, copy)NSString *answer;

@property (nonatomic, copy)NSMutableArray *statusArray;

@property (nonatomic, assign) BOOL done;

@property (nonatomic, assign) BOOL isRight;

-(void) dataFromArray:(NSArray*)array;

@end
