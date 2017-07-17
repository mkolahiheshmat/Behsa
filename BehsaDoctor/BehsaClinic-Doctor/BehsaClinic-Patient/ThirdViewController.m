//
//  ThirdViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/11/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "ThirdViewController.h"

typedef NS_OPTIONS(NSUInteger, FilterType) {
    FilterTypeFutur				= 1 <<  0,
    FilterTypePast              = 1 <<  1,
    FilterTypeCanceled		= 1 <<  2
};

@interface ThirdViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIView *indicatorView;
    UIButton *nowButton;
    UIButton *calendarButton;
    UIView *nowSegmentView;
    UIView *calendarSegmentView;
    UIButton *tabCalendarfilterButton;
    NSInteger pageForNow;//page parameter for tab now paging
    NSInteger pageForCalendar;//page parameter for tab calendar paging
    UIButton *searchButtonDate;
    FilterType  filterType;
    UILabel *noresultLabel;
}
@property(nonatomic, retain)UITableView *tableViewNow;
@property(nonatomic, retain)NSMutableArray *tableArrayNow;
@property(nonatomic, retain)UITableView *tableViewCalendar;
@property(nonatomic, retain)NSMutableArray *tableArrayCalendar;
@end

@implementation ThirdViewController

- (void)viewWillAppear:(BOOL)animated{
    if (nowSegmentView && calendarSegmentView){
        pageForNow = 1;
        self.tableArrayNow = [[NSMutableArray alloc]init];
        pageForCalendar = 1;
        self.tableArrayCalendar = [[NSMutableArray alloc]init];
        filterType = FilterTypeFutur;
        [self searchNow];
        [self searchCalendar];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    pageForNow = 1;
    pageForCalendar = 1;
    //superView = self.view;
    [self setTitleLabel:@"نوبت ها"];
    
    [self segmentView];
    [self nowSegmentViewMaker];
    [self calendarSegmentViewMaker];
    
    [self showMenuButton];
    
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
    
    nowButton = [CustomButton initButtonWithTitle:@"نوبت در حال برگزاری" withTitleColor:[UIColor grayColor] withBackColor:[UIColor clearColor] withFrame:CGRectMake(screenWidth/2, horizontalLine.frame.origin.y + 10, screenWidth/2, 25)];
    [nowButton addTarget:self action:@selector(nowButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [SUPERVIEW addSubview:nowButton];
    
    calendarButton = [CustomButton initButtonWithTitle:@"تقویم" withTitleColor:[UIColor grayColor] withBackColor:[UIColor clearColor] withFrame:CGRectMake(0, horizontalLine.frame.origin.y + 10, screenWidth/2, 25)];
    [calendarButton addTarget:self action:@selector(calendarButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [SUPERVIEW addSubview:calendarButton];
    
    UIView *horizontalLine2 = [[UIView alloc]initWithFrame:CGRectMake(0, calendarButton.frame.origin.y + calendarButton.frame.size.height, screenWidth, 1)];
    horizontalLine2.backgroundColor = [UIColor lightGrayColor];
    [SUPERVIEW addSubview:horizontalLine2];
}

- (void)nowButtonAction{
    CGRect frame = indicatorView.frame;
    frame.origin.x = screenWidth/2;
    [UIView animateWithDuration:0.5 animations:^{
        [indicatorView setFrame:frame];
    }completion:^(BOOL finished) {
        nowSegmentView.hidden = NO;
        calendarSegmentView.hidden = YES;
        [self.tableViewNow reloadData];
    }];
    
}

- (void)calendarButtonAction{
    CGRect frame = indicatorView.frame;
    frame.origin.x = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [indicatorView setFrame:frame];
    }completion:^(BOOL finished) {
        nowSegmentView.hidden = YES;
        calendarSegmentView.hidden = NO;
        [self.tableViewCalendar reloadData];
    }];
    
}

- (void)nowSegmentViewMaker{
    nowSegmentView = [[UIView alloc]initWithFrame:CGRectMake(0, nowButton.frame.origin.y + nowButton.frame.size.height + 15, screenWidth, screenHeight)];
    nowSegmentView.backgroundColor = [UIColor clearColor];
    nowSegmentView.userInteractionEnabled = YES;
    [SUPERVIEW addSubview:nowSegmentView];
    
    self.tableArrayNow = [[NSMutableArray alloc]init];
    CGFloat yPos = 10;
    self.tableViewNow = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screenWidth, screenHeight)];
    self.tableViewNow.delegate = self;
    self.tableViewNow.dataSource = self;
    [nowSegmentView addSubview:self.tableViewNow];
    
    //[self searchNow];
}

- (void)calendarSegmentViewMaker{
    CGFloat yPoss = nowButton.frame.origin.y + nowButton.frame.size.height + 15;
    calendarSegmentView = [[UIView alloc]initWithFrame:CGRectMake(0, yPoss, screenWidth, screenHeight - yPoss)];
    calendarSegmentView.backgroundColor = [UIColor clearColor];
    [SUPERVIEW addSubview:calendarSegmentView];
    calendarSegmentView.hidden = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 140, 0, 120, 20)];
    label.numberOfLines = 0;
    label.font = FONT_NORMAL(16);
    label.text = @"نمایش به صورت:";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    [calendarSegmentView addSubview:label];
    
    tabCalendarfilterButton = [CustomButton initButtonWithTitle:@"وقت های پیش رو" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES
                                                      withFrame:CGRectMake(20, 0, 130, 30)];
    [tabCalendarfilterButton addTarget:self action:@selector(tabCalendarfilterButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [calendarSegmentView addSubview:tabCalendarfilterButton];
    
    self.tableArrayCalendar = [[NSMutableArray alloc]init];
    CGFloat yPos = tabCalendarfilterButton.frame.origin.y + tabCalendarfilterButton.frame.size.height + 10;
    self.tableViewCalendar = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screenWidth, calendarSegmentView.frame.size.height - yPos - 50)];
    self.tableViewCalendar.delegate = self;
    self.tableViewCalendar.dataSource = self;
    [calendarSegmentView addSubview:self.tableViewCalendar];
    
    filterType = FilterTypeFutur;
    //[self searchCalendar];
    
}

- (void)tabCalendarfilterButtonAction{
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"لغو" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped do nothing.
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"وقت های پیش رو" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tabCalendarfilterButton setTitle:@"وقت های پیش رو" forState:UIControlStateNormal];
        self.tableArrayCalendar = [[NSMutableArray alloc]init];
        pageForCalendar = 1;
        filterType = FilterTypeFutur;
        [self searchCalendar];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"وقت های لغو شده" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tabCalendarfilterButton setTitle:@"وقت های لغو شده" forState:UIControlStateNormal];
        self.tableArrayCalendar = [[NSMutableArray alloc]init];
        pageForCalendar = 1;
        filterType = FilterTypeCanceled;
        [self searchCalendar];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"وقت های گذشته" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [tabCalendarfilterButton setTitle:@"وقت های گذشته" forState:UIControlStateNormal];
        self.tableArrayCalendar = [[NSMutableArray alloc]init];
        pageForCalendar = 1;
        filterType = FilterTypePast;
        [self searchCalendar];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)pushPatientView:(NSInteger)patientID{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PatientViewController *view = (PatientViewController *)[story instantiateViewControllerWithIdentifier:@"PatientViewController"];
    view.patientID = patientID;
    [self.navigationController pushViewController:view animated:YES];
}

- (NSString *)currentDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

- (double)currentDateMilliSeconds{
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    return timeInSeconds;
}
#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (nowSegmentView.hidden == NO) {
        return [self.tableArrayNow count];
    } else {
        return [self.tableArrayCalendar count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (nowSegmentView.hidden == NO) {
        return 70;
    } else {
        return 70;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    if (nowSegmentView.hidden == NO) {
        ThirdViewNowCell *cell = [[ThirdViewNowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setEntity:[_tableArrayNow myObjectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    } else {
        ThirdViewCalendarCell *cell = [[ThirdViewCalendarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setEntity:[_tableArrayCalendar myObjectAtIndex:indexPath.row] indexPath:indexPath];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (nowSegmentView.hidden == NO) {
        //name segement view
        ThirdViewNowEntity *entity = [self.tableArrayNow myObjectAtIndex:indexPath.row];
        [self pushPatientView:entity.patientID];
    } else {
        //date segment view
        ThirdViewCalendarEntity *entity = [self.tableArrayCalendar myObjectAtIndex:indexPath.row];
        [self pushPatientView:entity.patientID];
    }
}

#pragma mark - connection

- (void)searchNow{
    if (pageForNow == 1) {
        self.tableArrayNow = [[NSMutableArray alloc]init];
         [self.tableViewNow reloadData];
    }
    [self dismissTextField];
    [ProgressHUD show:@""];
    
    pageForNow = 1;
    NSDictionary *params = @{
                             @"date_from":[NSNumber numberWithDouble:0.0]/*[self currentDateMilliSeconds]]*/,
                             @"page": [NSNumber numberWithInteger:pageForNow]
                             };
    [Networking formDataWithPath:@"online_booking/doctor/visit" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            if ( [[[responseDict valueForKey:@"data"]valueForKey:@"items"]count] > 0) {
                for (NSDictionary *dic in [[[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]objectAtIndex:0] myObjectForKey:@"visits"]) {
                    ThirdViewNowEntity *entity = [ThirdViewNowEntity new];
                    entity.nameString = [[dic  myObjectForKey:@"patient"] myObjectForKey:@"name"];
                    entity.patientID = [[[dic  myObjectForKey:@"patient"] myObjectForKey:@"id"]integerValue];
                    entity.timeStartString = [dic  myObjectForKey:@"time_start"];
                    entity.timeEndString = [dic  myObjectForKey:@"time_end"];
                    entity.jalaliDateString = [dic  myObjectForKey:@"jalali"];
                    entity.dateTimeStamp = [[dic  myObjectForKey:@"date"]doubleValue];
                    entity.statusString = [[dic  myObjectForKey:@"status"] myObjectForKey:@"name"];
                    entity.aliasString = [[dic  myObjectForKey:@"status"] myObjectForKey:@"alias"];
                    entity.descriptionString = [dic  myObjectForKey:@"title"];
                    [self.tableArrayNow addObject:entity];
                    
                    //we need just first item for now section
                    break;
                }
            }
            if ([self.tableArrayNow count] == 0) {
                [noresultLabel removeFromSuperview];
                noresultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, screenWidth - 20, 25)];
                noresultLabel.font = FONT_NORMAL(15);
                noresultLabel.textAlignment = NSTextAlignmentRight;
                noresultLabel.text = @"نوبتی در حال برگزاری وجود ندارد";
                [self.tableViewNow addSubview:noresultLabel];
            } else {
                [self.tableViewNow reloadData];
            }
            
        }else{
            if ([self.tableArrayNow count] == 0) {
                [noresultLabel removeFromSuperview];
                noresultLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, screenWidth - 40, 25)];
                noresultLabel.font = FONT_NORMAL(15);
                noresultLabel.textAlignment = NSTextAlignmentRight;
                noresultLabel.text = @"نوبتی در حال برگزاری وجود ندارد";
                [self.tableViewNow addSubview:noresultLabel];
            } else {
                [self.tableViewNow reloadData];
            }

            //[[AZJAlertView sharedInstance]showMessage:[responseDict  myObjectForKey:@"message"] withType:AZJAlertMessageTypeError];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}

- (void)searchCalendar{
    if (pageForCalendar == 1) {
        self.tableArrayCalendar = [[NSMutableArray alloc]init];
        [self.tableViewCalendar reloadData];
    }
    [self dismissTextField];
    [ProgressHUD show:@""];
    
    NSDictionary *params;
    switch (filterType) {
        case FilterTypeFutur:
            params =  @{
                        @"date_from":[NSNumber numberWithDouble:[self currentDateMilliSeconds]],
                        @"page": [NSNumber numberWithInteger:pageForCalendar],
                        @"limit": [NSNumber numberWithInteger:20]
                        };
            break;
        case FilterTypePast:
            params =  @{
                        @"date_to":[NSNumber numberWithDouble:[self currentDateMilliSeconds]],
                        @"page": [NSNumber numberWithInteger:pageForCalendar],
                        @"limit": [NSNumber numberWithInteger:20]
                        };
            break;
        case FilterTypeCanceled:
            params =  @{
                        @"status_alias":@"canceled",
                        @"page": [NSNumber numberWithInteger:pageForCalendar],
                        @"limit": [NSNumber numberWithInteger:20]
                        };
            break;
            
        default:
            break;
    }
    
    [Networking formDataWithPath:@"online_booking/doctor/visits" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            if ( [[responseDict valueForKey:@"data"]valueForKey:@"items"]) {
                for (NSDictionary *adic in [[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]) {
                    for (NSDictionary *dic in [adic  myObjectForKey:@"visits"]) {
                        ThirdViewCalendarEntity *entity = [ThirdViewCalendarEntity new];
                        entity.nameString = [[dic  myObjectForKey:@"patient"] myObjectForKey:@"name"];
                        entity.patientID = [[[dic  myObjectForKey:@"patient"] myObjectForKey:@"id"]integerValue];
                        entity.timeStartString = [dic  myObjectForKey:@"time_start"];
                        entity.timeEndString = [dic  myObjectForKey:@"time_end"];
                        entity.jalaliDateString = [dic  myObjectForKey:@"jalali"];
                        entity.dateTimeStamp = [[dic  myObjectForKey:@"date"]doubleValue];
                        entity.statusString = [[dic  myObjectForKey:@"status"] myObjectForKey:@"name"];
                        entity.aliasString = [[dic  myObjectForKey:@"status"] myObjectForKey:@"alias"];
                        entity.descriptionString = [dic  myObjectForKey:@"title"];
                        [self.tableArrayCalendar addObject:entity];
                    }
                }
                [self.tableViewCalendar reloadData];
            }
            
        }else{
            [[AZJAlertView sharedInstance]showMessage:[responseDict  myObjectForKey:@"message"] withType:AZJAlertMessageTypeError];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
        // we are at the end
        if (nowSegmentView.hidden == NO) {
            //pageForNow++;
            //[self searchNow];
        } else {
            pageForCalendar++;
            [self searchCalendar];
        }
    }
}

@end
