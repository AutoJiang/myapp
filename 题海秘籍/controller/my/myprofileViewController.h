//
//  myprofileViewController.h
//  学渣思政
//
//  Created by jiang aoteng on 16/5/1.
//  Copyright © 2016年 Auto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "user.h"

@interface myprofileViewController : UITableViewController

@property (nonatomic, strong)user *user;

@property (nonatomic, copy) void(^reloadData)();

@end
