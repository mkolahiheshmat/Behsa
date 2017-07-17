//
//  Case8Cell.m
//  MasonryExample
//
//  Created by Arash on 15/12/5.
//  Copyright © 2015 Arash Z. Jahangiri. All rights reserved.
//

#import "FifthViewDateCell.h"

@interface FifthViewDateCell ()
@property (strong, nonatomic) UILabel *patientNameLabel;
@property (strong, nonatomic) UILabel *priceLabel;
@property (strong, nonatomic) UILabel *descriptionLabel;

@property (weak, nonatomic) FifthViewDateEntity *entity;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation FifthViewDateCell
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

- (void)setEntity:(FifthViewDateEntity *)entity indexPath:(NSIndexPath *)indexPath {
    _entity = entity;
    _indexPath = indexPath;
    _patientNameLabel.text = [NSString stringWithFormat:@"نام مراجعه کننده: %@", [[entity.visitsArray objectAtIndex:indexPath.row]objectForKey:@"patient_name"]];
    _priceLabel.text = [NSString stringWithFormat:@"مبلغ: %@ تومان", [[entity.visitsArray objectAtIndex:indexPath.row]objectForKey:@"amount"]];
}

#pragma mark - Private method

- (void)initView {
    _patientNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, screenWidth - 20, 25)];
    _patientNameLabel.font = FONT_NORMAL(16);
    _patientNameLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_patientNameLabel];
    
    _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 40, screenWidth - 20, 25)];
    _priceLabel.font = FONT_NORMAL(16);
    _priceLabel.textColor = [UIColor grayColor];
    _priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceLabel];
    
    _descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, screenWidth - 20, 25)];
    _descriptionLabel.font = FONT_NORMAL(13);
    _descriptionLabel.textColor = MAIN_COLOR;
    _descriptionLabel.textAlignment = NSTextAlignmentCenter;
    //[self addSubview:_descriptionLabel];

}
@end
