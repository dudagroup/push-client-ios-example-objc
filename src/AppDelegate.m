//
//  AppDelegate.m
//  PushClientExampleObjC
//
//  Created by Till Hagger on 20/05/15.
//  Copyright (c) 2015 DU DA Group. All rights reserved.
//

#import "AppDelegate.h"
#import <PushClientExampleObjC-Swift.h>


@implementation AppDelegate
{
    PushClient* _pushClient;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _pushClient = [[PushClient alloc] initWithPushServerUrl:[NSURL URLWithString:@"http://192.168.1.133:3000/"]];
    
    if (PushClientHelper.mustRegisterUserNotificationSettings) {
        UIUserNotificationType types = UIUserNotificationTypeAlert |
                                       UIUserNotificationTypeBadge |
                                       UIUserNotificationTypeSound;
        
        [PushClientHelper registerUserNotificationSettingsWithTypes:types
                                                         categories:nil];
    } else {
    
        UIRemoteNotificationType types = UIRemoteNotificationTypeAlert |
                                         UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound;
        
        [PushClientHelper registerForRemoteNotificationTypesWithTypes:types];
    }
    
    [PushClientHelper addCallbackHandler:^(NSDictionary * __nonnull userInfo, BOOL fromBackground) {
        NSLog(@"userInfo %@", userInfo);
        NSLog(@"fromBackground %i", fromBackground);
    }];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [_pushClient subscribe:deviceToken domain:@"test" customData:nil];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Register Error %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PushClientHelper receivedRemoteNotification:userInfo];
}


@end
