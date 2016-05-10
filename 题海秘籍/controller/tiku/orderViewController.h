//
//  orderViewController.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/8.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import "ATViewController.h"
@class workViewController;
@protocol workViewControllerDelegate <NSObject>

-(void)saveWrongTpic:(workViewController *)workView wrong:(NSMutableArray *)WrongArray;
-(void)deleteWrongTpic:(workViewController *)workView wrong:(NSMutableArray *)WrongArray;
@end

@interface orderViewController : ATViewController



@property (nonatomic ,strong) NSMutableArray *tpArray;
@property (nonatomic ,assign) BOOL record;



@property(nonatomic ,strong)NSString *name;

@property(nonatomic,weak)id<workViewControllerDelegate>delegate;
@end
