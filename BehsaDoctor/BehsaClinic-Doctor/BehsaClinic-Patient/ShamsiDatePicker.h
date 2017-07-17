//
//  ShamsiDatePicker
//
//  Created by Arash on 7/11/14.
//  Copyright (c) 2016 Arash Z.Jahangiri. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol AZJPickerData <NSObject>
- (void)selectedAZJPickerData:(NSDictionary *)dic;
@end
@interface ShamsiDatePicker : UIView<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *dataPickerView;
@property (nonatomic, retain)NSDictionary *todayDic;
//define the delegate property
@property (nonatomic, unsafe_unretained) id<AZJPickerData> delegate;

- (id)init;
- (void)goToTodayDate;
-(void)setStylePickerWithLableFontSize:(int)fontsize andWithLableFontName:(NSString*)fontName andWithLableColor:(UIColor*)lblColor andWithLableNumberOfLines:(int)lines andWithPickerBackGroundColor:(UIColor*)bgColor andWithPickerTintColor:(UIColor*)tint andWithViewHeight:(int)height;

@end
