    //
    //  SecondViewController.m
    //  BehsaClinic-Patient
    //
    //  Created by Yarima on 2/11/17.
    //  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
    //

#import "SecondViewController.h"

typedef NS_OPTIONS(NSUInteger, FilterType) {
    FilterTypeAll				= 1 <<  0,
    FilterTypeUnderTreatment	= 1 <<  1,
    FilterTypeEndOfTreatment    = 1 <<  2
};

@interface SecondViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, AZJPickerData>
{
    UIView *indicatorView;
    UIButton *nameButton;
    UIButton *dateButton;
    UIView *nameSegmentView;
    UIView *dateSegmentView;
    UIButton *tabNamefilterButton;
    UITextField *tabNameNameTextField;
    ShamsiDatePicker *datePickerView;
    UIButton *fromDateButton;
    UIButton *tillDateButton;
    BOOL isFromDateButtonClicked;
    BOOL isTillDateButtonClicked;
    UIToolbar *dateToolbar;
    NSDictionary *fromDateDic;
    NSDictionary *tillDateDic;
    NSInteger pageForName;//page parameter for tab name paging
    NSInteger pageForDate;//page parameter for tab date paging
    UIButton *searchButtonDate;
    FilterType filterType;
    TreatmentStatusModel *treatmentStatusModel;
    NSMutableArray *treatmentStatusArray;
    NSInteger tryForConnection;
    UILabel *noResultLabelPost;
}
@property(nonatomic, retain)UITableView *tableViewName;
@property(nonatomic, retain)NSMutableArray *tableArrayName;
@property(nonatomic, retain)UITableView *tableViewDate;
@property(nonatomic, retain)NSMutableArray *tableArrayDate;
@end

@implementation SecondViewController
- (void)viewWillAppear:(BOOL)animated{
    [self getTreatmentStatus];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    pageForName = 1;
    pageForDate = 1;
        //superView = self.view;
    [self setTitleLabel:@"لیست مراجعان"];
    
    [self segmentView];
    [self nameSegmentViewMaker];
    [self dateSegmentViewMaker];
    [self datePickerMaker];
    
    [self showMenuButton];
    
    self.tableArrayName = [[NSMutableArray alloc]init];
    filterType = FilterTypeAll;
    [self searchName];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods
- (void)segmentView{
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(20, 63, screenWidth - 40, 1)];
    horizontalLine.backgroundColor = [UIColor clearColor];
    [SUPERVIEW addSubview:horizontalLine];
    
    indicatorView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2, horizontalLine.frame.origin.y + 1, screenWidth/2, 3)];
    indicatorView.backgroundColor = INDICATOR_MORAJEAN_COLOR;
    [SUPERVIEW addSubview:indicatorView];
    
    nameButton = [CustomButton initButtonWithTitle:@"براساس اسم" withTitleColor:[UIColor grayColor] withBackColor:[UIColor clearColor] withFrame:CGRectMake(screenWidth/2, horizontalLine.frame.origin.y + 10, screenWidth/2, 25)];
    [nameButton addTarget:self action:@selector(nameButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [SUPERVIEW addSubview:nameButton];
    
    dateButton = [CustomButton initButtonWithTitle:@"براساس تاریخ" withTitleColor:[UIColor grayColor] withBackColor:[UIColor clearColor] withFrame:CGRectMake(0, horizontalLine.frame.origin.y + 10, screenWidth/2, 25)];
    [dateButton addTarget:self action:@selector(dateButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [SUPERVIEW addSubview:dateButton];
    
    UIView *horizontalLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, dateButton.frame.origin.y + dateButton.frame.size.height, screenWidth, 1)];
    horizontalLine2.backgroundColor = [UIColor lightGrayColor];
    [SUPERVIEW addSubview:horizontalLine2];
}

- (void)nameButtonAction{
    [UIView animateWithDuration:0.01 animations:^{
        datePickerView.alpha = 0.0;
        [dateToolbar removeFromSuperview];
    }completion:^(BOOL finished) {
        datePickerView.hidden = YES;
    }];
    
    CGRect frame = indicatorView.frame;
    frame.origin.x = screenWidth/2;
    [UIView animateWithDuration:0.5 animations:^{
        [indicatorView setFrame:frame];
    }completion:^(BOOL finished) {
        nameSegmentView.hidden = NO;
        dateSegmentView.hidden = YES;
    }];
    
}

- (void)dateButtonAction{
    CGRect frame = indicatorView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [indicatorView setFrame:frame];
    }completion:^(BOOL finished) {
        nameSegmentView.hidden = YES;
        dateSegmentView.hidden = NO;
    }];
    
}

- (void)nameSegmentViewMaker{
    
    nameSegmentView = [[UIView alloc]initWithFrame:CGRectMake(0, nameButton.frame.origin.y + nameButton.frame.size.height + 15, screenWidth, screenHeight)];
    nameSegmentView.backgroundColor = [UIColor clearColor];
    nameSegmentView.userInteractionEnabled = YES;
    [SUPERVIEW addSubview:nameSegmentView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 140, 0, 120, 30)];
    label.numberOfLines = 0;
    label.font = FONT_NORMAL(16);
    label.text = @"نمایش به صورت:";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    [nameSegmentView addSubview:label];
    
    tabNamefilterButton = [CustomButton initButtonWithTitle:@"همه مراجعه کنندگان" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES
                                                  withFrame:CGRectMake(20, 0, 130, 30)];
    [tabNamefilterButton addTarget:self action:@selector(tabNamefilterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [nameSegmentView addSubview:tabNamefilterButton];
    
    UIView *searchBorderView = [[UIView alloc]initWithFrame:
                                CGRectMake(20, tabNamefilterButton.frame.origin.y + tabNamefilterButton.frame.size.height + 10, screenWidth - 40, 25)];
    searchBorderView.backgroundColor = [UIColor clearColor];
    searchBorderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchBorderView.layer.borderWidth = 1.0;
    searchBorderView.layer.cornerRadius = 10;
    searchBorderView.clipsToBounds = YES;
    [nameSegmentView addSubview:searchBorderView];
    
    tabNameNameTextField = [[UITextField alloc]initWithFrame:
                            CGRectMake(50, 1, searchBorderView.frame.size.width - 50, 23)];
    tabNameNameTextField.backgroundColor = [UIColor whiteColor];
    tabNameNameTextField.placeholder = @"                 جستجو مراجعه کننده";
    tabNameNameTextField.tag = 103;
    tabNameNameTextField.delegate = self;
    tabNameNameTextField.font = FONT_NORMAL(12);
    tabNameNameTextField.layer.borderColor = [UIColor clearColor].CGColor;
    tabNameNameTextField.layer.borderWidth = 1.0;
    tabNameNameTextField.layer.cornerRadius = 10;
    tabNameNameTextField.clipsToBounds = YES;
    tabNameNameTextField.minimumFontSize = 0.5;
    tabNameNameTextField.adjustsFontSizeToFitWidth = YES;
    tabNameNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    tabNameNameTextField.textAlignment = NSTextAlignmentCenter;
    tabNameNameTextField.userInteractionEnabled = YES;
    [searchBorderView addSubview:tabNameNameTextField];
    
        //44 × 52
    UIButton *searchButton = [CustomButton initButtonWithImage:[UIImage imageNamed:@"icon search"] withFrame:CGRectMake(10, 5, 44 * 0.3, 52 * 0.3)];
    [searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [searchBorderView addSubview:searchButton];
    
    self.tableArrayName = [[NSMutableArray alloc]init];
    CGFloat yPos = searchBorderView.frame.origin.y + searchBorderView.frame.size.height + 10;
    self.tableViewName = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screenWidth, screenHeight - yPos - 160)];
    self.tableViewName.delegate = self;
    self.tableViewName.dataSource = self;
    [nameSegmentView addSubview:self.tableViewName];
}

- (void)dateSegmentViewMaker{
    dateSegmentView = [[UIView alloc]initWithFrame:CGRectMake(0, nameButton.frame.origin.y + nameButton.frame.size.height + 15, screenWidth, screenHeight)];
    dateSegmentView.backgroundColor = [UIColor clearColor];
    [SUPERVIEW addSubview:dateSegmentView];
    dateSegmentView.hidden = YES;
    
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
    
    
    self.tableArrayDate = [[NSMutableArray alloc]init];
    yPos = searchButtonDate.frame.origin.y + searchButtonDate.frame.size.height + 10;
    self.tableViewDate = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screenWidth, screenHeight - yPos - 160)];
    self.tableViewDate.delegate = self;
    self.tableViewDate.dataSource = self;
    [dateSegmentView addSubview:self.tableViewDate];
}

- (void)tabNamefilterButtonAction{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"لغو" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            // Cancel button tappped do nothing.
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"همه مراجعه کنندگان" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tabNamefilterButton setTitle:@"همه مراجعه کنندگان" forState:UIControlStateNormal];
        self.tableArrayName = [[NSMutableArray alloc]init];
        pageForName = 1;
        filterType = FilterTypeAll;
        [self searchName];
        
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"تحت درمان" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tabNamefilterButton setTitle:@"تحت درمان" forState:UIControlStateNormal];
        self.tableArrayName = [[NSMutableArray alloc]init];
        pageForName = 1;
        filterType = FilterTypeUnderTreatment;
        [self searchName];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"پایان درمان" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tabNamefilterButton setTitle:@"پایان درمان" forState:UIControlStateNormal];
        self.tableArrayName = [[NSMutableArray alloc]init];
        pageForName = 1;
        filterType = FilterTypeEndOfTreatment;
        [self searchName];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)tabdatefilterButtonAction{
    
}

- (void)datePickerMaker{
    datePickerView = [[ShamsiDatePicker alloc]init];
    datePickerView.frame = CGRectMake(0, screenHeight - 195, screenWidth, 195);
        //datePickerView.backgroundColor = [UIColor cyanColor];
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
    self.tableArrayDate = [[NSMutableArray alloc]init];
    pageForDate = 1;
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

- (void)dismissTextField{
    [tabNameNameTextField resignFirstResponder];
}

- (void)searchButtonAction{
    pageForName = 1;
    self.tableArrayName = [[NSMutableArray alloc]init];
    [self searchName];
}

- (void)pushToPatientView:(NSInteger)patientID{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PatientViewController *view = (PatientViewController *)[story instantiateViewControllerWithIdentifier:@"PatientViewController"];
    view.patientID = patientID;
    [self.navigationController pushViewController:view animated:YES];
}

- (NSString *)convertToShamsi:(double)timeStamp{
    double timestampval = timeStamp;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [ConvertToPersianDate ConvertToPersianFromGregorianDate2:startDate];
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
    
    self.tableArrayDate = [[NSMutableArray alloc]init];
    pageForDate = 1;
}
#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (nameSegmentView.hidden == YES) {
        return [_tableArrayDate count];
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (nameSegmentView.hidden == YES) {
        return 30;
    }
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView;
    if (nameSegmentView.hidden == YES) {
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
        headerView.backgroundColor = [UIColor lightGrayColor];
        SeconViewDateEntity *entity = [_tableArrayDate  myObjectAtIndex:section];
        
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(5, 8, tableView.frame.size.width - 10, 18);
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.font = FONT_NORMAL(13);
        headerLabel.textColor = [UIColor blackColor];
        headerLabel.text = [self convertToShamsi:entity.dateTimeStamp];
        headerLabel.textAlignment = NSTextAlignmentCenter;
        headerLabel.userInteractionEnabled = YES;
        [headerView addSubview:headerLabel];
    } else {
        headerView = nil;
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (nameSegmentView.hidden == NO) {
        return [self.tableArrayName count];
    } else {
        SeconViewDateEntity *entity = [SeconViewDateEntity new];
        entity = [self.tableArrayDate  myObjectAtIndex:section];
            //NSLog(@"%@", [entity.visitsArray  myObjectAtIndex:section]);
        return [entity.visitsArray count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (nameSegmentView.hidden == NO) {
        return 70;
    } else {
        return 80;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    if (nameSegmentView.hidden == NO) {
        SecondViewNameCell *cell = [[SecondViewNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([_tableArrayName count] == 0) {
            return cell;
        }
        [cell setEntity:[_tableArrayName  myObjectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    } else {
        SecondViewDateCell *cell = [[SecondViewDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setEntity:[_tableArrayDate  myObjectAtIndex:indexPath.section] indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (nameSegmentView.hidden == NO) {
            //name segement view
        SeconViewNameEntity *entity = [self.tableArrayName  myObjectAtIndex:indexPath.row];
        [self pushToPatientView:entity.patientID];
    } else {
            //date segment view
        SeconViewDateEntity *entity = [self.tableArrayDate  myObjectAtIndex:indexPath.section];
        [self pushToPatientView:[[[[entity.visitsArray  myObjectAtIndex:indexPath.row] myObjectForKey:@"patient"] myObjectForKey:@"id"]integerValue]];
    }
}

#pragma mark - text field delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
        //self.tableArrayName = [[NSMutableArray alloc]init];
        //pageForName = 1;
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

-(void)textFieldDidChange :(UITextField *)textField{
}

#pragma mark - connection

- (void)searchName{
    if (pageForName == 1) {
        self.tableArrayName = [[NSMutableArray alloc]init];
    }
    [self dismissTextField];
        [ProgressHUD show:@""];
    NSInteger treatmentStatusId = 0;
    switch (filterType) {
        case FilterTypeAll:
            break;
        case FilterTypeUnderTreatment:
            for (TreatmentStatusModel *model in treatmentStatusArray) {
                if ([model.aliasString isEqualToString:@"open"]) {
                    treatmentStatusId = model._id;
                    break;
                }
            }
            break;
        case FilterTypeEndOfTreatment:
            for (TreatmentStatusModel *model in treatmentStatusArray) {
                if ([model.aliasString isEqualToString:@"finished"]) {
                    treatmentStatusId = model._id;
                    break;
                }
            }
            break;
            
        default:
            break;
    }
    
    tabNameNameTextField.text = [tabNameNameTextField.text stringByReplacingOccurrencesOfString:@"ك" withString:@"ک"];
    tabNameNameTextField.text = [tabNameNameTextField.text stringByReplacingOccurrencesOfString:@"ي" withString:@"ی"];
    NSDictionary *params = @{@"name":tabNameNameTextField.text,
                             @"treatment_status_id":[NSNumber numberWithInteger:treatmentStatusId],
                             @"page":[NSNumber numberWithInteger:pageForName]
                             };
    [Networking formDataWithPath:@"treatment/patients" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            for (NSDictionary *dic in [[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]) {
                SeconViewNameEntity *entity = [SeconViewNameEntity new];
                entity.nameString = [dic  myObjectForKey:@"name"];
                entity.patientID = [[dic  myObjectForKey:@"id"]integerValue];
                [self.tableArrayName addObject:entity];
            }
            [self.tableViewName reloadData];
        }
        
        [noResultLabelPost removeFromSuperview];
        if ([self.tableArrayName count] == 0) {
            [noResultLabelPost removeFromSuperview];
            noResultLabelPost = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 220, 10, 200,  25)];
            noResultLabelPost.font = FONT_NORMAL(13);
            noResultLabelPost.text = @"نتیجه ای پیدا نشد";
            noResultLabelPost.minimumScaleFactor = 0.7;
            noResultLabelPost.textColor = [UIColor blackColor];
            noResultLabelPost.textAlignment = NSTextAlignmentRight;
            noResultLabelPost.adjustsFontSizeToFitWidth = YES;
            [self.tableViewName addSubview:noResultLabelPost];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}

- (void)searchDate{
    if (pageForDate == 1) {
        self.tableArrayDate = [[NSMutableArray alloc]init];
    }
    [self dismissTextField];
        [ProgressHUD show:@""];
    double fromDateDouble = [ConvertToPersianDate ConvertToUNIXDateWithShamsiYear:[[fromDateDic  myObjectForKey:@"Year"]integerValue]
                                                                            month:[[fromDateDic  myObjectForKey:@"Month"]integerValue] + 1
                                                                              day:[[fromDateDic  myObjectForKey:@"Day"]integerValue]];
    double tillDateDouble = [ConvertToPersianDate ConvertToUNIXDateWithShamsiYear:[[tillDateDic  myObjectForKey:@"Year"]integerValue]
                                                                            month:[[tillDateDic  myObjectForKey:@"Month"]integerValue] + 1
                                                                              day:[[tillDateDic  myObjectForKey:@"Day"]integerValue]];
    NSDictionary *params = @{@"date_from":[NSNumber numberWithDouble:fromDateDouble],
                             @"date_to":[NSNumber numberWithDouble:tillDateDouble],
                             @"page":[NSNumber numberWithInteger:pageForDate]
                             };
    [Networking formDataWithPath:@"online_booking/doctor/visits" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            for (NSDictionary *dic in [[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]) {
                SeconViewDateEntity *entity = [SeconViewDateEntity new];
                entity.visitsArray = [dic  myObjectForKey:@"visits"];
                entity.dateTimeStamp = [[dic  myObjectForKey:@"date"]doubleValue];
                [self.tableArrayDate addObject:entity];
            }
            [self.tableViewDate reloadData];
        }
        
        [noResultLabelPost removeFromSuperview];
        if ([self.tableArrayDate count] == 0) {
            [noResultLabelPost removeFromSuperview];
            noResultLabelPost = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 220, 10, 200,  25)];
            noResultLabelPost.font = FONT_NORMAL(13);
            noResultLabelPost.text = @"نتیجه ای پیدا نشد";
            noResultLabelPost.minimumScaleFactor = 0.7;
            noResultLabelPost.textColor = [UIColor blackColor];
            noResultLabelPost.textAlignment = NSTextAlignmentRight;
            noResultLabelPost.adjustsFontSizeToFitWidth = YES;
            [self.tableViewDate addSubview:noResultLabelPost];
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
        
    }];
}

- (void)getTreatmentStatus{
    treatmentStatusArray = [[NSMutableArray alloc]init];
    [Networking formDataWithPath:@"online_booking/treatment_statuses" parameters:@{@"id":@"0"} success:^(NSDictionary * _Nonnull responseDict) {
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            for (NSDictionary *dic in [[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]) {
                TreatmentStatusModel *entity = [TreatmentStatusModel new];
                entity._id = [[dic  myObjectForKey:@"id"]integerValue];
                entity.nameString = [dic  myObjectForKey:@"name"];
                entity.aliasString = [dic  myObjectForKey:@"alias"];
                [treatmentStatusArray addObject:entity];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        tryForConnection++;
        if (tryForConnection < 10) {
            [self getTreatmentStatus];
        }
    }];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
            // we are at the end
        if (nameSegmentView.hidden == NO) {
            pageForName++;
            [self searchName];
        } else {
            pageForDate++;
            [self searchDate];
        }
    }
}

@end
