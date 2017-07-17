//  Created by Yarima on 7/27/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import "ReportAbuseViewController.h"
#define TIMER_DISABLE_SENDBUTTON   1.0 // in seconds
@interface ReportAbuseViewController ()<UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate ,UITextFieldDelegate>
{
    UITextView *mytextView;
    UIPickerView *pickerView;
    NSMutableArray *pickerviewArray;
    UITextField *typeTextField;
    NSInteger selectedTypeId;
    UIButton *sendButton;
}
@end

@implementation ReportAbuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self getTagsFromServer];
    [self makeTopBar];
}

- (void)makeTopBar{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
    topView.backgroundColor = MAIN_COLOR;
    topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTextField)];
    [topView addGestureRecognizer:tap];
    [self.view addSubview:topView];
    
    CGFloat topViewHeight = topView.frame.size.height;
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 - 100, topViewHeight/2 - 15, 200, 40)];
    titleLabel.font = FONT_NORMAL(16);
    titleLabel.text = @"گزارش ";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
    mytextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, 120)];
    mytextView.delegate = self;
    mytextView.textAlignment = NSTextAlignmentRight;
    mytextView.text = NSLocalizedString(@"جزییات گزارش را وارد نمایید", @"");
    mytextView.layer.borderColor = [UIColor blackColor].CGColor;
    mytextView.layer.borderWidth = 1.0;
    mytextView.font = FONT_NORMAL(13);
    mytextView.textColor = [UIColor lightGrayColor]; //optional
    mytextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self.view addSubview:mytextView];

    UIButton *button = [CustomButton initButtonWithTitle:NSLocalizedString(@"pishnahad", @"") withTitleColor:[UIColor blackColor] withBackColor:[UIColor clearColor] withFrame:CGRectMake(20, mytextView.frame.origin.y + 140, screenWidth - 40, 40)];
    //[self.view addSubview:button];
    
    typeTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, mytextView.frame.origin.y + 130, screenWidth - 40, 40)];
    typeTextField.backgroundColor = [UIColor clearColor];
    typeTextField.inputView = pickerView;
    typeTextField.text = @"انتخاب کنید▾";
    typeTextField.tag = 103;
    typeTextField.delegate = self;
    typeTextField.font = FONT_NORMAL(15);
    typeTextField.layer.borderColor = [UIColor blackColor].CGColor;
    typeTextField.layer.borderWidth = 1.0;
    typeTextField.layer.cornerRadius = 5;
    typeTextField.clipsToBounds = YES;
    typeTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    typeTextField.textAlignment = NSTextAlignmentCenter;
    typeTextField.textColor = [UIColor blackColor];
    [self.view addSubview:typeTextField];
    
    UIImageView *dropImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 100, 10, 15, 15)];
    dropImageView.image = [UIImage imageNamed:@"dropDown"];
    [typeTextField addSubview:dropImageView];


    sendButton = [CustomButton initButtonWithTitle:@"ثبت" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:NO withFrame:CGRectMake(0, button.frame.origin.y + 50, screenWidth, 40)];
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];

}

- (void)backButtonImgAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendButtonAction{
    [self sendToServer];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)menuButtonAction {
    //[self showHideRightMenu];
    [mytextView resignFirstResponder];
    [typeTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toggleMenuVisibility" object:nil];
}

- (void)dismissTextField{
    [mytextView resignFirstResponder];
}

#pragma mark - textView delegate
- (void)textViewDidChangeSelection:(UITextView *)textView{
    if ([textView.text isEqualToString:NSLocalizedString(@"جزییات گزارش را وارد نمایید", @"")] && [textView.textColor isEqual:[UIColor lightGrayColor]])[textView setSelectedRange:NSMakeRange(0, 0)];
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    [textView setSelectedRange:NSMakeRange(0, 0)];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length != 0 && [[textView.text substringFromIndex:1] isEqualToString:NSLocalizedString(@"جزییات گزارش را وارد نمایید", @"")] && [textView.textColor isEqual:[UIColor lightGrayColor]]){
        textView.text = [textView.text substringToIndex:1];
        textView.textColor = [UIColor blackColor]; //optional
        
    }
    else if(textView.text.length == 0){
        textView.text = NSLocalizedString(@"جزییات گزارش را وارد نمایید", @"");
        textView.textColor = [UIColor lightGrayColor];
        [textView setSelectedRange:NSMakeRange(0, 0)];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = NSLocalizedString(@"جزییات گزارش را وارد نمایید", @"");
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length > 1 && [textView.text isEqualToString:NSLocalizedString(@"جزییات گزارش را وارد نمایید", @"")]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    return YES;
}

#pragma mark -  pickerview delegate

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerviewArray count];
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* tView = (UILabel*)view;
    NSString *title = @"";
    title = [[pickerviewArray objectAtIndex:row]objectForKey:@"title"];
    
    if (!tView){
        tView = [[UILabel alloc] init];
        UIFont *font = FONT_NORMAL(19);
        tView.textAlignment = NSTextAlignmentCenter;
        tView.font =font;
    }
    tView.text = [NSString stringWithFormat:@"%@", title];
    return tView;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    selectedTypeId = [[[pickerviewArray objectAtIndex:row]objectForKey:@"id"]integerValue];
    typeTextField.text = [[pickerviewArray objectAtIndex:row]objectForKey:@"title"];
    [typeTextField resignFirstResponder];
    
    [self enableSendButton];
}


#pragma mark - connection
- (BOOL)hasConnectivity {
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithAddress(kCFAllocatorDefault, (const struct sockaddr*)&zeroAddress);
    if(reachability != NULL) {
        //NetworkStatus retVal = NotReachable;
        SCNetworkReachabilityFlags flags;
        if (SCNetworkReachabilityGetFlags(reachability, &flags)) {
            if ((flags & kSCNetworkReachabilityFlagsReachable) == 0)
            {
                // if target host is not reachable
                return NO;
            }
            
            if ((flags & kSCNetworkReachabilityFlagsConnectionRequired) == 0)
            {
                // if target host is reachable and no connection is required
                //  then we'll assume (for now) that your on Wi-Fi
                return YES;
            }
            
            
            if ((((flags & kSCNetworkReachabilityFlagsConnectionOnDemand ) != 0) ||
                 (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) != 0))
            {
                // ... and the connection is on-demand (or on-traffic) if the
                //     calling application is using the CFSocketStream or higher APIs
                
                if ((flags & kSCNetworkReachabilityFlagsInterventionRequired) == 0)
                {
                    // ... and no [user] intervention is needed
                    return YES;
                }
            }
            
            if ((flags & kSCNetworkReachabilityFlagsIsWWAN) == kSCNetworkReachabilityFlagsIsWWAN)
            {
                // ... but WWAN connections are OK if the calling application
                //     is using the CFNetwork (CFSocketStream?) APIs.
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark - connection

- (void)getTagsFromServer{
    NSString *url = [NSString stringWithFormat:@"%@api/report_abuse/getReason", BaseURL];
    
    AFHTTPSessionManager *manager = [NetworkManager shareManager2];
    [manager POST:url parameters:nil progress:nil success:^(NSURLSessionTask *operation, id responseObject) {
        NSDictionary *tempDic = (NSDictionary *)responseObject;
        pickerviewArray = [[NSMutableArray alloc]init];
        for (NSDictionary *tag in [tempDic objectForKey:@"data"]) {
            [pickerviewArray addObject:tag];
        }
        
        selectedTypeId = 0;
        
        pickerView = [[UIPickerView alloc] init];
        [pickerView setDataSource: self];
        [pickerView setDelegate: self];
        pickerView.tag = 1;
        pickerView.backgroundColor = [UIColor whiteColor];
        [pickerView setFrame: CGRectMake(0, screenHeight, screenWidth, 200.0f)];
        typeTextField.inputView = pickerView;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        [self getTagsFromServer];
    }];
    
}

- (void)enableSendButton{
    sendButton.userInteractionEnabled = YES;
}

- (void)sendToServer{
    [ProgressHUD show:@""];
    NSDictionary *params = @{@"model":_model,
                                    @"foreign_key":[NSNumber numberWithInteger:_idOfProfile],
                                    @"reason":[NSNumber numberWithInteger:selectedTypeId],
                                    @"desc":mytextView.text
                                    };
    
    NSString *url = [NSString stringWithFormat:@"%@api/report_abuse/new", BaseURL];
    AFHTTPSessionManager *manager = [NetworkManager shareManager2];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //NSLog(@"%f",uploadProgress.fractionCompleted);
        dispatch_async(dispatch_get_main_queue(), ^{
            //[sendButton setTitle:[NSString stringWithFormat:@"%f", uploadProgress.fractionCompleted] forState:UIControlStateNormal];
            
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        [self dismissViewControllerAnimated:YES completion:^{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@", [responseObject objectForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@", [error localizedDescription]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            // ////NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}


@end
