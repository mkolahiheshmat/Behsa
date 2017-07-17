//
//  SearchViewCustomCell.m
//  MSN
//
//  Created by Yarima on 4/30/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import "NewPostCell.h"
#import "Header.h"

@implementation NewPostCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
        
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *borderView = [[UIView alloc]initWithFrame:CGRectMake(10, 5, screenWidth - 20, 70)];
        borderView.layer.borderColor = MAIN_COLOR.CGColor;
        borderView.layer.borderWidth = 1.0;
        borderView.layer.cornerRadius = 8.0;
        borderView.clipsToBounds = YES;
        [self addSubview:borderView];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, screenWidth - 40, 45)];
        nameLabel.font = FONT_NORMAL(15);
        nameLabel.text = @"ایجاد پست جدید ...";
        nameLabel.textColor = MAIN_COLOR;
        nameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:nameLabel];
        
        //30 × 54
        UIImageView *voiceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50, 64* 0.3, 64 * 0.3)];
        voiceImageView.image = [UIImage imageNamed:@"voice icon"];
        //[self addSubview:voiceImageView];
        //43 × 47
        UIImageView *attachImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 50, 43* 0.3, 47 * 0.3)];
        attachImageView.image = [UIImage imageNamed:@"attach file"];
        [self addSubview:attachImageView];

    }
    return self;
}
@end
