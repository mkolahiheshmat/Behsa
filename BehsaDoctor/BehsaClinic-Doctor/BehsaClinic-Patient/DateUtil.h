//
//  DateUtil.h
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/27/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtil : NSObject
+ (BOOL)isSecondDateGreaterThanEqualFirstDate:(NSDictionary *)firstDate secondDate:(NSDictionary *)secondDate;
+ (NSInteger)convertMonthNameToNumber:(NSString *)monthStr;
+ (NSString *)convertMonthNumberToMonthName:(NSString *)month;
@end
