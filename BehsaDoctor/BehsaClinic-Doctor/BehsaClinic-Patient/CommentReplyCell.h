//
//  CommentCustomCell.h
//  MSN
//
//  Created by Yarima on 11/23/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentReplyEntity.h"

@protocol CommentReplyCellDelegate <NSObject>
@required
- (void)reportButtonAction:(id)sender;
- (void)deleteButtonAction:(id)sender;
@end

@interface CommentReplyCell : UITableViewCell
@property(nonatomic, retain)UIImageView *authorImageView;
@property(nonatomic, retain)UILabel *authorNameLabel;
@property(nonatomic, retain)UILabel *dateLabel;
@property(nonatomic, retain)UILabel *contentLabel;
@property(nonatomic, retain)UIButton *replyButton;
@property(nonatomic, retain)UIButton *reportButton;
@property(nonatomic, retain)UIButton *deleteButton;
@property (weak, nonatomic) id <CommentReplyCellDelegate> delegate;
- (void)setEntity:(CommentReplyEntity *)entity indexPath:(NSIndexPath *)indexPath;
@end
