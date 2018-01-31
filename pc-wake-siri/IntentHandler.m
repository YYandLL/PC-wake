//
//  IntentHandler.m
//  pc-wake-siri
//
//  Created by YandL on 2017/5/24.
//  Copyright © 2017年 YandL. All rights reserved.
//

#import "IntentHandler.h"
#import "SocketConnect.h"
#import "PCInfo.h"
#import "yandl.pch"

// As an example, this class is set up to handle Message intents.
// You will want to replace this or add other intents as appropriate.
// The intents you wish to handle must be declared in the extension's Info.plist.

// You can test your example integration by saying things to Siri like:
// "Send a message using <myApp>"
// "<myApp> John saying hello"
// "Search for messages in <myApp>"

@interface IntentHandler () <INSendMessageIntentHandling>

/**
 * <#name#>
 */
@property (nonatomic, strong) NSArray *PCArray;
/**
 * <#name#>
 */
@property (nonatomic, strong) PCInfo *info;
@end

@implementation IntentHandler

- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}

#pragma mark - INSendMessageIntentHandling

// Implement resolution methods to provide additional information about your intent (optional).
- (void)resolveRecipientsForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(NSArray<INPersonResolutionResult *> *resolutionResults))completion {
    NSArray<INPerson *> *recipients = intent.recipients;
    // If no recipients were provided we'll need to prompt for a value.
    if (recipients.count == 0) {
        completion(@[[INPersonResolutionResult needsValue]]);
        return;
    }
    NSMutableArray<INPersonResolutionResult *> *resolutionResults = [NSMutableArray array];
    
    for (INPerson *recipient in recipients) {
        NSArray<INPerson *> *matchingContacts = @[recipient]; // Implement your contact matching logic here to create an array of matching contacts
        if (matchingContacts.count > 1) {
            // We need Siri's help to ask user to pick one from the matches.
            [resolutionResults addObject:[INPersonResolutionResult disambiguationWithPeopleToDisambiguate:matchingContacts]];

        } else if (matchingContacts.count == 1) {
            // We have exactly one matching contact
            [resolutionResults addObject:[INPersonResolutionResult successWithResolvedPerson:recipient]];
        } else {
            // We have no contacts matching the description provided
            [resolutionResults addObject:[INPersonResolutionResult unsupported]];
        }
    }
    completion(resolutionResults);
}

- (void)resolveContentForSendMessage:(INSendMessageIntent *)intent withCompletion:(void (^)(INStringResolutionResult *resolutionResult))completion {
//    NSString *text = intent.content;
//    if (text && ![text isEqualToString:@""]) {
//        completion([INStringResolutionResult successWithResolvedString:text]);
//    } else {
//        completion([INStringResolutionResult needsValue]);
//    }
    
    NSString *text = @"开机";
    completion([INStringResolutionResult successWithResolvedString:text]);
}

// Once resolution is completed, perform validation on the intent and provide confirmation (optional).

- (void)confirmSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse *response))completion {
    // Verify user is authenticated and your app is ready to send a message.
    
    INPerson *name = intent.recipients[0];
    [TXBYUserDefaults setValue:name.displayName forKey:@"lastMac"];
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSendMessageIntent class])];
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeReady userActivity:userActivity];
    completion(response);
}

// Handle the completed intent (required).

- (void)handleSendMessage:(INSendMessageIntent *)intent completion:(void (^)(INSendMessageIntentResponse *response))completion {
    // Implement your application logic to send a message here.
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@",intent.recipients[0]]);
    INPerson *name = intent.recipients[0];
    NSArray *PCArray = [TXBYUserDefaults valueForKey:PCINFOCACHE];
    
    self.PCArray = [PCInfo mj_objectArrayWithKeyValuesArray:PCArray];
    if (self.PCArray.count) {
        for (PCInfo *info in self.PCArray) {
            if ([info.name isEqualToString:name.displayName]) {
                self.info = info;
                [TXBYUserDefaults setValue:info.name forKey:@"lastMac"];
            }
        }
    }
    [self wakeUpPC:^(BOOL result) {
        NSLog(@"123");
    }];
    
    NSUserActivity *userActivity = [[NSUserActivity alloc] initWithActivityType:NSStringFromClass([INSendMessageIntent class])];
    INSendMessageIntentResponse *response = [[INSendMessageIntentResponse alloc] initWithCode:INSendMessageIntentResponseCodeSuccess userActivity:userActivity];
    
    completion(response);
}

// Implement handlers for each intent you wish to handle.  As an example for messages, you may wish to also handle searchForMessages and setMessageAttributes.

- (void)wakeUpPC:(void(^)(BOOL result))completion {
    //被控制的电脑主机的mac地址
    //    NSString *macAddress = @"4CCC6AFB0C34";
    NSString *macAddress = self.info.mac;
    
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
    [socket wakeUp:data host:self.info.ip result:^(BOOL result) {
        //消息是否发送成功的回调
        completion(result);
    }];
}



@end
