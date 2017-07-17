//
//  Case8Cell.m
//  MasonryExample
//
//  Created by Arash on 15/12/5.
//  Copyright © 2015 Arash Z. Jahangiri. All rights reserved.
//

#import "ThirdViewCalendarCell.h"

@interface ThirdViewCalendarCell ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *dateLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;
@property (weak, nonatomic) ThirdViewCalendarEntity *entity;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation ThirdViewCalendarCell
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

- (void)setEntity:(ThirdViewCalendarEntity *)entity indexPath:(NSIndexPath *)indexPath {
    _entity = entity;
    _indexPath = indexPath;
    _dateLabel.text = entity.jalaliDateString;//[ConvertToPersianDate convertToShamsiWithoutWeekDay:entity.dateTimeStamp];
    _dateLabel.text = [_dateLabel.text stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    if ([entity.aliasString isEqualToString:@"canceled"]) {
        _descriptionLabel.textColor = [UIColor redColor];
    }
    _descriptionLabel.text = [NSString stringWithFormat:@"%@", entity.statusString];
    _nameLabel.text = entity.nameString;
    NSString *hour1 = entity.timeStartString;
    NSString *hour2 = entity.timeEndString;
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@", hour1, NSLocalizedString(@"hour2", @""), hour2];
}

#pragma mark - Private method

- (void)initView {
    _dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, screenWidth/2, 25)];
    _dateLabel.font = FONT_NORMAL(13);
    _dateLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_dateLabel];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, 5, screenWidth/2 - 10, 25)];
    _nameLabel.font = FONT_NORMAL(16);
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_nameLabel];
    
    _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, screenWidth - 20, 25)];
    _descriptionLabel.font = FONT_NORMAL(13);
    _descriptionLabel.textColor = MAIN_COLOR;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_descriptionLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, screenWidth/2, 25)];
    _timeLabel.font = FONT_NORMAL(13);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_timeLabel];
}
@end
