//
//  DateUtil.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/27/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "DateUtil.h"

@implementation DateUtil
+ (BOOL)isSecondDateGreaterThanEqualFirstDate:(NSDictionary *)firstDate secondDate:(NSDictionary *)secondDate{
    if ([[secondDate objectForKey:@"Year"]integerValue] == [[firstDate objectForKey:@"Year"]integerValue]) {
        if ([[secondDate objectForKey:@"Month"]integerValue] > [[firstDate objectForKey:@"Month"]integerValue]){
            return YES;
        }else if ([[secondDate objectForKey:@"Month"]integerValue] == [[firstDate objectForKey:@"Month"]integerValue]){
            if ([[secondDate objectForKey:@"Day"]integerValue] >= [[firstDate objectForKey:@"Day"]integerValue]){
                return YES;
            }else {//day comparison
                return NO;
            }
        }else if ([[secondDate objectForKey:@"Month"]integerValue] < [[firstDate objectForKey:@"Month"]integerValue]){
            return NO;
        }
    }else if ([[secondDate objectForKey:@"Year"]integerValue] > [[firstDate objectForKey:@"Year"]integerValue]) {
        return YES;
    }else if ([[secondDate objectForKey:@"Month"]integerValue] > [[firstDate objectForKey:@"Month"]integerValue]){
        return YES;
    }else if ([[secondDate objectForKey:@"Day"]integerValue] > [[firstDate objectForKey:@"Day"]integerValue]){
        return YES;
    }
    return NO;
}

+ (NSInteger)convertMonthNameToNumber:(NSString *)monthStr{
    
    NSInteger aNumber;
    if ([monthStr isEqualToString:NSLocalizedString(@"far", @"")]){
        aNumber = 0;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"ordi", @"")]){
        aNumber = 1;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"khordad", @"")]){
        aNumber = 2;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"tir", @"")]){
        aNumber = 3;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"mordad", @"")]){
        aNumber = 4;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"shahrivar", @"")]){
        aNumber = 5;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"mahr", @"")]){
        aNumber = 6;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"aban", @"")]){
        aNumber = 7;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"azar", @"")]){
        aNumber = 8;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"day", @"")]){
        aNumber = 9;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"bahman", @"")]){
        aNumber = 10;
    }else if ([monthStr isEqualToString:NSLocalizedString(@"esfand", @"")]){
        aNumber = 11;
    }
    return aNumber;
}

+ (NSString *)convertMonthNumberToMonthName:(NSString *)month{
    switch ([month integerValue]) {
        case 0:
            month = NSLocalizedString(@"far", @"");
            break;
        case 1:
            month = NSLocalizedString(@"ordi", @"");
            break;
        case 2:
            month = NSLocalizedString(@"khordad", @"");
            break;
        case 3:
            month = NSLocalizedString(@"tir", @"");
            break;
        case 4:
            month = NSLocalizedString(@"mordad", @"");
            break;
        case 5:
            month = NSLocalizedString(@"shahrivar", @"");
            break;
        case 6:
            month = NSLocalizedString(@"mahr", @"");
            break;
        case 7:
            month = NSLocalizedString(@"aban", @"");
            break;
        case 8:
            month = NSLocalizedString(@"aban", @"");
            break;
        case 9:
            month = NSLocalizedString(@"azar", @"");
            break;
        case 10:
            month = NSLocalizedString(@"day", @"");
            break;
        case 11:
            month = NSLocalizedString(@"bahman", @"");
            break;
        case 12:
            month = NSLocalizedString(@"esfand", @"");
            break;
        default:
            break;
    }
    
    return month;
}

@end
