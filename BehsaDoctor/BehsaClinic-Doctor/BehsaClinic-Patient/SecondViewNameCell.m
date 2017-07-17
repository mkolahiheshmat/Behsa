//
//  Case8Cell.m
//  MasonryExample
//
//  Created by Arash on 15/12/5.
//  Copyright © 2015 Arash Z. Jahangiri. All rights reserved.
//

#import "SecondViewNameCell.h"

@interface SecondViewNameCell ()
@property (strong, nonatomic) UILabel *nameTitleLabel;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (weak, nonatomic) SeconViewNameEntity *entity;
@end

@implementation SecondViewNameCell
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

- (void)setEntity:(SeconViewNameEntity *)entity indexPath:(NSIndexPath *)indexPath {
    _entity = entity;
    _indexPath = indexPath;
    _nameTitleLabel.text = @"نام:";
    _nameLabel.text = entity.nameString;
    _statusLabel.text = entity.statusString;
}

#pragma mark - Private method

- (void)initView {

    // name
    _nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 35, 10, 25, 25)];
    _nameTitleLabel.font = FONT_NORMAL(16);
    _nameTitleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_nameTitleLabel];

    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, screenWidth - 60, 25)];
    _nameLabel.textColor = MAIN_COLOR;
    _nameLabel.font = FONT_NORMAL(16);
    
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_nameLabel];
    
    _statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, screenWidth - 45, 25)];
    _statusLabel.font = FONT_NORMAL(16);
    _statusLabel.textColor = [UIColor redColor];
    _statusLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_statusLabel];
}
@end
