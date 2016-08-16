//
//  JSQSBMessage.h
//  TeamLionGroupProject
//
//  Created by David Park on 8/16/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <SendBirdSDK/SendBirdSDK.h>
#import "JSQMessage.h"


@interface JSQSBMessage : JSQMessage

@property (strong, nonnull) SBDBaseMessage *message;

@end
