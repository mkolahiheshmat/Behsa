//
//  FourthViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/11/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "EditProfileViewController.h"

@interface EditProfileViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
{
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    UIScrollView *scrollView;
    UITextView *textView;
    UITextField *lastTextField;
    NSMutableDictionary *paramsDictionary;
    UIButton *saveChangesButton;
    UIImage *chosenImage;
}
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitleLabel:@"تغییرات پروفایل"];
    
    //save button
    saveChangesButton= [CustomButton initButtonWithTitle:@"اعمال تغییرات" withTitleColor:[UIColor grayColor] withBackColor:BUTTON_COLOR
                                                         withFrame:CGRectMake(screenWidth - 90, 25, 80, 30)];
    saveChangesButton.userInteractionEnabled = NO;
    saveChangesButton.alpha = 0.0;
    //saveChangesButton.hidden = YES;
    [saveChangesButton addTarget:self action:@selector(saveChangesButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addOnTopView:saveChangesButton];
    
    //back button
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
    [self scrollviewMaker];
    [self topSectionView];
    [self makeElementsOFInfoView:[[_dictionary myObjectForKey:@"data"]objectForKey:@"options"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods
- (void)backButtonImgAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)scrollviewMaker{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, screenHeight - 70)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 2);
}
- (void)topSectionView{
    
    profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 90, 5, 70, 70)];
    profileImageView.layer.cornerRadius = 35;
    profileImageView.clipsToBounds = YES;
    profileImageView.image = _profileImage;
    profileImageView.userInteractionEnabled = YES;
    //UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileImageViewAction)];
    //[profileImageView addGestureRecognizer:tap2];
    [scrollView addSubview:profileImageView];
    
    UIButton *uploadImageButton = [CustomButton initButtonWithTitle:@"آپلود عکس" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES withFrame:CGRectMake(60, profileImageView.frame.origin.y + 20, 120, 30)];
    [uploadImageButton addTarget:self action:@selector(uploadImageButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:uploadImageButton];
    
    UIButton *deleteButton = [CustomButton initButtonWithImage:[UIImage imageNamed:@"close"] withFrame:CGRectMake(10, profileImageView.frame.origin.y + 20, 30, 30)];
    [deleteButton addTarget:self action:@selector(deleteButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:deleteButton];
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(10, profileImageView.frame.origin.y + profileImageView.frame.size.height + 10, screenWidth - 20, 100)];
    textView.backgroundColor = [UIColor clearColor];
    textView.delegate = self;
    textView.text = [NSString stringWithFormat:@"%@", [[_dictionary myObjectForKey:@"data"]objectForKey:@"about"]];
    if ([textView.text length] == 0) {
        textView.text = @"خودتان را معرفی کنید";
    }
    textView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    textView.layer.borderWidth = 1.0;
    textView.clipsToBounds = YES;
    textView.layer.cornerRadius = 10;
    textView.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:textView];
}
- (void)makeElementsOFInfoView:(NSDictionary *)elements{
    paramsDictionary = [[NSMutableDictionary alloc]init];
    CGFloat ypos = textView.frame.origin.y + textView.frame.size.height + 20;
    for (NSDictionary *dic in elements) {
        NSString *keyString = [dic myObjectForKey:@"alias"];
        NSString *valueString = [dic myObjectForKey:@"value"];
        [paramsDictionary setObject:valueString forKey:keyString];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 + 20, ypos, screenWidth/2 - 30, 25)];
        label.numberOfLines = 0;
        label.font = FONT_NORMAL(13);
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = [dic myObjectForKey:@"name"];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentRight;
        [scrollView addSubview:label];
        
        UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(10, ypos, screenWidth/2, 25)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.text = [dic myObjectForKey:@"value"];
        textField.placeholder = keyString;
        textField.delegate = self;
        textField.font = FONT_NORMAL(12);
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0;
        textField.layer.cornerRadius = 5;
        textField.clipsToBounds = YES;
        textField.minimumFontSize = 0.5;
        textField.adjustsFontSizeToFitWidth = YES;
        textField.textAlignment = NSTextAlignmentCenter;
        [textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        textField.userInteractionEnabled = YES;
        [scrollView addSubview:textField];
        lastTextField = textField;
        ypos += 35;
    }
    
    //scrollView.contentSize = CGSizeMake(screenWidth, ypos + 20);
    scrollView.contentSize = CGSizeMake(screenWidth, ypos + 200);
}

- (void)uploadImageButtonAction{
    [self showgalleryCameraMenu];
}
- (void)deleteButtonAction{
    
}
- (void)makeInfoView{
}

- (void)dismissTextField{
    [textView resignFirstResponder];
}

- (void)saveChangesButtonAction{
    [self sendProfileDataToServer];
}

- (void)enableSaveButton{
    [saveChangesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveChangesButton.userInteractionEnabled = YES;
    //saveChangesButton.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        saveChangesButton.alpha = 100.0;
    }];
}
#pragma mark - camera roll and camera delegate
- (void)galleryButtonAction{
    [self selectPhoto];
}

- (void)cameraButtonAction{
    [self takePhoto];
}

- (void)showgalleryCameraMenu{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"لغو" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped do nothing.
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"دوربین" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // take photo button tapped.
        [self cameraButtonAction];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"گالری تصاویر" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        // choose photo button tapped.
        [self galleryButtonAction];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}


- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    chosenImage = info[UIImagePickerControllerEditedImage];
    profileImageView.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self enableSaveButton];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
}

- (void)saveImageIntoDocumets{
    //convert image into .png format.
    NSData *imageData = UIImagePNGRepresentation(profileImageView.image);
    //create instance of NSFileManager
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *appDocumentsDirectory = [DocumentDirectoy getDocuementsDirectory];
    //add our image to the path
    NSString *fullPath = appDocumentsDirectory;
    //finally save the path (image)
    BOOL resultSave = [fileManager createFileAtPath:fullPath contents:imageData attributes:nil];
    if (resultSave) {
        //NSLog(@"image saved");
    }
}

#pragma mark - text view delegate
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    [self enableSaveButton];
//}

- (void)textViewDidChange:(UITextView *)textView{
    [self enableSaveButton];
}
#pragma mark - text field delegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    return NO;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    //[textField setSelectedTextRange:[textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument]];

    if ([textField isEqual:lastTextField]) {
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y - 240);
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            scrollView.contentOffset = CGPointMake(0, textField.frame.origin.y - 180);
        }];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        scrollView.contentOffset = CGPointMake(0,0);
    }];
    return YES;
}

-(void)textFieldDidChange :(UITextField *)textField{
    [paramsDictionary setObject:textField.text forKey:textField.placeholder];
    [self enableSaveButton];
}


#pragma mark - Connection

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
-(void)sendProfileDataToServer
{
    [ProgressHUD show:@""];
    //NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    //    for (NSDictionary *dic in [[_dictionary myObjectForKey:@"data"]objectForKey:@"options"]) {
    //        NSString *keyString = [dic myObjectForKey:@"alias"];
    //        NSString *valueString = [dic myObjectForKey:@"value"];
    //        params[keyString] = valueString;
    //    }
    usernameLabel = [UILabel new];
    usernameLabel.text = [[_dictionary myObjectForKey:@"data"]objectForKey:@"name"];
    [paramsDictionary setObject:usernameLabel.text forKey:@"name"];
    [paramsDictionary setObject:textView.text forKey:@"about"];
    
    NSString *url = [NSString stringWithFormat:@"%@doctor/edit_profile", BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    manager.requestSerializer.timeoutInterval = 45;
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [GetUsernamePassword getAccessToken]] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    NSData *imageData = UIImagePNGRepresentation(profileImageView.image);

    [manager POST:url parameters:paramsDictionary constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if (chosenImage) {
            [formData appendPartWithFileData:imageData
                                        name:@"avatar"
                                    fileName:@"avatar" mimeType:@"image/jpeg"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *resDic  =responseObject;
        if ([[resDic myObjectForKey:@"success"]integerValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@", [resDic myObjectForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                // ////NSLog(@"You pressed button OK");
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
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
