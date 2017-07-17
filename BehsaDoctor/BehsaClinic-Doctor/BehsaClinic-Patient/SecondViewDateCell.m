//
//  Case8Cell.m
//  MasonryExample
//
//  Created by Arash on 15/12/5.
//  Copyright © 2015 Arash Z. Jahangiri. All rights reserved.
//

#import "SecondViewDateCell.h"

@interface SecondViewDateCell ()
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UILabel *timeLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (weak, nonatomic) SeconViewDateEntity *entity;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation SecondViewDateCell
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

- (void)setEntity:(SeconViewDateEntity *)entity indexPath:(NSIndexPath *)indexPath {
    _entity = entity;
    _indexPath = indexPath;
    _nameLabel.text = [[[entity.visitsArray objectAtIndex:indexPath.row]objectForKey:@"patient"]objectForKey:@"name"];
    NSString *hour1 = [[entity.visitsArray objectAtIndex:indexPath.row]objectForKey:@"time_start"];
    NSString *hour2 = [[entity.visitsArray objectAtIndex:indexPath.row]objectForKey:@"time_end"];
    _timeLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@", NSLocalizedString(@"hour1", @""), hour1, NSLocalizedString(@"hour2", @""), hour2];
    NSString *status = [[[entity.visitsArray objectAtIndex:indexPath.row]objectForKey:@"status"]objectForKey:@"alias"];
    if ([status isEqualToString:@"canceled"]) {
        _descriptionLabel.textColor = [UIColor redColor];
    }
    _descriptionLabel.text = [[[entity.visitsArray objectAtIndex:indexPath.row]objectForKey:@"status"]objectForKey:@"name"];
}

#pragma mark - Private method

- (void)initView {
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, screenWidth - 20, 25)];
    _nameLabel.font = FONT_NORMAL(16);
    _nameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_nameLabel];
    
    _timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, screenWidth - 90, 25)];
    _timeLabel.font = FONT_NORMAL(16);
    _timeLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_timeLabel];
    
    _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, screenWidth - 20, 25)];
    _descriptionLabel.font = FONT_NORMAL(13);
    _descriptionLabel.textColor = MAIN_COLOR;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_descriptionLabel];

}
@end
