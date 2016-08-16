//
//  AgoraViewController.h
//  TeamLionGroupProject
//
//  Created by David Park on 8/16/16.
//  Copyright © 2016 TeamLion. All rights reserved.
//

#import <JSQMessagesViewController/JSQMessagesViewController.h>
#import <SendBirdSDK/SendBirdSDK.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <UIKit/UIKit.h>

#import "JSQMessages.h"
#import "JSQSBMessage.h"

@interface AgoraViewController : JSQMessagesViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, SBDConnectionDelegate, SBDChannelDelegate>


@end
