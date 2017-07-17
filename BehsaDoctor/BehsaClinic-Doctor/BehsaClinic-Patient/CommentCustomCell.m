//
//  CommentCustomCell.m
//  MSN
//
//  Created by Yarima on 11/23/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import "CommentCustomCell.h"

@interface CommentCustomCell()
@property (weak, nonatomic) CommentEntity *entity;
@end

@implementation CommentCustomCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    
    return self;
}

#pragma mark - Public method
- (void)setEntity:(CommentEntity *)entity indexPath:(NSIndexPath *)indexPath{
    //entity.dictionary = entity.dictionary;
    [_authorImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", entity.dictionary.LPUserAvatarUrl]] placeholderImage:[UIImage imageNamed:@"broken_image"]];
    
    _authorNameLabel.text = entity.dictionary.LPUserTitle;
    
    //date
    NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc]init];
    [currentDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *endDate = [NSDate date];
    
    double timestampval = [[entity.dictionary objectForKey:@"created_at"]doubleValue];
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    _dateLabel.text = [NSString stringWithFormat:@"%@",
                           [TimeAgoViewController timeIntervalWithStartDate:startDate withEndDate:endDate]];
    
    _contentLabel.text = [entity.dictionary objectForKey:@"comment"];
    //cell.contentLabel.backgroundColor = [UIColor redColor];
    
    CGRect rect = _contentLabel.frame;
    rect.size.height = [_contentLabel.text getHeightOfString];
    _contentLabel.frame = rect;
    
    _replyButton = [CustomButton initButtonWithTitle:@"جواب" withTitleColor:MAIN_COLOR withBackColor:[UIColor clearColor] withFrame:CGRectMake(10, _contentLabel.frame.origin.y+ _contentLabel.frame.size.height + 5, 40, 30)];
    [self addSubview:_replyButton];
    _replyButton.tag = indexPath.row;
    [_replyButton addTarget:self action:@selector(replyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (entity.profileID == [[[entity.dictionary objectForKey:@"entity"]objectForKey:@"user_id"]integerValue]) {
        _deleteButton = [CustomButton initButtonWithTitle:@"حذف" withTitleColor:MAIN_COLOR withBackColor:[UIColor clearColor] withFrame:CGRectMake(60, _contentLabel.frame.origin.y+ _contentLabel.frame.size.height + 5, 40, 30)];
        [self addSubview:_reportButton];
        _deleteButton.tag = indexPath.row;
        [_deleteButton addTarget:self action:@selector(deleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_deleteButton];
    } else {
        _reportButton = [CustomButton initButtonWithTitle:@"گزارش" withTitleColor:MAIN_COLOR withBackColor:[UIColor clearColor] withFrame:CGRectMake(60, _contentLabel.frame.origin.y+ _contentLabel.frame.size.height + 5, 40, 30)];
        //[self addSubview:_reportButton];
        _reportButton.tag = indexPath.row;
        [_reportButton addTarget:self action:@selector(reportButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //customize for reply comment
    if ([entity.dictionary count] == 8) {
        CGRect rect = _authorImageView.frame;
        rect.origin.x = rect.origin.x - 20;
        _authorImageView.frame = rect;
        
        rect = _authorNameLabel.frame;
        rect.origin.x = rect.origin.x - 20;
        _authorNameLabel.frame = rect;
        
        rect = _contentLabel.frame;
        rect.origin.y = _authorNameLabel.frame.origin.y + 36;
        rect.size.width = screenWidth - 55;
        rect.size.height = [[entity.dictionary objectForKey:@"comment"] getHeightOfString2];
        _contentLabel.frame = rect;
        
        UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(20, _contentLabel.frame.origin.y + _contentLabel.frame.size.height - 20, screenWidth - 40, 0.5)];
        horizontalLine.backgroundColor = [UIColor lightGrayColor];
        //[cell addSubview:horizontalLine];
        
        _replyButton.hidden = YES;
        
        rect = _reportButton.frame;
        rect.origin.y = _contentLabel.frame.origin.y + _contentLabel.frame.size.height;
        _reportButton.frame = rect;
        
        rect = _deleteButton.frame;
        rect.origin.y = _contentLabel.frame.origin.y + _contentLabel.frame.size.height;
        _deleteButton.frame = rect;
    }
}

#pragma mark - Private method

- (void)initView {
    NSInteger authorImageWidth = 40;
    self.authorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - authorImageWidth - 20, 2, authorImageWidth, authorImageWidth)];
    self.authorImageView.layer.cornerRadius = authorImageWidth / 2;
    self.authorImageView.clipsToBounds = YES;
    [self addSubview:self.authorImageView];
    
    self.authorNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.authorImageView.frame.origin.y + 10, screenWidth - authorImageWidth - 40, 25)];
    self.authorNameLabel.font = FONT_NORMAL(13);
    self.authorNameLabel.minimumScaleFactor = 0.7;
    self.authorNameLabel.textColor = [UIColor blackColor];
    self.authorNameLabel.textAlignment = NSTextAlignmentRight;
    self.authorNameLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.authorNameLabel];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2, 80, 25)];
    self.dateLabel.font = FONT_NORMAL(11);
    self.dateLabel.minimumScaleFactor = 0.7;
    self.dateLabel.textColor = [UIColor lightGrayColor];
    self.dateLabel.textAlignment = NSTextAlignmentLeft;
    self.dateLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:self.dateLabel];
    
    self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.authorImageView.frame.origin.y + self.authorImageView.frame.size.height - 10, screenWidth - 30, 60)];
    self.contentLabel.font = FONT_NORMAL(15);
    if (IS_IPAD) {
        self.contentLabel.font = FONT_NORMAL(19);
        self.contentLabel.frame = CGRectMake(10, self.authorImageView.frame.origin.y + self.authorImageView.frame.size.height + 10, screenWidth - 20, 200);
    }
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.contentLabel];
}

- (void)replyButtonAction:(id)sender{
    [_delegate replyButtonAction:sender];
}

- (void)reportButtonAction:(id)sender{
    [_delegate reportButtonAction:sender];
}

- (void)deleteButtonAction:(id)sender{
    [_delegate deleteButtonAction:sender];
}

@end
