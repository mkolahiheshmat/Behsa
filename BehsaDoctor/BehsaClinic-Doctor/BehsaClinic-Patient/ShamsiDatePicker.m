    //
    //  ShamsiDatePicker
    //
    //  Created by Arash on 7/11/14.
    //  Copyright (c) 2016 Arash Z.Jahangiri. All rights reserved.
    //

#import "ShamsiDatePicker.h"

@implementation ShamsiDatePicker{
    int count;
    NSDictionary *dictionary;
    NSMutableArray*pickers;
    UILabel*sharedLabel;
    
    int ftsize;
    NSString*ftName;
    UIColor *lblClr;
    int lnes;
    
    UIColor *bgClr;
    UIColor *tintClr;
    int high;
    
    NSMutableArray *daysArray;
    NSMutableArray *monthsArray;
    NSMutableArray *yearsArray;
    NSString *year;
    NSString *month;
    NSString *day;
}
@synthesize dataPickerView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
        NSArray* nibViews = [[NSBundle mainBundle] loadNibNamed:@"ShamsiDatePicker"
                                                          owner:self
                                                        options:nil];
        self = [ nibViews objectAtIndex: 0];
        
        
    }
    self.dataPickerView.dataSource=self;
    self.dataPickerView.delegate=self;
    return self;
}
- (NSDictionary *)makeDayMonthYearArray{
    daysArray = [[NSMutableArray alloc]init];
    for (int i = 1; i < 32 ; i++) {
        [daysArray addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    monthsArray = [[NSMutableArray alloc]initWithObjects:
                   NSLocalizedString(@"far", @""),
                   NSLocalizedString(@"ordi", @""),
                   NSLocalizedString(@"khordad", @""),
                   NSLocalizedString(@"tir", @""),
                   NSLocalizedString(@"mordad", @""),
                   NSLocalizedString(@"shahrivar", @""),
                   NSLocalizedString(@"mahr", @""),
                   NSLocalizedString(@"aban", @""),
                   NSLocalizedString(@"azar", @""),
                   NSLocalizedString(@"day", @""),
                   NSLocalizedString(@"bahman", @""),
                   NSLocalizedString(@"esfand", @"")
                   ,nil];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY.MM.dd HH:mm:ss"];
    NSString *stringFromDate = [formatter stringFromDate:now];
    NSInteger persianYear = [ConvertToPersianDate getPersianYear:stringFromDate];
    NSInteger persianMonth = [ConvertToPersianDate getPersianMonth:stringFromDate];
    NSInteger persianDay = [ConvertToPersianDate getPersianDay:stringFromDate];
    year = [NSString stringWithFormat:@"%ld", (long)persianYear];
    month = [NSString stringWithFormat:@"%ld", (long)persianMonth - 1];//I fixed that
    day = [NSString stringWithFormat:@"%ld", (long)persianDay];
    month = [DateUtil convertMonthNumberToMonthName:month];
    yearsArray = [[NSMutableArray alloc]init];
    for (NSInteger i = persianYear - 1; i <= persianYear ; i++) {
        [yearsArray addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    NSDictionary *customDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:yearsArray, @"Year", monthsArray, @"Month", daysArray, @"Day",nil];
    return customDictionary;
    
    
}

- (NSDictionary *)sortDictionary:(NSDictionary *)dict{
    NSArray * sortedKeys = [[dict allKeys] sortedArrayUsingSelector: @selector(caseInsensitiveCompare:)];
    
    NSArray * objects = [dict objectsForKeys: sortedKeys notFoundMarker: [NSNull null]];
    NSDictionary *dicy = [[NSDictionary alloc]initWithObjectsAndKeys:objects[0], sortedKeys[0], objects[1], sortedKeys[1],objects[2], sortedKeys[2], nil];
    return  dicy;
}
-(id)init
{
    self = [super init];
    dictionary= [NSDictionary dictionaryWithDictionary:[self makeDayMonthYearArray]];
    dictionary = [self sortDictionary:dictionary];
    pickers=[[NSMutableArray alloc]init];
    if (self) {
    }
    self.dataPickerView.delegate=self;
    NSLog(@"%@",self.dataPickerView.delegate);
    
    [self goToTodayDate];
    return self;
}
- (void)goToTodayDate{
        //year
    [dataPickerView selectRow:[yearsArray indexOfObject:year] inComponent:2 animated:YES];
    
        //month
    NSInteger indexOfMonth = [monthsArray indexOfObject:month];
    [dataPickerView selectRow:indexOfMonth inComponent:1 animated:YES];
    
        //day
    [dataPickerView selectRow:[daysArray indexOfObject:day] inComponent:0 animated:YES];
    
    _todayDic = [[NSDictionary alloc]initWithObjectsAndKeys:year, @"Year", month, @"Month", day, @"Day", nil];
}

    //init the style of Cell
-(void)setStylePickerWithLableFontSize:(int)fontsize andWithLableFontName:(NSString*)fontName andWithLableColor:(UIColor*)lblColor andWithLableNumberOfLines:(int)lines andWithPickerBackGroundColor:(UIColor*)bgColor andWithPickerTintColor:(UIColor*)tint  andWithViewHeight:(int)height{
    ftsize=fontsize;
    ftName=fontName;
    lblClr=lblColor;
    lnes=lines;
    bgClr=bgColor;
    tintClr=tint;
    high=height;
    
}
    //style for picker
-(UIPickerView*)setStyleForPicker:(UIPickerView*)pick{
    pick.backgroundColor=bgClr;
    pick.tintColor=tintClr;
    return pick;
    
}
    //style for lable in picker
-(UILabel*)setStyleForLable:(UILabel*)lbl{
    
    [lbl setFont:[UIFont fontWithName:ftName size:ftsize]];
    [lbl setTextColor:lblClr];
    [lbl setNumberOfLines:lnes];
    return lbl;
    
}
#pragma mark - Picker DELEGATE  -

    //custom view for pickerView
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLable = (UILabel*)view;
    if (!pickerLable){
        pickerLable = [[UILabel alloc] init];
            //tView.numberOfLines=3;
        pickerLable.adjustsFontSizeToFitWidth = YES;
        pickerLable.font = FONT_NORMAL(13);
            //tView.minimumFontSize = 0;
            // Setup label properties - frame, font, colors etc
        pickerLable.textAlignment = NSTextAlignmentCenter;
        pickerLable.backgroundColor=[UIColor clearColor];
            //pickerLable=  [self setStyleForLable:pickerLable];
        
    }
        // Fill the label text here
    NSString*key=[[dictionary allKeys] objectAtIndex:component];
    NSArray*arrOfFeild=[dictionary objectForKey:key];
    
    NSString*value=[arrOfFeild objectAtIndex:row];
    pickerLable.text=value;
    return pickerLable;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return [dictionary count];// or the number of vertical "columns" the picker will show...
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    NSString*key=[[dictionary allKeys] objectAtIndex:component];
    NSArray*arrOfFeild=[dictionary objectForKey:key];
    
    
    return [arrOfFeild count];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    NSMutableArray* objects=[[NSMutableArray alloc]init];
    for (int num=0; num< pickerView.numberOfComponents; num++) {
        NSString*key=[[dictionary allKeys] objectAtIndex:num];
        NSArray*arrOfFeild=[dictionary objectForKey:key];
        row = [pickerView selectedRowInComponent:num];
        [objects addObject:[arrOfFeild objectAtIndex:row]];
    }
    NSDictionary*dic=[NSDictionary dictionaryWithObjects:objects forKeys:[dictionary allKeys]];
    NSLog(@"%@",dic);
    [self.delegate selectedAZJPickerData:dic];
    
}
    //- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    //    return 200;
    //}

@end

