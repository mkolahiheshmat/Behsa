//
//  Header.h
//  BehsaClinic-Patient
//
//  Created by Yarima on 4/12/16.
//  Copyright © 2016 Arash. All rights reserved.
//

//#import <AFHTTPSessionManager.h>
#ifndef Header_h
#define Header_h

//Font
//#define FONT_NORMAL(s) [UIFont fontWithName:@"B Yekan" size:s]
#define FONT_NORMAL(s) [UIFont fontWithName:@"IRANSansMobile" size:s]

//device
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) // iPhone and iPod touch style UI

#define IS_IPHONE_5_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0f)
#define IS_IPHONE_6_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0f)
#define IS_IPHONE_6P_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS7 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0f)

#define IS_IPHONE_5_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 568.0f)
#define IS_IPHONE_6_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 667.0f)
#define IS_IPHONE_6P_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) == 736.0f)
#define IS_IPHONE_4_AND_OLDER_IOS8 (IS_IPHONE && ([[UIScreen mainScreen] nativeBounds].size.height/[[UIScreen mainScreen] nativeScale]) < 568.0f)

//screen size
#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight [[UIScreen mainScreen]bounds].size.height

//Color
#define MAIN_COLOR [UIColor colorWithRed:108/255.0 green:159/255.0 blue:240/255.0 alpha:1.0]
#define BUTTON_COLOR [UIColor colorWithRed:134/255.0 green:183/255.0 blue:255/255.0 alpha:1.0]
#define TOAST_COLOR [UIColor colorWithRed:62/255.0 green:90/255.0 blue:40/255.0 alpha:1.0]
#define INDICATOR_MORAJEAN_COLOR [UIColor colorWithRed:147/255.0 green:249/255.0 blue:246/255.0 alpha:1.0]
#define PREVIEW_COLOR [UIColor colorWithRed:51/255.0 green:204/255.0 blue:153/255.0 alpha:1.0]
#define BROKEN_COLOR [UIColor colorWithRed:162/255.0 green:203/255.0 blue:242/255.0 alpha:1.0]
//UDID
#define UDID  [[[UIDevice currentDevice] identifierForVendor] UUIDString]

//thread
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//view
#define SUPERVIEW   self.view
#endif /* Header_h */
