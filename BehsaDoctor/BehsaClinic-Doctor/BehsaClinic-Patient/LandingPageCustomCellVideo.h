//
//  CustomCell2.h
//  AdvisorsHealthCloud
//
//  Created by Arash on 12/26/15.
//  Copyright © 2015 Arash. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TABLEVIEW_CELL_HEIGHT   300
#define TABLEVIEW_CELL_HEIGHT_Iphone6   380
@protocol VideoCellDelegate <NSObject>
@required
- (void)commentImageViewAction:(UITapGestureRecognizer *)tap;
- (void)videoButtonAction:(id)sender;
- (void)audioButtonAction:(id)sender;
- (void)tapOnAuthorImage:(UITapGestureRecognizer *)tap;
- (void)favButtonAction:(id)sender;
- (void)likeButtonAction:(id)sender;
- (void)shareButtonAction:(id)sender;
@end

@interface LandingPageCustomCellVideo : UITableViewCell
@property(nonatomic, retain)UILabel *titleLabel;
@property(nonatomic, retain)UILabel *jobLabel;
@property(nonatomic, retain)UILabel *dateLabel;
@property(nonatomic, retain)UILabel *categoryLabel;
@property(nonatomic, retain)UIImageView *postImageView;
@property(nonatomic, retain)UILabel *likeCountLabel;
@property(nonatomic, retain)UILabel *commentCountLabel;
@property(nonatomic, retain)UIImageView *authorImageView;
@property(nonatomic, retain)UILabel *authorNameLabel;
@property(nonatomic, retain)UILabel *authorJobLabel;
@property(nonatomic, retain)UILabel *contentLabel;
@property(nonatomic, retain)UIImageView *commentImageView;
@property(nonatomic, retain)UIButton *favButton;
@property(nonatomic, retain)UIButton *heartButton;
@property(nonatomic, retain)UIButton *shareButton;
@property(nonatomic, retain)UIButton *videoButton;
@property (weak, nonatomic) id <VideoCellDelegate> delegate;
- (LandingPageCustomCellVideo *)setEntity:(NSDictionary *)entity indexPath:(NSIndexPath *)indexPath;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier coverRatio:(CGFloat)coverRatio;
@end
