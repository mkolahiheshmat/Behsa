//
//  CommentCustomCell.h
//  MSN
//
//  Created by Yarima on 11/23/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentEntity.h"

@protocol CommentCellDelegate <NSObject>
@required
- (void)replyButtonAction:(id)sender;
- (void)reportButtonAction:(id)sender;
- (void)deleteButtonAction:(id)sender;
@end

@interface CommentCustomCell : UITableViewCell
@property(nonatomic, retain)UIImageView *authorImageView;
@property(nonatomic, retain)UILabel *authorNameLabel;
@property(nonatomic, retain)UILabel *dateLabel;
@property(nonatomic, retain)UILabel *contentLabel;
@property(nonatomic, retain)UIButton *replyButton;
@property(nonatomic, retain)UIButton *reportButton;
@property(nonatomic, retain)UIButton *deleteButton;
@property (weak, nonatomic) id <CommentCellDelegate> delegate;
- (void)setEntity:(CommentEntity *)entity indexPath:(NSIndexPath *)indexPath;
@end
