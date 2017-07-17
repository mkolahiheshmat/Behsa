//
//  SecondViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/11/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "SharhViewController.h"

@interface SharhViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    NSInteger page;//page parameter for tab date paging
}
@property(nonatomic, retain)UITableView *tableViewName;
@property(nonatomic, retain)NSMutableArray *tableArrayName;
@property(nonatomic, retain)UITableView *tableViewDate;
@property(nonatomic, retain)NSMutableArray *tableArrayDate;
@end

@implementation SharhViewController
- (void)viewWillAppear:(BOOL)animated{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //superView = self.view;
    [self setTitleLabel:@"نیاز به شرح"];
    
    [self makeTableView];
    
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
    page = 1;
    [self fetchlist];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)backButtonImgAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)makeTableView{
    self.tableArrayDate = [[NSMutableArray alloc]init];
    CGFloat yPos = 64;
    self.tableViewDate = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screenWidth, screenHeight - yPos - 50)];
    self.tableViewDate.delegate = self;
    self.tableViewDate.dataSource = self;
    [self.view addSubview:self.tableViewDate];
}

- (void)pushToPatientView:(NSInteger)patientID treatmentID:(NSInteger)treatmentID{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SessionDetailViewController2 *view = (SessionDetailViewController2 *)[story instantiateViewControllerWithIdentifier:@"SessionDetailViewController2"];
    view.patientID = patientID;
    view.treatmentID = treatmentID;
    [self.navigationController pushViewController:view animated:YES];
}

- (NSString *)convertToShamsi:(double)timeStamp{
    double timestampval = timeStamp;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [ConvertToPersianDate ConvertToPersianFromGregorianDate2:startDate];
}

- (double)currentDateMilliSeconds{
    NSTimeInterval timeInSeconds = [[NSDate date] timeIntervalSince1970];
    return timeInSeconds;
}

#pragma mark - table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_tableArrayDate count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView;
    headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 30)];
    headerView.backgroundColor = [UIColor lightGrayColor];
    SeconViewDateEntity *entity = [_tableArrayDate objectAtIndex:section];
    
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
    SeconViewDateEntity *entity = [SeconViewDateEntity new];
    entity = [self.tableArrayDate objectAtIndex:section];
    return [entity.visitsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    SecondViewDateCell *cell = [[SecondViewDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setEntity:[_tableArrayDate objectAtIndex:indexPath.section] indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.tableArrayDate count] > 0) {
        SeconViewDateEntity *entity = [self.tableArrayDate objectAtIndex:indexPath.section];
        [self pushToPatientView:[[[[entity.visitsArray objectAtIndex:indexPath.row] myObjectForKey:@"patient"] myObjectForKey:@"id"]integerValue]
                    treatmentID:[[[entity.visitsArray objectAtIndex:indexPath.row] myObjectForKey:@"treatment_id"]integerValue]];
    }
    
}

#pragma mark - connection

- (void)fetchlist{
    if (page == 1) {
        self.tableArrayDate = [[NSMutableArray alloc]init];
    }
    [self dismissTextField];
    [ProgressHUD show:@""];
    NSDictionary *params = @{
                             @"date_to":[NSNumber numberWithDouble:[self currentDateMilliSeconds]],
                             @"need_health_record":[NSNumber numberWithBool:YES],
                             @"page":[NSNumber numberWithInteger:page]
                             };
    [Networking formDataWithPath:@"online_booking/doctor/visits" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        self.tableViewDate.userInteractionEnabled = NO;
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            for (NSDictionary *dic in [[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]) {
                SeconViewDateEntity *entity = [SeconViewDateEntity new];
                entity.visitsArray = [dic  myObjectForKey:@"visits"];
                entity.dateTimeStamp = [[dic  myObjectForKey:@"date"]doubleValue];
                [self.tableArrayDate addObject:entity];
            }
            [self.tableViewDate reloadData];
            self.tableViewDate.userInteractionEnabled = YES;
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
        page++;
        [self fetchlist];
    }
}

@end
