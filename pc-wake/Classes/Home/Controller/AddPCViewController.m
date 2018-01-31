//
//  AddPCViewController.m
//  QiuqiuUrl
//
//  Created by YandL on 17/1/23.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "AddPCViewController.h"
#import "PCInfo.h"
#import <ifaddrs.h>
#import <arpa/inet.h>

@interface AddPCViewController () <UITextFieldDelegate>
/**
 *  <#desc#>
 */
@property (nonatomic, strong) UITextField *field;
/**
 *  <#desc#>
 */
@property (nonatomic, strong) UITextField *macAddressField;
/**
 *  <#desc#>
 */
@property (nonatomic, strong) UITextField *broadAddressField;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIView *shadowView1;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIView *shadowView2;
/**
 * <#name#>
 */
@property (nonatomic, strong) UIView *shadowView3;
/**
 *  <#desc#>
 */
@property (nonatomic, strong) UIView *backView;
/**
 *  <#desc#>
 */
@property (nonatomic, assign) NSInteger index;

@end

@implementation AddPCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.index = 1000;
    self.backView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backClick)];
    [self.backView addGestureRecognizer:ges];
    [self setupShadow];
    [self setupBtn];
    [self setupKeyboard];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.field becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)backClick {
    [self.view endEditing:YES];
}

//获取ip地址
- (NSString *)getIpAddresses{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}

// 设置输入框的背景
- (void)setupShadow {
    self.shadowView1 = [UIView new];
    self.shadowView1.backgroundColor = [UIColor whiteColor];
    self.shadowView1.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView1.layer.shadowOffset = CGSizeMake(0, 1);
    self.shadowView1.layer.shadowOpacity = 0.2;
    self.shadowView1.layer.shadowRadius = 2;
    self.shadowView1.layer.cornerRadius = 2;
    [self.backView addSubview:self.shadowView1];
    [self.shadowView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(TXBYApplicationW * 0.9);
        make.centerX.equalTo(self.backView.centerX);
        make.top.equalTo(self.backView.top).offset(170 - 15);
        make.height.equalTo(46);
    }];
    
    self.shadowView2 = [UIView new];
    self.shadowView2.backgroundColor = [UIColor whiteColor];
    self.shadowView2.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView2.layer.shadowOffset = CGSizeMake(0, 1);
    self.shadowView2.layer.shadowOpacity = 0.2;
    self.shadowView2.layer.shadowRadius = 2;
    self.shadowView2.layer.cornerRadius = 2;
    [self.backView addSubview:self.shadowView2];
    [self.shadowView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.shadowView1.width);
        make.top.equalTo(self.shadowView1.bottom).offset(25);
        make.centerX.equalTo(self.backView.centerX);
        make.height.equalTo(46);
    }];
    
    self.shadowView3 = [UIView new];
    self.shadowView3.backgroundColor = [UIColor whiteColor];
    self.shadowView3.layer.shadowColor = [UIColor blackColor].CGColor;
    self.shadowView3.layer.shadowOffset = CGSizeMake(0, 1);
    self.shadowView3.layer.shadowOpacity = 0.2;
    self.shadowView3.layer.shadowRadius = 2;
    self.shadowView3.layer.cornerRadius = 2;
    [self.backView addSubview:self.shadowView3];
    [self.shadowView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.shadowView2.width);
        make.top.equalTo(self.shadowView2.bottom).offset(25);
        make.centerX.equalTo(self.backView.centerX);
        make.height.equalTo(46);
    }];
}

- (void)setupBtn {
    UITextField *field = [[UITextField alloc] init];
    self.field = field;
    field.returnKeyType = UIReturnKeyDone;
//    field.clearButtonMode = UITextFieldViewModeWhileEditing;
    field.placeholder = @"计算机名称";
    field.font = [UIFont systemFontOfSize:15.0];
    field.textColor = [UIColor darkGrayColor];
    field.textAlignment = NSTextAlignmentCenter;
    field.adjustsFontSizeToFitWidth = YES;
    field.backgroundColor = [UIColor clearColor];
    field.layer.cornerRadius = 2;
    field.delegate = self;
    field.tag = 1000;
    field.returnKeyType = UIReturnKeyNext;
    [field addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.backView addSubview:field];
    [field mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView1);
    }];
    
    UITextField *macAddressField = [[UITextField alloc] init];
    self.macAddressField = macAddressField;
//    macAddressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    macAddressField.placeholder = @"MAC地址 (如4c25f43e6a48)";
    macAddressField.font = [UIFont systemFontOfSize:15.0];
    macAddressField.textColor = [UIColor darkGrayColor];
    macAddressField.textAlignment = NSTextAlignmentCenter;
    macAddressField.adjustsFontSizeToFitWidth = YES;
    macAddressField.backgroundColor = [UIColor clearColor];
    macAddressField.layer.cornerRadius = 2;
    macAddressField.delegate = self;
    macAddressField.tag = 1001;
    macAddressField.returnKeyType = UIReturnKeyNext;
    [macAddressField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.backView addSubview:macAddressField];
    [macAddressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView2);
    }];

    UITextField *broadAddressField = [[UITextField alloc] init];
    self.broadAddressField = broadAddressField;
//    broadAddressField.clearButtonMode = UITextFieldViewModeWhileEditing;
    broadAddressField.placeholder = @"广播地址 (如192.168.x.255)";
    broadAddressField.font = [UIFont systemFontOfSize:15.0];
    broadAddressField.textColor = [UIColor darkGrayColor];
    broadAddressField.textAlignment = NSTextAlignmentCenter;
    broadAddressField.adjustsFontSizeToFitWidth = YES;
    broadAddressField.backgroundColor = [UIColor whiteColor];
    broadAddressField.layer.cornerRadius = 2;
    broadAddressField.delegate = self;
    broadAddressField.tag = 1002;
    broadAddressField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    broadAddressField.returnKeyType = UIReturnKeyDone;
    [broadAddressField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    NSArray *ipArray = [[self getIpAddresses] componentsSeparatedByString:@"."];
    if (ipArray.count == 4) {
        broadAddressField.text = [NSString
                                  stringWithFormat:@"%@.%@.%@.255", ipArray[0], ipArray[1], ipArray[2]];
    }
    
    [self.backView addSubview:broadAddressField];
    [broadAddressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.shadowView3);
    }];

    
    // 背景
    UIView *footerView = [[UIView alloc] init];
    //    footerView.backgroundColor = TXBYColor(245, 245, 245);
    [self.backView addSubview:footerView];
    [footerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.broadAddressField.bottom).offset(60);
        make.left.equalTo(self.backView.left);
        make.right.equalTo(self.backView.right);
        make.height.equalTo(45);
    }];
    
    // 确认按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(sureClick)];
}

- (void)sureClick {
    self.navigationItem.rightBarButtonItem.enabled = NO;
    if (!self.field.text.length || !self.macAddressField.text.length || !self.broadAddressField.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请补全信息"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    } else if (self.macAddressField.text.length != 12) {
        [SVProgressHUD showInfoWithStatus:@"MAC地址有误"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    } else if (![self.broadAddressField.text isValidatIP]) {
        [SVProgressHUD showInfoWithStatus:@"广播地址有误"];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        return;
    }
    
    NSMutableArray *pcArray = [NSMutableArray arrayWithArray:[TXBYUserDefaults valueForKey:PCINFOCACHE]];
    if (!pcArray) {
        pcArray = [NSMutableArray array];
    }
        
    for (NSDictionary *dic in pcArray) {
        PCInfo *PC = [PCInfo mj_objectWithKeyValues:dic];
        if ([PC.name isEqualToString:self.field.text]) {
            [SVProgressHUD showInfoWithStatus:@"该名称PC已存在"];
            self.navigationItem.rightBarButtonItem.enabled = YES;
            return;
        }
    }
    PCInfo *newPC = [[PCInfo alloc] init];
    newPC.name = self.field.text;
    newPC.mac = self.macAddressField.text;
    newPC.ip = self.broadAddressField.text;
    if (!pcArray.count) {
        newPC.showInHome = @"yes";
    }
    [pcArray insertObject:newPC.mj_keyValues atIndex:0];
    
    [TXBYUserDefaults setValue:[NSArray arrayWithArray:pcArray] forKey:PCINFOCACHE];
    [SVProgressHUD showSuccessWithStatus:@"添加成功"];
//    [self performSelector:@selector(popView) withObject:nil afterDelay:1.0];
    [self.navigationController popViewControllerAnimated:YES];
    [self updateShortcutItem];
    
    [TXBYUserDefaults synchronize];
}

- (void)popView {
    
}

// 获得焦点
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.shadowView1.layer.shadowOpacity = 0.4;
        self.shadowView1.layer.shadowRadius = 3;
    } else if (textField.tag == 1001) {
        self.shadowView2.layer.shadowOpacity = 0.4;
        self.shadowView2.layer.shadowRadius = 3;
    } else {
        self.shadowView3.layer.shadowOpacity = 0.4;
        self.shadowView3.layer.shadowRadius = 3;
    }
    return YES;
}

// 失去焦点
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 1000) {
        self.shadowView1.layer.shadowOpacity = 0.2;
        self.shadowView1.layer.shadowRadius = 2;
    } else if (textField.tag == 1001) {
        self.shadowView2.layer.shadowOpacity = 0.2;
        self.shadowView2.layer.shadowRadius = 2;
    } else {
        self.shadowView3.layer.shadowOpacity = 0.2;
        self.shadowView3.layer.shadowRadius = 2;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//    [self.view endEditing:YES];
    if (textField.tag == 1000) {
        self.index = 1001;
        [self.macAddressField becomeFirstResponder];
    } else if (textField.tag == 1001) {
        self.index = 1002;
        [self.broadAddressField becomeFirstResponder];
    } else {
        [self.view endEditing:YES];
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField {
    
}


/**
 *  添加键盘监听
 */
- (void)setupKeyboard {
    // 监听键盘的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

/**
 *  当键盘改变了frame(位置和尺寸)的时候调用
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note {
    // 设置窗口的颜色
    self.view.window.backgroundColor = self.view.backgroundColor;
    
    // 0.取出键盘动画的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 1.取得键盘最后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    // 2.计算控制器的view需要平移的距离
    CGFloat transformY = (keyboardFrame.origin.y == [UIScreen mainScreen].bounds.size.height) ? 0:  iPhone6? (-60): iPhone6p? (-40): -80;
    
    // 3.执行动画
    [UIView animateWithDuration:duration animations:^{
        //        self.view.transform = CGAffineTransformMakeTranslation(0, transformY);
        //        self.logoView.alpha = (transformY < 0)? 0: 1;
        self.backView.transform = CGAffineTransformMakeTranslation(0, transformY);
    }];
}

- (NSString *)title {
    return @"添加PC";
}

@end
