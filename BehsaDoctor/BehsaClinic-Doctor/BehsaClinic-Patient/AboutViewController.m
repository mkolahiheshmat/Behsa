    //
    //  AboutViewController.m
    //  MSN
    //
    //  Created by Yarima on 5/29/16.
    //  Copyright © 2016 Arash. All rights reserved.
    //

#import "AboutViewController.h"
#import "Header.h"
#import <AFHTTPSessionManager.h>
#import <UIImageView+AFNetworking.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "MapViewController.h"
#import "BranchModel.h"
@interface AboutViewController ()<MFMailComposeViewControllerDelegate>
{
    NSMutableArray *branchesArray;
    NSArray *telArray;
}
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *tableArray;
@end

@implementation AboutViewController
- (void)viewWillAppear:(BOOL)animated{
        //[self fetchBranches];
}
- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden = YES;
    
    [super viewDidLoad];
    
    [self makeTopBar];
    [self makeBody];
        //NSLog(@"self.navigationControllers: %@", [self.navigationController viewControllers]);
}

#pragma mark - Custom methods

- (void)makeTopBar{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
    topView.backgroundColor = MAIN_COLOR;
    
    [self.view addSubview:topView];
    
    CGFloat topViewHeight = topView.frame.size.height;
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 - 100, topViewHeight/2 - 15, 200, 40)];
    titleLabel.font = FONT_NORMAL(20);
    titleLabel.text = NSLocalizedString(@"aboutus", @"");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
}

- (void)makeBody{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, screenHeight - 70)];
    [self.view addSubview:scrollView];
    
    CGFloat heightOfLabel = [NSLocalizedString(@"about", @"") getHeightOfString];
    UITextView *contentTextView;
    if (IS_IPAD) {
        contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, screenWidth - 40, 400)];
        contentTextView.font = FONT_NORMAL(21);
    } else {
        contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 0, screenWidth - 40, heightOfLabel)];
        contentTextView.font = FONT_NORMAL(13);
    }
    
    
    contentTextView.editable = NO;
    UITextPosition *beginning = contentTextView.beginningOfDocument;
    UITextPosition *start = [contentTextView positionFromPosition:beginning offset:0];
    UITextPosition *end = [contentTextView positionFromPosition:start offset:[contentTextView.text length]];
    UITextRange *textRange = [contentTextView textRangeFromPosition:start toPosition:end];
    [contentTextView setBaseWritingDirection:UITextWritingDirectionRightToLeft forRange:textRange];
    contentTextView.textAlignment = NSTextAlignmentJustified;
    contentTextView.text = NSLocalizedString(@"about", @"");
    contentTextView.textColor = [UIColor blackColor];
    [scrollView addSubview:contentTextView];
    
    UIButton *mapButton = [CustomButton initButtonWithImage:[UIImage imageNamed:@"map"] withFrame:CGRectMake(0, contentTextView.frame.origin.y + contentTextView.frame.size.height - 10, screenWidth, screenWidth * 0.34)];
    [mapButton addTarget:self action:@selector(mapButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:mapButton];
    
    UILabel *addressLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth- 210, mapButton.frame.origin.y + mapButton.frame.size.height + 20, 200, 25)];
    addressLabel.font = FONT_NORMAL(15);
    addressLabel.text = NSLocalizedString(@"address", @"");
    addressLabel.textColor = [UIColor grayColor];
    addressLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:addressLabel];
    
    UILabel *addressLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(10, addressLabel.frame.origin.y + addressLabel.frame.size.height - 10, screenWidth - 20, 45)];
    addressLabel2.font = FONT_NORMAL(13);
    addressLabel2.numberOfLines = 0;
    addressLabel2.text = NSLocalizedString(@"address2", @"");
    addressLabel2.textColor = [UIColor blackColor];
    addressLabel2.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:addressLabel2];
    
    UILabel *telLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth- 210, addressLabel2.frame.origin.y + addressLabel2.frame.size.height, 200, 25)];
    telLabel.font = FONT_NORMAL(15);
    telLabel.text = @"شماره تماس";
    telLabel.textColor = [UIColor grayColor];
    telLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:telLabel];
    
    telArray = [[NSArray alloc]initWithObjects:NSLocalizedString(@"tel1", @""),
                NSLocalizedString(@"tel2", @""),
                NSLocalizedString(@"tel3", @""),
                NSLocalizedString(@"tel4", @""), nil];
    CGFloat yPOS = telLabel.frame.origin.y + telLabel.frame.size.height +5;
    for (NSInteger i = 0; i < [telArray count]; i++) {
        NSString *str =  [NSString stringWithFormat:@"%@", [telArray myObjectAtIndex:i]];
        UIButton *telButton = [CustomButton initButtonWithTitle:str withTitleColor:[UIColor blueColor] withBackColor:[UIColor clearColor]
                                                      withFrame:CGRectMake(screenWidth- 110, yPOS, 100, 20)];
        telButton.tag = i;
        [telButton addTarget:self action:@selector(telButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:telButton];
        yPOS += 24;
    }
    
    UILabel *mobLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth- 210, yPOS, 200, 25)];
    mobLabel.font = FONT_NORMAL(15);
    mobLabel.text = @"تلفن همراه";
    mobLabel.textColor = [UIColor grayColor];
    mobLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:mobLabel];
    
    UIButton *mobButton = [CustomButton initButtonWithTitle:NSLocalizedString(@"mob1", @"") withTitleColor:[UIColor blueColor] withBackColor:[UIColor clearColor]
                                                  withFrame:CGRectMake(screenWidth- 110, yPOS + 30, 100, 20)];
    [mobButton addTarget:self action:@selector(mobButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:mobButton];
    
    scrollView.contentSize = CGSizeMake(screenWidth, yPOS + 50);
    
}

- (void)telButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSString *telStr = [NSString stringWithFormat:@"tel:%@", [telArray myObjectAtIndex:btn.tag]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}

- (void)mobButtonAction{
    NSString *telStr = [NSString stringWithFormat:@"tel:%@", NSLocalizedString(@"mob1", @"")];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:telStr]];
}
- (void)instaButtonAction{
    NSURL *instagramURL = [NSURL URLWithString:@"instagram://user?username=abresalamat"];
    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
        [[UIApplication sharedApplication] openURL:instagramURL];
    }else
        {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.instagram.com/abresalamat"]];
        }
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
        //handle any error
    [controller dismissViewControllerAnimated:YES completion:nil];
}


- (void)emailButtonAction{
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        [mailCont setSubject:@""];
        [mailCont setToRecipients:[NSArray arrayWithObjects:@"crm@abresalamat.ir", nil]];
        [mailCont setMessageBody:[@"" stringByAppendingString:@""] isHTML:NO];
        [self presentViewController:mailCont animated:YES completion:nil];
    }else{
            //setupemail
        
    }
}

- (void)yarimaButtonAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.yarima.co/"]];
    
}

- (void)mciButtonAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.mci.ir/"]];
    
}

- (void)logoButtonAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://health.mcicloud.ir/"]];
    
}

- (void)vasButtonAction{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://vaslab.ir"]];
    
}

- (void)menuButtonAction {
        //[self showHideRightMenu];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toggleMenuVisibility" object:nil];
}

- (void)backButtonImgAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)pushToFav{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavoritesViewController *view = (FavoritesViewController *)[story instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)pushToAbout{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *view = (AboutViewController *)[story instantiateViewControllerWithIdentifier:@"AboutViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)mapButtonAction{
    [self fillBranchEntity];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MapViewController *view = (MapViewController *)[story instantiateViewControllerWithIdentifier:@"MapViewController"];
    view.branchesArray = branchesArray;
    [self presentViewController:view animated:YES completion:nil];
}

- (void)fillBranchEntity{
    branchesArray = [[NSMutableArray alloc]init];
    BranchModel *entity = [BranchModel new];
    entity.idx = 1;
    entity.nameString = @"کلینیک بهسا";
    entity.phoneString = NSLocalizedString(@"tel1", @"");
    entity.latitude = 35.733935;
    entity.longitude = 51.441483;
    [branchesArray addObject:entity];
    
}

#pragma mark - connection
- (void)fetchBranches{
    [ProgressHUD show:@""];
    [Networking formDataWithPath:@"offices" parameters:@{} success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict myObjectForKey:@"success"]integerValue] == 1) {
            branchesArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dic in [[responseDict myObjectForKey:@"data"]objectForKey:@"items"]) {
                BranchModel *entity = [BranchModel new];
                entity.idx = [[dic myObjectForKey:@"id"]integerValue];
                entity.nameString = [dic myObjectForKey:@"name"];
                entity.phoneString = [dic myObjectForKey:@"phone"];
                entity.latitude = [[dic myObjectForKey:@"lat"]doubleValue];
                entity.longitude = [[dic myObjectForKey:@"lng"]doubleValue];
                [branchesArray addObject:entity];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
        
    }];
}

@end
