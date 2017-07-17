//
// Created by Arash on 15/12/5.
// Copyright (c) 2015 Arash Z. Jahangiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThirdViewNowEntity : NSObject
@property (copy, nonatomic) NSString *nameString;
@property (copy, nonatomic) NSString *descriptionString;
@property (copy, nonatomic) NSString *timeStartString;
@property (copy, nonatomic) NSString *timeEndString;
@property (copy, nonatomic) NSString *statusString;
@property (copy, nonatomic) NSString *aliasString;
@property (copy, nonatomic) NSString *jalaliDateString;
@property NSInteger patientID;
@property double dateTimeStamp;
@end
