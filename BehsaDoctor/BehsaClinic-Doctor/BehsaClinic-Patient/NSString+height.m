//
//  NSString+height.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 3/6/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "NSString+height.h"

@implementation NSString (height)
- (CGFloat)getHeightOfString{
    
    UIFont *font = FONT_NORMAL(16);
    if (IS_IPAD) {
        font = FONT_NORMAL(22);
    }
    CGSize sizeOfText = [self boundingRectWithSize: CGSizeMake(screenWidth - 10,CGFLOAT_MAX)
                                            options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                            attributes: [NSDictionary dictionaryWithObject:font
                                                                    forKey:NSFontAttributeName]
                                            context: nil].size;
    CGFloat height = sizeOfText.height + 50;
    return height;
}

- (CGFloat)getHeightOfString2{
    
    UIFont *font = FONT_NORMAL(15);
    if (IS_IPAD) {
        font = FONT_NORMAL(26);
    }
    CGSize sizeOfText = [self boundingRectWithSize: CGSizeMake(screenWidth - 30 - 50,CGFLOAT_MAX)
                                                options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes: [NSDictionary dictionaryWithObject:font
                                                                                     forKey:NSFontAttributeName]
                                                context: nil].size;
    CGFloat height = sizeOfText.height;
    return height;
    
}

- (CGFloat)getWidthOfString{
    
    UIFont *font = FONT_NORMAL(16);
    if (IS_IPAD) {
        font = FONT_NORMAL(22);
    }
    CGSize sizeOfText = [self boundingRectWithSize: CGSizeMake(screenWidth - 10,CGFLOAT_MAX)
                                           options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes: [NSDictionary dictionaryWithObject:font
                                                                                forKey:NSFontAttributeName]
                                           context: nil].size;
    CGFloat width = sizeOfText.width;
    return width;
}

- (NSString *)separator{
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setCurrencySymbol:@""];
    [numberFormatter setLocale:[NSLocale currentLocale]];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *string = [numberFormatter stringFromNumber:[NSNumber numberWithInteger:[self integerValue]]];
    return string;
}
@end
