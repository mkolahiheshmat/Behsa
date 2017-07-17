//
//  Case8Cell.m
//  MasonryExample
//
//  Created by Arash on 15/12/5.
//  Copyright © 2015 Arash Z. Jahangiri. All rights reserved.
//

#import "AllSessionCell.h"

@interface AllSessionCell ()
@property (strong, nonatomic) UILabel *nameTitleLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) AllSessionEntity *entity;
@end

@implementation AllSessionCell
#pragma mark - Init

// UITableView dequeueReusableCellWithIdentifierCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

#pragma mark - Public method

- (void)setEntity:(AllSessionEntity *)entity indexPath:(NSIndexPath *)indexPath {
    _entity = entity;
    _indexPath = indexPath;
    _nameTitleLabel.text = @"نام:";
    _dateLabel.text = [ConvertToPersianDate convertToShamsi:entity.dateTimeStamp];
    _nameLabel.text = entity.nameString;
}

#pragma mark - Private method
- (void)initView {

    // name
    _nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 35, 10, 25, 25)];
    _nameTitleLabel.font = FONT_NORMAL(16);
    _nameTitleLabel.textAlignment = NSTextAlignmentRight;
    //[self addSubview:_nameTitleLabel];

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, screenWidth - 20, 25)];
    _nameLabel.font = FONT_NORMAL(16);
    
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_nameLabel];
    
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, screenWidth - 45, 25)];
    _dateLabel.font = FONT_NORMAL(16);
    _dateLabel.textColor = [UIColor redColor];
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_dateLabel];
}
@end
