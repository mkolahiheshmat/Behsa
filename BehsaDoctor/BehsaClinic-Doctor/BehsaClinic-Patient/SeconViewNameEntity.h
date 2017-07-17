//
// Created by Arash on 15/12/5.
// Copyright (c) 2015 Arash Z. Jahangiri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SeconViewNameEntity : NSObject
@property (copy, nonatomic) NSString *nameString;
@property (copy, nonatomic) NSString *statusString;
@property NSInteger patientID;
- (id)initwith:(id)my;
@end
