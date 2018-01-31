//
//  PadNavView.m
//  visitor-manage
//
//  Created by YandL on 2017/4/7.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "PadNavView.h"

@interface PadNavView ()
/**
 * <#name#>
 */
@property (nonatomic, strong) UIView *titleView;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIButton *rightBtn;

@end

@implementation PadNavView

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleView = [[UIView alloc] init];
    [self addSubview:self.titleView];
    [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerX);
        make.height.equalTo(self.height);
        make.top.equalTo(self.top);
        make.width.equalTo(300);
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:26];
    titleLabel.textColor = [UIColor darkGrayColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.titleView);
    }];
}

- (void)showBackView:(padNavClickBlock)block {
    self.backblock = block;
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(30);
        make.height.equalTo(self.height);
        make.width.equalTo(self.height);
        make.top.equalTo(self.top);
    }];
    UIButton *backImageView = [UIButton buttonWithType:UIButtonTypeSystem];
    [backImageView addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:backImageView];
    [backImageView setBackgroundImage:[UIImage imageNamed:@"pad_back"] forState:UIControlStateNormal];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.backView);
    }];
}

- (void)showRightView:(padNavClickBlock)block {
    self.nextblock = block;
    self.nextView = [[UIView alloc] init];
    [self addSubview:self.nextView];
    [self.nextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right).offset(-30);
        make.height.equalTo(self.height);
        make.width.equalTo(self.height);
        make.top.equalTo(self.top);
    }];
    UIButton *nextImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rightBtn = nextImageView;
    nextImageView.backgroundColor = TXBYMainColor;
    nextImageView.layer.cornerRadius = 3;
    nextImageView.layer.masksToBounds = YES;
    [nextImageView addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [self.nextView addSubview:nextImageView];
    [nextImageView setBackgroundImage:[UIImage imageNamed:@"pad_right"] forState:UIControlStateNormal];
    [nextImageView setBackgroundImage:[UIImage imageNamed:@"pad_right_select"] forState:UIControlStateHighlighted];
    [nextImageView setBackgroundImage:[UIImage imageNamed:@"btn_disable"] forState:UIControlStateDisabled];
    [nextImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.nextView);
    }];
    self.rightBtn.alpha = 0;
    [self setRightEnable:NO];
}

- (void)setRightEnable:(BOOL)enable {
    if (enable) {
        if (!self.rightBtn.enabled) {
            [UIView animateWithDuration:0.15 animations:^{
                self.rightBtn.alpha = 0;
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.25 animations:^{
                    self.rightBtn.enabled = enable;
                    self.rightBtn.alpha = 1;
                }];
            }];
        }
    } else {
        self.rightBtn.enabled = enable;
        [UIView animateWithDuration:0.15 animations:^{
            self.rightBtn.alpha = 0;
        }];
    }
}

- (void)backClick {
    self.backblock();
}

- (void)nextClick {
    self.nextblock();
}

- (void)setTitleAlpha:(CGFloat)alpha {
    self.titleView.alpha = alpha;
}

@end
