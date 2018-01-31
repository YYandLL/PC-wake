//
//  IntentViewController.h
//  pc-wake-siriUI
//
//  Created by YandL on 2017/5/24.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import <IntentsUI/IntentsUI.h>

@interface IntentViewController : UIViewController <INUIHostedViewControlling>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end
