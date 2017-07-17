//
//  PatientViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 3/4/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "PatientViewController.h"

@interface PatientViewController ()
{
    UIScrollView *scrollView;
    UIView *infoView;
    UIView *infoViewWife;
    UIView *infoViewDoreDarman;
    UILabel *usernameLabel;
    NSDictionary *dictionary;
    UIButton *showWifeInfoButton;
    UIButton *doreDarmanButton;
    CGFloat yposOfWifeInfoTitle;
    BOOL hasWife;
}
@end

@implementation PatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitleLabel:@"پرونده مراجعه کننده"];
    
    //back button
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
    [self getProfileDataFromServer];
    [self scrollviewMaker];
    [self topSectionView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)backButtonImgAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)scrollviewMaker{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, screenHeight - 70)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    //scrollView.backgroundColor = [UIColor redColor];
}

- (void)topSectionView{
    // name
    UILabel *nameTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 110, 10, 100, 25)];
    nameTitleLabel.font = FONT_NORMAL(13);
    nameTitleLabel.textAlignment = NSTextAlignmentRight;
    nameTitleLabel.text = @"نام و نام خانوادگی: ";
    [scrollView addSubview:nameTitleLabel];
    
    usernameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, 10, screenWidth - 120, 25)];
    usernameLabel.numberOfLines = 2;
    usernameLabel.font = FONT_NORMAL(13);
    usernameLabel.minimumScaleFactor = 0.5;
    usernameLabel.adjustsFontSizeToFitWidth = YES;
    usernameLabel.textColor = [UIColor blackColor];
    usernameLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:usernameLabel];
    
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(20, usernameLabel.frame.origin.y + usernameLabel.frame.size.height + 5, screenWidth - 40, 1)];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:horizontalLine];
}

- (void)makeElementsOFInfoView:(NSDictionary *)elements{
    CGFloat ypos2 = usernameLabel.frame.origin.y + usernameLabel.frame.size.height + 10;
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, ypos2, screenWidth - 20, 25)];
    label.numberOfLines = 2;
    label.font = FONT_NORMAL(16);
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentRight;
    label.text = @"اطلاعات شخصی بیمار: ";
    [scrollView addSubview:label];
    
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, ypos2 + 25, screenWidth, screenHeight)];
    [scrollView addSubview:infoView];
    CGFloat ypos = 0;
    for (NSDictionary *dic in elements) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 + 20, ypos, screenWidth/2 - 30, 25)];
        label.numberOfLines = 0;
        label.font = FONT_NORMAL(13);
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = [dic  myObjectForKey:@"name"];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentRight;
        [infoView addSubview:label];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth/2) - label.text.getWidthOfString - 10, ypos, screenWidth/2, 25)];
        label2.numberOfLines = 0;
        label2.font = FONT_NORMAL(13);
        label2.minimumScaleFactor = 0.5;
        label2.adjustsFontSizeToFitWidth = YES;
        if ([[dic  myObjectForKey:@"type"] isEqualToString:@"date"]) {
            label2.text = [ConvertToPersianDate convertToShamsi:[[dic  myObjectForKey:@"value"]doubleValue]];
        }else if ([[dic  myObjectForKey:@"alias"] isEqualToString:@"marital_status"]) {
            label2.text = [self convertMaritalStatus:[[dic  myObjectForKey:@"marital_status"]integerValue]];
        }else{
            label2.text = [dic  myObjectForKey:@"value"];
        }
        label2.textColor = MAIN_COLOR;
        label2.textAlignment = NSTextAlignmentRight;
        [infoView addSubview:label2];
        
        ypos += 35;
    }
    
    CGRect frame = infoView.frame;
    frame.size.height = ypos + 50;
    [infoView setFrame:frame];
    scrollView.contentSize = CGSizeMake(screenWidth, ypos + ypos2 + 200);
    
    
    if (hasWife) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self makeElementsOFWifeView:[[dictionary  myObjectForKey:@"data"] myObjectForKey:@"wife_options"]];
        });
    }else{
        if (!doreDarmanButton) {
            [self doreDarmanView:infoView.frame.origin.y + infoView.frame.size.height - 50];
        }
    }

}

- (NSString *)convertMaritalStatus:(NSInteger)idx{
    NSString *str;
    if (idx == 0) {
        hasWife = NO;
       return str = @"مجرد";
    } else {
        hasWife = YES;
       return str = @"متاهل";
    }
}
- (void)makeElementsOFWifeView:(NSDictionary *)elements{
    yposOfWifeInfoTitle = infoView.frame.origin.y + infoView.frame.size.height - 50;
    UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(10, yposOfWifeInfoTitle, screenWidth - 20, 25)];
    label.numberOfLines = 2;
    label.font = FONT_NORMAL(16);
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"اطلاعات همسر بیمار";
    [scrollView addSubview:label];
    
    infoViewWife = [[UIView alloc]initWithFrame:CGRectMake(0, yposOfWifeInfoTitle + 25, screenWidth, screenHeight)];
    [scrollView addSubview:infoViewWife];
    CGFloat ypos = 20;
    for (NSDictionary *dic in elements) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 + 20, ypos, screenWidth/2 - 30, 25)];
        label.numberOfLines = 0;
        label.font = FONT_NORMAL(13);
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = [dic  myObjectForKey:@"name"];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        [infoViewWife addSubview:label];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(10, ypos, screenWidth/2, 25)];
        label2.numberOfLines = 0;
        label2.font = FONT_NORMAL(13);
        label2.minimumScaleFactor = 0.5;
        label2.adjustsFontSizeToFitWidth = YES;
        label2.text = [dic  myObjectForKey:@"value"];
        label2.textColor = MAIN_COLOR;
        label2.textAlignment = NSTextAlignmentRight;
        label2.backgroundColor = [UIColor clearColor];
        [infoViewWife  addSubview:label2];
        
        ypos += 35;
    }
    
    CGRect frame = infoViewWife.frame;
    frame.size.height = ypos;
    [infoViewWife setFrame:frame];
    
    scrollView.contentSize = CGSizeMake(screenWidth, ypos + yposOfWifeInfoTitle);
    
    showWifeInfoButton = [CustomButton initButtonWithImage:[UIImage imageNamed:@"down"] withFrame:CGRectMake(screenWidth/2 - 10, yposOfWifeInfoTitle + 20, 20, 20)];
    [showWifeInfoButton addTarget:self action:@selector(showWifeInfoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:showWifeInfoButton];
    
    [self hideWifeInfo:yposOfWifeInfoTitle];
}

- (void)hideWifeInfo:(CGFloat)y{
    infoViewWife.hidden = YES;
    scrollView.contentSize = CGSizeMake(screenWidth, y);
    [showWifeInfoButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    
    if (!doreDarmanButton) {
        [self doreDarmanView:yposOfWifeInfoTitle + 100];
    } else {
        CGRect frame = infoViewDoreDarman.frame;
        frame.origin.y = yposOfWifeInfoTitle + 100;
        [infoViewDoreDarman setFrame:frame];
        
        scrollView.contentSize = CGSizeMake(screenWidth, frame.origin.y + frame.size.height + 100);
    }
    
}

- (void)showWifeInfo:(NSInteger)y{
    infoViewWife.hidden = NO;
    scrollView.contentSize = CGSizeMake(screenWidth, infoViewWife.frame.origin.y + infoViewWife.frame.size.height + infoViewDoreDarman.frame.size.height + 100);
//    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
//    [scrollView setContentOffset:bottomOffset animated:YES];
    [showWifeInfoButton setImage:[UIImage imageNamed:@"up"] forState:UIControlStateNormal];
    
    CGRect frame = infoViewDoreDarman.frame;
    frame.origin.y = infoViewWife.frame.origin.y + infoViewWife.frame.size.height + 50;
    [infoViewDoreDarman setFrame:frame];
    
    frame.origin.y = showWifeInfoButton.frame.origin.y;
    //scrollView.contentSize = CGSizeMake(screenWidth, frame.origin.y + frame.size.height + 100);
    [scrollView scrollRectToVisible:frame animated:YES];
}

- (void)showWifeInfoButtonAction{
    if (infoViewWife.hidden == NO) {
        [self hideWifeInfo: infoViewWife.frame.origin.y + infoViewWife.frame.size.height + 200];
        
    } else {
        [self showWifeInfo:infoViewWife.frame.origin.y + infoViewWife.frame.size.height + 250];
    }
}

- (void)doreDarmanView:(CGFloat)y{
    infoViewDoreDarman = [[UIView alloc]initWithFrame:CGRectMake(0, y, screenWidth, screenHeight)];
    [scrollView addSubview:infoViewDoreDarman];
    doreDarmanButton = [CustomButton initButtonWithTitle:@"دوره های درمان" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES
                                               withFrame:CGRectMake(screenWidth/2 - 65, 0, 130, 30)];
    //[doreDarmanButton addTarget:self action:@selector(allSessionsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [infoViewDoreDarman addSubview:doreDarmanButton];
    
    [self makeElementsOFDoreDarmanView:[[dictionary  myObjectForKey:@"data"] myObjectForKey:@"treatments"]];
}

- (void)makeElementsOFDoreDarmanView:(NSDictionary *)elements{
    CGFloat ypos = 40;
    for (NSDictionary *dic in elements) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 90, ypos + 5, 80, 25)];
        label.numberOfLines = 0;
        label.font = FONT_NORMAL(13);
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = @"علت مراجعه: ";//[dic  myObjectForKey:@"name"];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor clearColor];
        [infoViewDoreDarman addSubview:label];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(60, ypos + 5, screenWidth - 90 - 60, 25)];
        label2.numberOfLines = 0;
        label2.font = FONT_NORMAL(13);
        label2.minimumScaleFactor = 0.5;
        label2.adjustsFontSizeToFitWidth = YES;
        label2.text = [dic  myObjectForKey:@"title"];
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentRight;
        label2.backgroundColor = [UIColor clearColor];
        [infoViewDoreDarman  addSubview:label2];
        
        UIButton *detailButton = [CustomButton initButtonWithTitle:@"جزییات" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES
                                                         withFrame:CGRectMake(5, ypos + 5, 55, 25)];
        detailButton.tag = [[dic  myObjectForKey:@"id"]integerValue];
        [detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [infoViewDoreDarman addSubview:detailButton];
        
        UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(20, ypos + 35, screenWidth - 40, 1)];
        horizontalLine.backgroundColor = [UIColor lightGrayColor];
        [infoViewDoreDarman addSubview:horizontalLine];
        
        ypos += 35;
    }
    
    CGRect frame = infoViewDoreDarman.frame;
    frame.size.height = ypos;
    [infoViewDoreDarman setFrame:frame];
    
    scrollView.contentSize = CGSizeMake(screenWidth, infoViewDoreDarman.frame.origin.y + infoViewDoreDarman.frame.size.height + 100);
}

- (void)detailButtonAction:(id)tag{
    UIButton *btn = (UIButton *)tag;
    NSLog(@"tag: %ld", (long)btn.tag);
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllSessionsViewController *view = (AllSessionsViewController *)[story instantiateViewControllerWithIdentifier:@"AllSessionsViewController"];
    view.treatmentID = btn.tag;
    [self.navigationController pushViewController:view animated:YES];
}
#pragma mark - Connection
-(void)getProfileDataFromServer
{
    [ProgressHUD show:@""];
    NSDictionary *params = @{
                             @"id":[NSNumber numberWithInteger:_patientID]
                             };
    [Networking formDataWithPath:@"profile/patient" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        dictionary  =responseDict;
        if ([[dictionary  myObjectForKey:@"error_code"]integerValue] == 401) {
            return;
        }
        usernameLabel.text = [[dictionary  myObjectForKey:@"data"] myObjectForKey:@"name"];
        [self makeElementsOFInfoView:[[dictionary  myObjectForKey:@"data"] myObjectForKey:@"options"]];
        
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}

@end
