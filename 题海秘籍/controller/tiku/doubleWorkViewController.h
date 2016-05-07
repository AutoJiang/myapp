//
//  doubleWorkViewController.h
//  题海秘籍
//
//  Created by jiang aoteng on 15/9/26.
//  Copyright (c) 2015年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ATViewController.h"
@class doubleWorkViewController;
@protocol doubleWorkViewControllerDelegate <NSObject>

-(void)saveDwrongTpic:(doubleWorkViewController *)dworkView wrong:(NSMutableArray *)WrongArray;
-(void)deleteDWrongTpic:(doubleWorkViewController *)dworkView wrong:(NSMutableArray *)WrongArray;

@end

@interface doubleWorkViewController : ATViewController


@property (nonatomic, strong)NSMutableArray *tpArray;
@property (nonatomic ,assign) BOOL record;


@property(nonatomic ,strong)NSString *name;

@property (nonatomic,weak)id<doubleWorkViewControllerDelegate>delegate;

@end
