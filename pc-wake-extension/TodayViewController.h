//
//  TodayViewController.h
//  pc-wake-extension
//
//  Created by YandL on 2017/5/23.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
- (IBAction)click:(UIButton *)sender;

@end
