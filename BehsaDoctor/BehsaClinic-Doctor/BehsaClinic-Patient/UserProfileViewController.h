//
//  FirstViewController.h
//  MSN
//
//  Created by Yarima on 11/5/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UserProfileViewController : BaseViewController
//@property(nonatomic, retain)NSDictionary *dictionary;
@property(nonatomic)NSInteger entityID;
@property(nonatomic, retain)NSString *nameString;
@property(nonatomic)BOOL isFromPushNotif;
@end
