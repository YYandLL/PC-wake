//
//  HomeViewController.m
//  pc-wake
//
//  Created by YandL on 2017/5/17.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "HomeViewController.h"
#import "SocketConnect.h"
#import "AddPCViewController.h"
#import "PCInfo.h"
#import "wakeParam.h"

@interface HomeViewController ()
/**
 * sendBtn
 */
@property (nonatomic, strong) UIButton *sendBtn;
/**
 * <#name#>
 */
@property (nonatomic, strong) NSArray *PCArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationItem];
    [self setupTableView];
//    [self sendMessage];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSArray *PCArray = [TXBYUserDefaults valueForKey:PCINFOCACHE];
    self.PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:PCArray];
}

- (void)setPCArray:(NSArray *)PCArray {
    _PCArray = PCArray;
    [self deleteEmptyText];
    if (!PCArray.count) {
        [self emptyViewWithText:@"暂无设备\n点击右上角添加" andImg:[UIImage imageNamed:@"nodata"]];
    } else {
        [self deleteEmptyText];
    }
    [self.tableView reloadData];
}

- (void)setNavigationItem {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)addClick {
    AddPCViewController *addVC = [[AddPCViewController alloc] init];
    [self.navigationController pushViewController:addVC animated:YES];
}

- (void)sendMessage {
    NSString *macAddress = @"4CCC6AFB0C34";
    Byte mac[6] = {};
    for (int i = 0; i < macAddress.length; i +=2) {
        NSString *strByte = [macAddress substringWithRange:NSMakeRange(i, 2)];
        unsigned long red = strtoul([strByte UTF8String], 0, 16);
        
        Byte b = (Byte)((0xff & red));
        mac[i / 2 + 0] = b;
    }
    
    Byte packet[17 * 6] = {};
    for (int i = 0 ; i < 6; i++) {
        packet[i] = 0xFF;
        for (int i = 1; i <= 16; i++) {
            for (int j = 0; j < 6; j++) {
                packet[i * 6 + j] = mac[j];
            }
        }
    }
    
    SocketConnect *socket = [SocketConnect sharedInstance];
    //设置端口号为8888
    socket.hostPort = 1001;
    
    NSData *data = [NSData dataWithBytes:packet length:sizeof(packet)];
    [socket wakeUp:data host:@"114.217.200.128" result:^(BOOL result) {
        //消息是否发送成功的回调
        NSLog(@"%d",result);
    }];
}

- (void)wakeUpPC:(PCInfo *)info {
    //被控制的电脑主机的mac地址
//    NSString *macAddress = @"4CCC6AFB0C34";
    NSString *macAddress = info.mac;
    
    Byte mac[6] = {};
    for (int i = 0; i < macAddress.length; i +=2) {
        NSString *strByte = [macAddress substringWithRange:NSMakeRange(i, 2)];
        unsigned long red = strtoul([strByte UTF8String], 0, 16);
        
        Byte b = (Byte)((0xff & red));
        mac[i / 2 + 0] = b;
    }

    Byte packet[17 * 6] = {};
    for (int i = 0 ; i < 6; i++) {
        packet[i] = 0xFF;
        for (int i = 1; i <= 16; i++) {
            for (int j = 0; j < 6; j++) {
                packet[i * 6 + j] = mac[j];
            }
        }
    }

    SocketConnect *socket = [SocketConnect sharedInstance];
    socket.hostPort = 1001;
    
    NSData *data = [NSData dataWithBytes:packet length:sizeof(packet)];
    [socket wakeUp:data host:info.ip result:^(BOOL result) {
        //消息是否发送成功的回调
        [SVProgressHUD showSuccessWithStatus:@"操作成功"];
    }];
}


- (void)requestToWake:(NSString *)address {
//    WeakSelf;
    [SVProgressHUD showWithStatus:@"请稍候.."];
    wakeParam *param = [wakeParam param];
    param.address = address;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[TXBYHTTPSessionManager sharedManager] encryptPost:wakeupAddress parameters:param.mj_keyValues netIdentifier:TXBYClassName success:^(id responseObject) {
        [SVProgressHUD dismiss];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if ([responseObject[@"errcode"] integerValue] == 200) {
            // 成功
            [SVProgressHUD showSuccessWithStatus:@"操作成功"];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"操作失败"];
        }
    } failure:^(NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma marks - tableViewDelegate 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.PCArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseID = @"PCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseID];
    }
    PCInfo *info = self.PCArray[indexPath.row];
    cell.textLabel.text = info.name;
    cell.detailTextLabel.text = [self formatAddress:info.mac];
    
    NSString *imageName = @"TXBYCategory.bundle/common_card_middle_background";
    // 普通状态下背景图片
    UIImageView *backgroundView = [[UIImageView alloc] init];
    backgroundView.image = [UIImage resizedImageWithName:imageName];
    cell.backgroundView = backgroundView;
    // 点击时背景图片
    UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
    selectedBackgroundView.image = [UIImage resizedImageWithName:[imageName stringByAppendingString:@"_highlighted"]];
    cell.selectedBackgroundView = selectedBackgroundView;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSString *)formatAddress:(NSString *)address {
    NSMutableString *newAddress = [[NSMutableString alloc] initWithString:address];
    [newAddress insertString:@":" atIndex:10];
    [newAddress insertString:@":" atIndex:8];
    [newAddress insertString:@":" atIndex:6];
    [newAddress insertString:@":" atIndex:4];
    [newAddress insertString:@":" atIndex:2];
    return [NSString stringWithString:newAddress];
}

- (void)showInHome:(PCInfo *)selectInfo {
    for (PCInfo *info in self.PCArray) {
        if ([info.name isEqualToString:selectInfo.name]) {
            info.showInHome = @"yes";
        } else {
            info.showInHome = @"no";
        }
    }
    NSMutableArray *muArray = [NSMutableArray array];
    
    for (PCInfo *info in self.PCArray) {
        [muArray addObject:info.mj_keyValues];
    }
    [TXBYUserDefaults setValue:[NSArray arrayWithArray:muArray] forKey:PCINFOCACHE];
    [TXBYUserDefaults synchronize];
    self.PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:self.PCArray];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PCInfo *info = self.PCArray[indexPath.row];
    TXBYActionSheetItem *openItem = [TXBYActionSheetItem itemWithTitle:@"本地唤醒" operation:^{
        [self wakeUpPC:info];
    }];
    TXBYActionSheetItem *remoteOpenItem = [TXBYActionSheetItem itemWithTitle:@"网络唤醒" operation:^{
        [self requestToWake:info.mac];
    }];
    TXBYActionSheetItem *item = [TXBYActionSheetItem itemWithTitle:@"在widget显示" operation:^{
        [self showInHome:info];
    }];
    TXBYActionSheet *actionSheet = [TXBYActionSheet actionSheetWithTitle:@"操 作" otherButtonItems:@[openItem, remoteOpenItem, item]];
    actionSheet.operation = ^(NSInteger index){
        self.tableView.editing = NO;
    };
    [actionSheet show];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *pcArray = [NSMutableArray arrayWithArray:[TXBYUserDefaults valueForKey:PCINFOCACHE]];
        [pcArray removeObjectAtIndex:indexPath.row];
        [TXBYUserDefaults setValue:[NSArray arrayWithArray:pcArray] forKey:PCINFOCACHE];
        [SVProgressHUD showSuccessWithStatus:@"删除成功"];
        NSArray *PCArray = [TXBYUserDefaults valueForKey:PCINFOCACHE];
        self.PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:PCArray];
    }
    [self updateShortcutItem];
    [TXBYUserDefaults synchronize];
}

- (NSString *)title {
    return @"设备";
}

@end
