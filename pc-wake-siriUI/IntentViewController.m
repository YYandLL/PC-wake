//
//  IntentViewController.m
//  pc-wake-siriUI
//
//  Created by YandL on 2017/5/24.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "IntentViewController.h"
#import "yandl.pch"

// As an example, this extension's Info.plist has been configured to handle interactions for INSendMessageIntent.
// You will want to replace this or add other intents as appropriate.
// The intents whose interactions you wish to handle must be declared in the extension's Info.plist.

// You can test this example integration by saying things to Siri like:
// "Send a message using <myApp>"

@interface IntentViewController () <INUIHostedViewSiriProviding>

@end

@implementation IntentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tipLabel.text = @"唤醒";
    self.label.text = [TXBYUserDefaults valueForKey:@"lastMac"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - INUIHostedViewControlling

// Prepare your view controller for the interaction to handle.
- (void)configureWithInteraction:(INInteraction *)interaction context:(INUIHostedViewContext)context completion:(void (^)(CGSize))completion {
    // Do configuration here, including preparing views and calculating a desired size for presentation.
    if (completion) {
        completion(CGSizeMake([self desiredSize].width, 80));
    }
}

- (BOOL)displaysMessage {
    return YES;
}

- (CGSize)desiredSize {
    return [self extensionContext].hostedViewMaximumAllowedSize;
}

@end
