    //
    //  FifthViewController.m
    //  BehsaClinic-Patient
    //
    //  Created by Yarima on 2/11/17.
    //  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
    //

#import "FifthViewController.h"

@interface FifthViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AZJPickerData>
{
    UIView *dateSegmentView;
    UIScrollView *scrollView;
    ShamsiDatePicker *datePickerView;
    UIButton *fromDateButton;
    UIButton *tillDateButton;
    BOOL isFromDateButtonClicked;
    BOOL isTillDateButtonClicked;
    UIToolbar *dateToolbar;
    NSDictionary *fromDateDic;
    NSDictionary *tillDateDic;
    UIButton *searchButtonDate;
    UILabel *noResultLabelPost;
    NSInteger page;
    UILabel *totalPricelabel;
}
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *tableArray;
@end

@implementation FifthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitleLabel:@"گردش حساب"];
    page = 1;
    //[self scrollviewMaker];
    [self showMenuButton];
    [self dateSegmentViewMaker];
    [self datePickerMaker];
    [self searchDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - custom methos
- (void)scrollviewMaker{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, screenHeight - 70)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);
}

- (void)dateSegmentViewMaker{
    dateSegmentView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, screenHeight)];
    dateSegmentView.backgroundColor = [UIColor clearColor];
    [SUPERVIEW addSubview:dateSegmentView];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 140, 0, 120, 20)];
    label1.numberOfLines = 0;
    label1.font = FONT_NORMAL(16);
    label1.text = @"از تاریخ:";
    label1.textColor = [UIColor blackColor];
    label1.textAlignment = NSTextAlignmentRight;
    [dateSegmentView addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 140, 30, 120, 20)];
    label2.numberOfLines = 0;
    label2.font = FONT_NORMAL(16);
    label2.text = @"تا تاریخ:";
    label2.textColor = [UIColor blackColor];
    label2.textAlignment = NSTextAlignmentRight;
    [dateSegmentView addSubview:label2];
    
    fromDateButton = [CustomButton initButtonWithTitle:@"انتخاب تاریخ" withTitleColor:[UIColor lightGrayColor] withBackColor:[UIColor clearColor] isRounded:YES withFrame:CGRectMake(40, 0, screenWidth - 200, 23)];
    fromDateButton.titleLabel.font = FONT_NORMAL(11);
    [fromDateButton addTarget:self action:@selector(fromDateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [dateSegmentView addSubview:fromDateButton];
    
    tillDateButton = [CustomButton initButtonWithTitle:@"انتخاب تاریخ" withTitleColor:[UIColor lightGrayColor] withBackColor:[UIColor clearColor] isRounded:YES withFrame:CGRectMake(40, 30, screenWidth - 200, 23)];
    tillDateButton.titleLabel.font = FONT_NORMAL(11);
    [tillDateButton addTarget:self action:@selector(tillDateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [dateSegmentView addSubview:tillDateButton];
    
    CGFloat yPos = label2.frame.origin.y + label2.frame.size.height + 10;
    searchButtonDate = [CustomButton initButtonWithTitle:@"جستجو" withTitleColor:[UIColor whiteColor] withBackColor:[UIColor grayColor] isRounded:YES
                                               withFrame:CGRectMake(60, yPos, screenWidth - 120, 30)];
    [searchButtonDate addTarget:self action:@selector(searchDate) forControlEvents:UIControlEventTouchUpInside];
    [dateSegmentView addSubview:searchButtonDate];
    searchButtonDate.userInteractionEnabled = NO;
    
    
    self.tableArray = [[NSMutableArray alloc]init];
    yPos = searchButtonDate.frame.origin.y + searchButtonDate.frame.size.height + 10;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screenWidth, screenHeight - yPos - 160)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [dateSegmentView addSubview:self.tableView];
    
    totalPricelabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.tableView.frame.origin.y + self.tableView.frame.size.height, screenWidth, 40)];
    totalPricelabel.numberOfLines = 0;
    totalPricelabel.font = FONT_NORMAL(16);
    totalPricelabel.textColor = [UIColor whiteColor];
    totalPricelabel.backgroundColor = MAIN_COLOR;
    totalPricelabel.textAlignment = NSTextAlignmentCenter;
    [dateSegmentView addSubview:totalPricelabel];
}

- (void)datePickerMaker{
    datePickerView = [[ShamsiDatePicker alloc]init];
    datePickerView.backgroundColor = [UIColor whiteColor];
    datePickerView.frame = CGRectMake(0, screenHeight - 195, screenWidth, 195);
    datePickerView.delegate = self;
    [self.view addSubview:datePickerView];
    datePickerView.hidden = YES;
}

- (void)fromDateButtonAction{
    isFromDateButtonClicked = YES;
    isTillDateButtonClicked = NO;
    
        //set title for this button
    if ([fromDateButton.titleLabel.text isEqualToString:@"انتخاب تاریخ"]) {
        NSString *day = [datePickerView.todayDic  myObjectForKey:@"Day"];
        NSString *month = [datePickerView.todayDic  myObjectForKey:@"Month"];
        NSString *year = [datePickerView.todayDic  myObjectForKey:@"Year"];
        [fromDateButton setTitle:[NSString stringWithFormat:@"%@ %@ %@", day, month, year] forState:UIControlStateNormal];
        fromDateDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                       day, @"Day",
                       [NSNumber numberWithInteger:[DateUtil convertMonthNameToNumber:month]], @"Month",
                       year, @"Year", nil];
    }
    
    [self showDatePickerView];
}

- (void)tillDateButtonAction{
    isFromDateButtonClicked = NO;
    isTillDateButtonClicked = YES;
    
        //set title for this button
    if ([tillDateButton.titleLabel.text isEqualToString:@"انتخاب تاریخ"]) {
        NSString *day = [datePickerView.todayDic  myObjectForKey:@"Day"];
        NSString *month = [datePickerView.todayDic  myObjectForKey:@"Month"];
        NSString *year = [datePickerView.todayDic  myObjectForKey:@"Year"];
        [tillDateButton setTitle:[NSString stringWithFormat:@"%@ %@ %@", day, month, year] forState:UIControlStateNormal];
        tillDateDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                       day, @"Day",
                       [NSNumber numberWithInteger:[DateUtil convertMonthNameToNumber:month]], @"Month",
                       year, @"Year", nil];
    }
    [self showDatePickerView];
}

- (void)makeToolBarOnView:(UIView *)aView{
    [dateToolbar removeFromSuperview];
    dateToolbar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,screenHeight - 220,screenWidth,44)];
    [dateToolbar setBarStyle:UIBarStyleBlackOpaque];
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:@"انجام شد"
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(doneToolbarItem)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *barButtonToday = [[UIBarButtonItem alloc] initWithTitle:@"امروز"
                                                                       style:UIBarButtonItemStyleDone target:self action:@selector(showTodayDate)];
    dateToolbar.items = @[barButtonDone, flex, barButtonToday];
    barButtonDone.tintColor=[UIColor whiteColor];
    barButtonToday.tintColor=[UIColor whiteColor];
    [self.view addSubview:dateToolbar];
}

- (void)showTodayDate{
    self.tableArray = [[NSMutableArray alloc]init];
    page = 1;
    [datePickerView goToTodayDate];
    if (isFromDateButtonClicked) {
        NSString *day = [datePickerView.todayDic  myObjectForKey:@"Day"];
        NSString *month = [datePickerView.todayDic  myObjectForKey:@"Month"];
        NSString *year = [datePickerView.todayDic  myObjectForKey:@"Year"];
        [fromDateButton setTitle:[NSString stringWithFormat:@"%@ %@ %@", day, month, year] forState:UIControlStateNormal];
        fromDateDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                       day, @"Day",
                       [NSNumber numberWithInteger:[DateUtil convertMonthNameToNumber:month]], @"Month",
                       year, @"Year", nil];
        
    } else {
        NSString *day = [datePickerView.todayDic  myObjectForKey:@"Day"];
        NSString *month = [datePickerView.todayDic  myObjectForKey:@"Month"];
        NSString *year = [datePickerView.todayDic  myObjectForKey:@"Year"];
        [tillDateButton setTitle:[NSString stringWithFormat:@"%@ %@ %@", day, month, year] forState:UIControlStateNormal];
        tillDateDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                       day, @"Day",
                       [NSNumber numberWithInteger:[DateUtil convertMonthNameToNumber:month]], @"Month",
                       year, @"Year", nil];
    }
}

- (void)showDatePickerView{
    datePickerView.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        datePickerView.alpha = 100.0;
        [self makeToolBarOnView:datePickerView];
    }];
}

- (void)doneToolbarItem{
    if (!isFromDateButtonClicked) {
        if ([DateUtil isSecondDateGreaterThanEqualFirstDate:fromDateDic secondDate:tillDateDic]) {
            searchButtonDate.backgroundColor = MAIN_COLOR;
            searchButtonDate.userInteractionEnabled = YES;
            [dateToolbar removeFromSuperview];
            [UIView animateWithDuration:0.01 animations:^{
                datePickerView.alpha = 0.0;
            }completion:^(BOOL finished) {
                datePickerView.hidden = YES;
            }];
        } else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"انتخاب تاریخ" message:@"تاریخ دوم باید بعداز بازه زمانی تاریخ اول باشد" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                searchButtonDate.backgroundColor = [UIColor grayColor];
                searchButtonDate.userInteractionEnabled = NO;
            }];
            [alert addAction:action];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
    } else {
        datePickerView.alpha = 0.0;
        [dateToolbar removeFromSuperview];
    }
}

- (NSString *)convertToShamsi:(double)timeStamp{
    double timestampval = timeStamp;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [ConvertToPersianDate ConvertToPersianFromGregorianDate2:startDate];
}
#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_tableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    FifthViewDateEntity *entity = [_tableArray  myObjectAtIndex:section];
    
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(5, 8, tableView.frame.size.width - 10, 18);
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = FONT_NORMAL(13);
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.text = [self convertToShamsi:entity.dateTimeStamp];
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.userInteractionEnabled = YES;
    [headerView addSubview:headerLabel];
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    FifthViewDateEntity *entity = [FifthViewDateEntity new];
    entity = [self.tableArray myObjectAtIndex:section];
    return [entity.visitsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    FifthViewDateCell *cell = [[FifthViewDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setEntity:[_tableArray myObjectAtIndex:indexPath.section] indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - my pickerview delegate
- (void)selectedAZJPickerData:(NSDictionary *)dic{
    NSString *day = [dic  myObjectForKey:@"Day"];
    NSString *month = [dic  myObjectForKey:@"Month"];
    NSString *year = [dic  myObjectForKey:@"Year"];
    if (isFromDateButtonClicked) {
        fromDateDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                       day,@"Day",
                       [NSNumber numberWithInteger:[DateUtil convertMonthNameToNumber:month]],@"Month",
                       year, @"Year", nil];
        [fromDateButton setTitle:[NSString stringWithFormat:@"%@ %@ %@", day, month, year] forState:UIControlStateNormal];
    } else {
        tillDateDic = [[NSDictionary alloc]initWithObjectsAndKeys:
                       day, @"Day",
                       [NSNumber numberWithInteger:[DateUtil convertMonthNameToNumber:month]], @"Month",
                       year, @"Year", nil];
        [tillDateButton setTitle:[NSString stringWithFormat:@"%@ %@ %@", day, month, year] forState:UIControlStateNormal];
    }
    NSLog(@"%@", dic);
    
    self.tableArray = [[NSMutableArray alloc]init];
    page = 1;
}

#pragma mark - connection
- (void)searchDate{
    if (page == 1) {
        self.tableArray = [[NSMutableArray alloc]init];
    }
    [self dismissTextField];
    [ProgressHUD show:@""];
    double fromDateDouble = [ConvertToPersianDate ConvertToUNIXDateWithShamsiYear:[[fromDateDic  myObjectForKey:@"Year"]integerValue]
                                                                            month:[[fromDateDic  myObjectForKey:@"Month"]integerValue] + 1
                                                                              day:[[fromDateDic  myObjectForKey:@"Day"]integerValue]];
    if (fromDateDouble < 0) {
        fromDateDouble = 0.0;
    }
    double tillDateDouble = [ConvertToPersianDate ConvertToUNIXDateWithShamsiYear:[[tillDateDic  myObjectForKey:@"Year"]integerValue]
                                                                            month:[[tillDateDic  myObjectForKey:@"Month"]integerValue] + 1
                                                                              day:[[tillDateDic  myObjectForKey:@"Day"]integerValue]];
    if (tillDateDouble < 0) {
        tillDateDouble = 0.0;
    }
    NSDictionary *params = @{@"start_date":[NSNumber numberWithDouble:fromDateDouble],
                             @"end_date":[NSNumber numberWithDouble:tillDateDouble],
                             @"page":[NSNumber numberWithInteger:page]
                             };
    if (tillDateDouble == 0 && fromDateDouble == 0) {
        params = @{@"page":[NSNumber numberWithInteger:page]};
    }
    [Networking formDataWithPath:@"payment/doctor_turnover" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            NSString *creditStr = [NSString stringWithFormat:@"%@", [[responseDict objectForKey:@"data"]objectForKey:@"total"]];
            creditStr = [creditStr separator];
            totalPricelabel.text = [NSString stringWithFormat:@"مبلغ کل: %@تومان", creditStr];
            
            for (NSDictionary *dic in [[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]) {
                FifthViewDateEntity *entity = [FifthViewDateEntity new];
                entity.dateTimeStamp = [[dic  myObjectForKey:@"date"]doubleValue];
                entity.visitsArray = [dic myObjectForKey:@"transactions"];
                [self.tableArray addObject:entity];
            }
            [self.tableView reloadData];
        }
        
        [noResultLabelPost removeFromSuperview];
        if ([self.tableArray count] == 0) {
            [noResultLabelPost removeFromSuperview];
            noResultLabelPost = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 220, 10, 200,  25)];
            noResultLabelPost.font = FONT_NORMAL(13);
            noResultLabelPost.text = @"نتیجه ای پیدا نشد";
            noResultLabelPost.minimumScaleFactor = 0.7;
            noResultLabelPost.textColor = [UIColor blackColor];
            noResultLabelPost.textAlignment = NSTextAlignmentRight;
            noResultLabelPost.adjustsFontSizeToFitWidth = YES;
            [self.tableView addSubview:noResultLabelPost];
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
        
    }];
}

@end
