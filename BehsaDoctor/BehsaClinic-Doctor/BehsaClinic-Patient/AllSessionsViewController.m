//
//  AllSessionsViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 3/4/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "AllSessionsViewController.h"

@interface AllSessionsViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *tableArray;
@end

@implementation AllSessionsViewController

- (void)viewWillAppear:(BOOL)animated{
    NSString *str = [[NSUserDefaults standardUserDefaults]objectForKey:@"dismissAllSession"];
    if ([str isEqualToString:@"YES"]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"dismissAllSession"];
        [self backButtonImgAction];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitleLabel:@"تمام جلسات"];
    
    //back button
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
    self.tableArray = [[NSMutableArray alloc]init];
    [self treatmentList];
    [self topSection];
    [self makeTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom methods
- (void)backButtonImgAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)baDarmangarAction{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ErjaViewController *view = (ErjaViewController *)[story instantiateViewControllerWithIdentifier:@"ErjaViewController"];
    view.treatmentID= _treatmentID;
    [self presentViewController:view animated:YES completion:nil];

}
- (void)topSection{
        // name
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 140, 74, 120, 35)];
    titleLabel.font = FONT_NORMAL(17);
    titleLabel.textAlignment = NSTextAlignmentRight;
    titleLabel.text = @"با درمانگر:";
    [self.view addSubview:titleLabel];
    
    UIButton *button = [CustomButton initButtonWithTitle:@"ارجاع مراجعه کننده" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES withFrame:CGRectMake(20, 74, 150, 35)];
    [button addTarget:self action:@selector(baDarmangarAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(20, 115, screenWidth - 40, 0.5)];
    horizontalLine.backgroundColor = MAIN_COLOR;
    [self.view addSubview:horizontalLine];

}
- (void)makeTableView{
    self.tableArray = [[NSMutableArray alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 140, screenWidth, screenHeight - 64 - 140 - 50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    UIButton *finishThreatment = [CustomButton initButtonWithTitle:@"پایان دوره درمان" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:NO withFrame:CGRectMake(-5, screenHeight - 88, screenWidth + 10,40)];
    [finishThreatment addTarget:self action:@selector(finishThreatmentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishThreatment];
}

- (void)pushToSessionDetail:(NSInteger)idOf{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SessionDetailViewController *view = (SessionDetailViewController *)[story instantiateViewControllerWithIdentifier:@"SessionDetailViewController"];
    AllSessionEntity *entity = [self.tableArray myObjectAtIndex:idOf];
    view.patientID = entity.sessionID;
    view.treatmentID = entity.treatmentID;
    [self presentViewController:view animated:YES completion:nil];
}

#pragma mark - table view delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

- (AllSessionCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    AllSessionCell *cell = [[AllSessionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    [cell setEntity:[_tableArray myObjectAtIndex:indexPath.row] indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self pushToSessionDetail:indexPath.row];
    
}

#pragma mark - connection
- (void)treatmentList{
    [self dismissTextField];
    [ProgressHUD show:@""];
    NSDictionary *params = @{@"treatment_id":[NSNumber numberWithDouble:_treatmentID]
                             };
    [Networking formDataWithPath:@"online_booking/doctor/visits" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            if ([[[responseDict  myObjectForKey:@"data"]valueForKey:@"items"]count] > 0) {
                for (NSDictionary *dic in [[[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"items"]objectAtIndex:0] myObjectForKey:@"visits"]) {
                    AllSessionEntity *entity = [AllSessionEntity new];
                    entity.nameString = [dic  myObjectForKey:@"title"];
                    entity.sessionID = [[dic  myObjectForKey:@"id"]integerValue];
                    entity.treatmentID = [[dic  myObjectForKey:@"treatment_id"]integerValue];
                    entity.dateTimeStamp = [[dic  myObjectForKey:@"date"]doubleValue];
                    [self.tableArray addObject:entity];
                }
            }
            [self.tableView reloadData];
        }else{
            [[AZJAlertView sharedInstance]showMessage:[responseDict  myObjectForKey:@"message"] withType:AZJAlertMessageTypeError];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}

- (void)finishThreatmentAction{
    [ProgressHUD show:@""];
    NSDictionary *params = @{@"id":[NSNumber numberWithDouble:_treatmentID]
                             };
    [Networking formDataWithPath:@"online_booking/treatment_finish" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            [[AZJAlertView sharedInstance]showMessage:[responseDict  myObjectForKey:@"message"] withType:AZJAlertMessageTypeInfo];
        }else{
            [[AZJAlertView sharedInstance]showMessage:[responseDict  myObjectForKey:@"message"] withType:AZJAlertMessageTypeError];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}
@end
