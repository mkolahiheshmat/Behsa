//
//  BaseViewController.h
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/11/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
- (void)setTitleLabel:(NSString *)title;
- (void)makeTopView;
- (void)addOnTopView:(UIView *)aView;
- (void)dismissTextField;
- (void)showMenuButton;
@end
