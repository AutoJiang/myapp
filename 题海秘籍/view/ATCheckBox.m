//
//  EICheckBox.m
//  EInsure
//
//  Created by ivan on 13-7-9.
//  Copyright (c) 2013年 ivan. All rights reserved.
//

#import "QCheckBox.h"

#define Q_CHECK_ICON_WH                    (30.0)
#define Q_ICON_TITLE_MARGIN                (5.0)
#define MARGIN                              10
@implementation QCheckBox

@synthesize delegate = _delegate;
@synthesize checked = _checked;
@synthesize userInfo = _userInfo;

- (id)initWithDelegate:(id)delegate{
    self = [super init];
    if (self) {
        _delegate = delegate;
        self.exclusiveTouch = YES;
        [self setImage:[UIImage imageNamed:@"checkbox1_unchecked.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"checkbox1_checked.png"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(checkboxBtnChecked) forControlEvents:UIControlEventTouchUpInside];
        [self setShowsTouchWhenHighlighted:YES];
        
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor brownColor] forState:UIControlStateSelected];
//        self.titleLabel.textColor = [UIColor blackColor];

    }
    return self;
}
-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    [super setTitle:title forState:state];
     CGSize contentSize = [title sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(self.titleLabel.frame.size.width, MAXFLOAT)lineBreakMode:NSLineBreakByCharWrapping];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,self.frame.size.width,contentSize.height+Q_ICON_TITLE_MARGIN*4);
    self.titleLabel.lineBreakMode = 0;
    self.titleLabel.textColor = [UIColor blackColor];
//    CGSize contentSize = [_topicTextField.text sizeWithFont:_font constrainedToSize:CGSizeMake(_topicTextField.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
//    _topicTextField.height = contentSize.height+10;
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (void)checkboxBtnChecked {
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedCheckBox:checked:)]) {
        [_delegate didSelectedCheckBox:self checked:self.selected];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(MARGIN, (CGRectGetHeight(contentRect) - Q_CHECK_ICON_WH)/2.0, Q_CHECK_ICON_WH, Q_CHECK_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(Q_CHECK_ICON_WH + Q_ICON_TITLE_MARGIN+MARGIN, 0,
                      CGRectGetWidth(contentRect) - Q_CHECK_ICON_WH - Q_ICON_TITLE_MARGIN-MARGIN*2 ,
                      CGRectGetHeight(contentRect));
}

- (void)dealloc {
//    [_userInfo release];
    _delegate = nil;
//    [super dealloc];
}

@end
