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
    [self makeTableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - custom methods
- (void)finishThreatmentAction{
    
}
- (void)backButtonImgAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)makeTableView{
    self.tableArray = [[NSMutableArray alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64 - 40 - 50)];
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
    AllSessionEntity *entity = [self.tableArray objectAtIndex:idOf];
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
    [cell setEntity:[_tableArray objectAtIndex:indexPath.row] indexPath:indexPath];
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
        if ([[responseDict objectForKey:@"success"]integerValue] == 1) {
            if ([[[responseDict objectForKey:@"data"]valueForKey:@"items"]count] > 0) {
                for (NSDictionary *dic in [[[[responseDict objectForKey:@"data"]objectForKey:@"items"]objectAtIndex:0]objectForKey:@"visits"]) {
                    AllSessionEntity *entity = [AllSessionEntity new];
                    entity.nameString = [dic objectForKey:@"title"];
                    entity.sessionID = [[dic objectForKey:@"id"]integerValue];
                    entity.treatmentID = [[dic objectForKey:@"treatment_id"]integerValue];
                    entity.dateTimeStamp = [[dic objectForKey:@"date"]doubleValue];
                    [self.tableArray addObject:entity];
                }
                
            }
            [self.tableView reloadData];
        }else{
            [[AZJAlertView sharedInstance]showMessage:[responseDict objectForKey:@"message"] withType:AZJAlertMessageTypeError];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}
@end
