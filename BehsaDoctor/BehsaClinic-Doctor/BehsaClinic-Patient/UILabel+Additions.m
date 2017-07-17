//
//  UILabel+Additions.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 3/13/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)
- (void)sizeToFitWithAlignmentRight {
    CGRect beforeFrame = self.frame;
    [self sizeToFit];
    CGRect afterFrame = self.frame;
    self.frame = CGRectMake(beforeFrame.origin.x + beforeFrame.size.width - afterFrame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

@end
