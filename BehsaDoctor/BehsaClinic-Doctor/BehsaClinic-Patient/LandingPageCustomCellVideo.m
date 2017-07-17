//
//  CustomCell2.m
//  AdvisorsHealthCloud
//
//  Created by Arash on 12/26/15.
//  Copyright © 2015 Arash. All rights reserved.
//

#import "LandingPageCustomCellVideo.h"
#import "Header.h"
#import "CustomButton.h"
@implementation LandingPageCustomCellVideo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier coverRatio:(CGFloat)coverRatio{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViewcoverRatio:(CGFloat)coverRatio];
    }
    return self;
}

#pragma mark - Public method
- (LandingPageCustomCellVideo *)setEntity:(NSDictionary *)entity indexPath:(NSIndexPath *)indexPath{
    //title
    _titleLabel.text = entity.LPTVTitle;
    
    //action for video
    _videoButton.tag = indexPath.row;
    [_videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //date
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc]init];
    [currentDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [NSDate date];
    
    double timestampval = [entity.LPTVPublish_date doubleValue];
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    _dateLabel.text = [NSString stringWithFormat:@"%@",
                       [TimeAgoViewController timeIntervalWithStartDate:startDate withEndDate:endDate]];
    
    //post image
    [_postImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", entity.LPTVImageUrl]] placeholderImage:[UIImage imageNamed:@"broken_image"]];
    
    //category
    _categoryLabel.text = entity.LPTVCategoryName;
    if ([_categoryLabel.text length] == 0) {
        _categoryLabel.text = entity.LPCategoryName;
    }
    //seen label
    _commentCountLabel.text = entity.LPTVRecommends_count;
    self.commentCountLabel.text = [self.commentCountLabel.text convertEnglishNumbersToFarsi];
    //like label
    _likeCountLabel.text = entity.LPTVLikes_count;
    self.likeCountLabel.text = [self.likeCountLabel.text convertEnglishNumbersToFarsi];
    _likeCountLabel.tag = indexPath.row;
    //author image
    [_authorImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", entity.LPTVUserAvatarUrl]] placeholderImage:[UIImage imageNamed:@"dontprofile"]];
    _authorImageView.userInteractionEnabled = YES;
    _authorImageView.tag = indexPath.row;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapOnAuthorImage:)];
    [_authorImageView addGestureRecognizer:tap];
    
    //author name
    _authorNameLabel.text = entity.LPTVUserTitle;
    _authorNameLabel.userInteractionEnabled = YES;
    _authorNameLabel.tag = indexPath.row;
    UITapGestureRecognizer *tap22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnAuthorImage:)];
    [_authorNameLabel addGestureRecognizer:tap22];
    
    //author job title
    _authorJobLabel.text = entity.LPTVUserJobTitle;
    
    //content
    _contentLabel.text = entity.LPTVContent;
    _commentImageView.tag = indexPath.row;
    _commentImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentImageViewAction:)];
    [_commentImageView addGestureRecognizer:tap2];
    
    _favButton.tag = indexPath.row;
    [_favButton addTarget:self action:@selector(favButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _heartButton.tag = indexPath.row;
    [_heartButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _shareButton.tag = indexPath.row;
    [_shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([entity.LPTVFavorite integerValue] == 0) {
        [_favButton setImage:[UIImage imageNamed:@"fav off"] forState:UIControlStateNormal];
    }else{
        [_favButton setImage:[UIImage imageNamed:@"fav on"] forState:UIControlStateNormal];
    }
    
    if ([entity.LPTVLiked integerValue] == 0) {
        [_heartButton setImage:[UIImage imageNamed:@"like icon"] forState:UIControlStateNormal];
    }else{
        [_heartButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
    return self;
}

#pragma mark - Private method
- (void)initViewcoverRatio:(CGFloat)coverRatio{
    NSInteger authorImageWidth = 50;
    self.authorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - authorImageWidth - 20, 20, authorImageWidth, authorImageWidth)];
    self.authorImageView.layer.cornerRadius = authorImageWidth / 2;
    self.authorImageView.clipsToBounds = YES;
    [self addSubview:self.authorImageView];
    
    self.authorNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.authorImageView.frame.origin.y + 10, screenWidth - authorImageWidth - 50, 25)];
    self.authorNameLabel.font = FONT_NORMAL(15);
    self.authorNameLabel.minimumScaleFactor = 0.7;
    self.authorNameLabel.textColor = MAIN_COLOR;
    self.authorNameLabel.textAlignment = NSTextAlignmentRight;
    self.authorNameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.authorNameLabel];
    
    self.authorJobLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.authorNameLabel.frame.origin.y + 20, screenWidth - authorImageWidth - 40, 25)];
    self.authorJobLabel.font = FONT_NORMAL(11);
    self.authorJobLabel.minimumScaleFactor = 0.7;
    self.authorJobLabel.textColor = [UIColor grayColor];
    self.authorJobLabel.textAlignment = NSTextAlignmentRight;
    self.authorJobLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.authorJobLabel];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, self.authorImageView.frame.origin.y + self.authorImageView.frame.size.height + 0, screenWidth - 120, 30)];
    self.titleLabel.font = FONT_NORMAL(17);
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.minimumScaleFactor = 0.7;
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.titleLabel];
    
    self.jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, screenWidth - 30, 45)];
    self.jobLabel.font = FONT_NORMAL(16);
    self.jobLabel.numberOfLines = 2;
    self.jobLabel.minimumScaleFactor = 0.5;
    self.jobLabel.textAlignment = NSTextAlignmentRight;
    self.jobLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.jobLabel];
    
    //268 × 75
    UIImageView *categoryBGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 107.2, 30)];
    categoryBGImageView.image = [UIImage imageNamed:@"kadr"];
    [self addSubview:categoryBGImageView];
    
    //290 × 68
    UIImageView *blurBGImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 107, self.postImageView.frame.size.height - 25, 107.3, 25)];
    blurBGImageView.image = [UIImage imageNamed:@"blur"];
    [self.postImageView addSubview:blurBGImageView];
    
    //44 × 22
    UIImageView *seenImageView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 9, 22, 11)];
    seenImageView.image = [UIImage imageNamed:@"see icon"];
    //[blurBGImageView addSubview:seenImageView];
    
    self.categoryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, categoryBGImageView.frame.size.width, categoryBGImageView.frame.size.height)];
    self.categoryLabel.font = FONT_NORMAL(11);
    self.categoryLabel.minimumScaleFactor = 0.7;
    self.categoryLabel.textColor = [UIColor whiteColor];
    self.categoryLabel.textAlignment = NSTextAlignmentCenter;
    self.categoryLabel.adjustsFontSizeToFitWidth = YES;
    [categoryBGImageView addSubview:self.categoryLabel];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height, screenWidth - 20, 60)];
    self.contentLabel.font = FONT_NORMAL(15);
    if (IS_IPAD) {
        self.contentLabel.font = FONT_NORMAL(19);
        self.contentLabel.frame = CGRectMake(10, self.authorImageView.frame.origin.y + self.authorImageView.frame.size.height + 10, screenWidth - 20, 200);
    }
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.contentLabel];
    
    self.postImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.contentLabel.frame.origin.y + self.contentLabel.frame.size.height, screenWidth, screenWidth / coverRatio)];
    self.postImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.postImageView.userInteractionEnabled = YES;
    self.postImageView.clipsToBounds = YES;
    [self addSubview:self.postImageView];
    
    _videoButton = [CustomButton initButtonWithImage:[UIImage imageNamed:@"iconvideo"] withFrame:CGRectMake(screenWidth/2 - 23, self.postImageView.frame.size.height/2 - 25, 93 / 2, 99 / 2)];
    [_postImageView addSubview:_videoButton];
    
    //52 × 49
    self.heartButton = [[UIButton alloc]initWithFrame:CGRectMake(20, _postImageView.frame.origin.y+ _postImageView.frame.size.height + 5, 52 * 0.4, 49*0.4)];
    [self.heartButton setImage:[UIImage imageNamed:@"like icon"] forState:UIControlStateNormal];
    [self addSubview:self.heartButton];
    
    self.likeCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.heartButton.frame.origin.x + self.heartButton.frame.size.width + 2, _postImageView.frame.origin.y+ _postImageView.frame.size.height + 5, 20, 20)];
    self.likeCountLabel.font = FONT_NORMAL(11);
    self.likeCountLabel.minimumScaleFactor = 0.7;
    self.likeCountLabel.textColor = [UIColor grayColor];
    self.likeCountLabel.textAlignment = NSTextAlignmentLeft;
    self.likeCountLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.likeCountLabel];
    
    //46 × 49
    self.commentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.likeCountLabel.frame.origin.x + self.likeCountLabel.frame.size.width + 10, _postImageView.frame.origin.y+ _postImageView.frame.size.height + 5, 46*0.4, 49*0.4)];
    self.commentImageView.image = [UIImage imageNamed:@"comment"];
    [self addSubview:self.commentImageView];
    
    self.commentCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.commentImageView.frame.origin.x + self.commentImageView.frame.size.width + 2, _postImageView.frame.origin.y+ _postImageView.frame.size.height + 5, 20, 20)];
    self.commentCountLabel.font = FONT_NORMAL(11);
    self.commentCountLabel.minimumScaleFactor = 0.7;
    self.commentCountLabel.textColor = [UIColor grayColor];
    self.commentCountLabel.textAlignment = NSTextAlignmentLeft;
    self.commentCountLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.commentCountLabel];
    
    
    //46 × 43
    self.favButton = [[UIButton alloc]initWithFrame:CGRectMake(self.commentCountLabel.frame.origin.x + self.commentCountLabel.frame.size.width + 10, _postImageView.frame.origin.y+ _postImageView.frame.size.height + 5, 46 * 0.4, 43 * 0.4)];
    [self.favButton setImage:[UIImage imageNamed:@"fav off"] forState:UIControlStateNormal];
    [self addSubview:self.favButton];
    
    //35 × 44
    self.shareButton = [[UIButton alloc]initWithFrame:CGRectMake(self.favButton.frame.origin.x + self.favButton.frame.size.width + 18, _postImageView.frame.origin.y+ _postImageView.frame.size.height + 5, 35*0.4, 44*0.4)];
    [self.shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [self addSubview:self.shareButton];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 110, _shareButton.frame.origin.y, 100, 25)];
    self.dateLabel.font = FONT_NORMAL(11);
    self.dateLabel.minimumScaleFactor = 0.7;
    self.dateLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.dateLabel];
    
}

- (void)commentImageViewAction:(UITapGestureRecognizer *)tap{
    [_delegate commentImageViewAction:tap];
}

- (void)videoButtonAction:(id)sender{
    [_delegate videoButtonAction:sender];
}

- (void)audioButtonAction:(id)sender{
    [_delegate audioButtonAction:sender];
}

- (void)tapOnAuthorImage:(UITapGestureRecognizer *)tap{
    [_delegate tapOnAuthorImage:tap];
}

- (void)favButtonAction:(id)sender{
    [_delegate favButtonAction:sender];
}
- (void)likeButtonAction:(id)sender{
    [_delegate likeButtonAction:sender];
}
- (void)shareButtonAction:(id)sender{
    [_delegate shareButtonAction:sender];
}

@end
