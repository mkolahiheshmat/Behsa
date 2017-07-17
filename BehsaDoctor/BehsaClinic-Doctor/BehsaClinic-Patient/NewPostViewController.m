//
//  NewPostViewController.m
//  MSN
//
//  Created by Yarima on 11/16/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()<UITextFieldDelegate, UITextViewDelegate, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
    UITextField *titleTextField;
    UITextView *contentTextView;
    UIScrollView *scrollView;
    UIView *documentView;
    UIImageView *attachImageView;
    UILabel *fileNameLabel;
    UIButton *deleteButtonForAttach;
    UIView *documentView2;
    UIImageView *attachImageView2;
    UILabel *fileNameLabel2;
    UIButton *deleteButtonForAttach2;
    NSInteger countOfImages;
    UIButton *attchImageButton;
    UIButton *saveChangesButton;
    UIButton *sendButton;
}


@end

@implementation NewPostViewController

- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitleLabel:@"ایجاد پست"];
    
    //save button
    saveChangesButton= [CustomButton initButtonWithTitle:@"ارسال پست" withTitleColor:[UIColor grayColor] withBackColor:BUTTON_COLOR
                                               withFrame:CGRectMake(screenWidth - 90, 25, 80, 30)];
    saveChangesButton.userInteractionEnabled = NO;
    saveChangesButton.alpha = 0.0;
    //saveChangesButton.hidden = YES;
    [saveChangesButton addTarget:self action:@selector(sendToServer) forControlEvents:UIControlEventTouchUpInside];
    [self addOnTopView:saveChangesButton];
    
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
    //[self scrollviewMaker];
    [self makeBody];
    
    countOfImages = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marks - custom methods
- (void)backButtonImgAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)scrollviewMaker{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 2);
}
- (void)makeBody{
    
    //title
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 210, 70, 200, 40)];
    titleLabel.font = FONT_NORMAL(16);
    titleLabel.text = @"عنوان پست";
    titleLabel.textColor = MAIN_COLOR;
    titleLabel.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:titleLabel];
    
    titleTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, titleLabel.frame.origin.y + titleLabel.frame.size.height, screenWidth - 20, 45)];
    titleTextField.backgroundColor = [UIColor clearColor];
    titleTextField.placeholder = @"  عنوان پست را وارد کنید...";
    titleTextField.tag = 101;
    titleTextField.delegate = self;
    titleTextField.font = FONT_NORMAL(15);
    titleTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    titleTextField.layer.borderWidth = 1.0;
    titleTextField.layer.cornerRadius = 5;
    titleTextField.clipsToBounds = YES;
    [titleTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    titleTextField.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:titleTextField];
    
    UILabel *titleLabel2 =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 220, titleLabel.frame.origin.y + 100, 200, 40)];
    titleLabel2.font = FONT_NORMAL(16);
    titleLabel2.text = @"متن";
    titleLabel2.textColor = MAIN_COLOR;
    titleLabel2.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:titleLabel2];
    
    contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, titleLabel2.frame.origin.y + titleLabel2.frame.size.height, screenWidth - 20, 120) textContainer:nil];
    contentTextView.font = FONT_NORMAL(12);
    contentTextView.delegate = self;
    contentTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    contentTextView.layer.borderWidth = 1.0;
    contentTextView.layer.cornerRadius = 10;
    contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    contentTextView.textAlignment = NSTextAlignmentRight;
    [self.view addSubview:contentTextView];
    
    attchImageButton = [CustomButton initButtonWithTitle:@"آپلود عکس" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES withFrame:CGRectMake(screenWidth/2 - 60, contentTextView.frame.origin.y + contentTextView.frame.size.height + 20, 120, 30)];
    [attchImageButton addTarget:self action:@selector(showgalleryCameraMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:attchImageButton];
    
    sendButton = [CustomButton initButtonWithTitle:NSLocalizedString(@"ارسال", @"") withTitleColor:[UIColor whiteColor] withBackColor:[UIColor colorWithRed:82/255.0 green:153/255.0 blue:223/255.0 alpha:1.0] isRounded:NO withFrame:CGRectMake(0, screenHeight, screenWidth, 35)];
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    //[self.view addSubview:sendButton];
}

- (void)sendButtonAction{
    [self sendToServer];
}

- (void)dismissTextField{
    [titleTextField resignFirstResponder];
    [contentTextView resignFirstResponder];
}

- (void)makePreviewForSelectedImage:(CGFloat)ypos{
    documentView = [[UIView alloc]initWithFrame:CGRectMake(10, ypos, screenWidth - 20, 50)];
    documentView.userInteractionEnabled = YES;
    documentView.backgroundColor = [UIColor grayColor];
    documentView.layer.cornerRadius = 5.0;
    documentView.clipsToBounds = YES;
    //documentView.hidden = YES;
    [self.view addSubview:documentView];
    
    attachImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 80, 5, 40, 40)];
    attachImageView.layer.cornerRadius = 5.0;
    attachImageView.clipsToBounds = YES;
    [documentView addSubview:attachImageView];
    
    fileNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, screenWidth - 160, 45)];
    fileNameLabel.font = FONT_NORMAL(15);
    fileNameLabel.text = @"عکس اول";
    fileNameLabel.minimumScaleFactor = 0.7;
    fileNameLabel.textColor = [UIColor blackColor];
    fileNameLabel.textAlignment = NSTextAlignmentLeft;
    fileNameLabel.adjustsFontSizeToFitWidth = YES;
    [documentView addSubview:fileNameLabel];
    
    deleteButtonForAttach = [CustomButton initButtonWithImage:[UIImage imageNamed:@"close"] withFrame:CGRectMake(10, 15, 20, 20)];
    [deleteButtonForAttach addTarget:self action:@selector(deleteButtonForAttachAction) forControlEvents:UIControlEventTouchUpInside];
    [documentView addSubview:deleteButtonForAttach];
    
}

- (void)makePreviewForSelectedImage2:(CGFloat)ypos{
    
    documentView2 = [[UIView alloc]initWithFrame:CGRectMake(10, ypos, screenWidth - 20, 50)];
    documentView2.userInteractionEnabled = YES;
    documentView2.backgroundColor = [UIColor grayColor];
    documentView2.layer.cornerRadius = 5.0;
    documentView2.clipsToBounds = YES;
    [self.view addSubview:documentView2];
    
    attachImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 80, 5, 40, 40)];
    attachImageView2.layer.cornerRadius = 5.0;
    attachImageView2.clipsToBounds = YES;
    [documentView2 addSubview:attachImageView2];
    
    fileNameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 0, screenWidth - 160, 45)];
    fileNameLabel2.font = FONT_NORMAL(15);
    fileNameLabel2.text = @"عکس دوم";
    fileNameLabel2.minimumScaleFactor = 0.7;
    fileNameLabel2.textColor = [UIColor blackColor];
    fileNameLabel2.textAlignment = NSTextAlignmentLeft;
    fileNameLabel2.adjustsFontSizeToFitWidth = YES;
    [documentView2 addSubview:fileNameLabel2];
    
    deleteButtonForAttach2 = [CustomButton initButtonWithImage:[UIImage imageNamed:@"close"] withFrame:CGRectMake(10, 15, 20, 20)];
    [deleteButtonForAttach2 addTarget:self action:@selector(deleteButtonForAttachAction2) forControlEvents:UIControlEventTouchUpInside];
    [documentView2 addSubview:deleteButtonForAttach2];
    
}

- (void)deleteButtonForAttachAction{
    [self enableAttachButton];
    [documentView removeFromSuperview];
    documentView = nil;
    attachImageView.image = nil;
    countOfImages --;
    
    if (documentView2) {
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = documentView2.frame;
            frame.origin.y = frame.origin.y - 60;
            [documentView2 setFrame:frame];
        }];
    }
}
- (void)deleteButtonForAttachAction2{
    [self enableAttachButton];
    [documentView2 removeFromSuperview];
    documentView2 = nil;
    attachImageView2.image = nil;
    countOfImages --;
}

- (void)disableAttachButton{
    [attchImageButton setBackgroundColor:[UIColor grayColor]];
    attchImageButton.userInteractionEnabled = NO;
    [[AZJAlertView sharedInstance]showMessage:@"بیش از دو عکس نمی توانید آپلود کنید" withType:AZJAlertMessageTypeError];
}

- (void)enableAttachButton{
    [attchImageButton setBackgroundColor:MAIN_COLOR];
    attchImageButton.userInteractionEnabled = YES;
}

- (void)enableSaveButton{
    [saveChangesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveChangesButton.userInteractionEnabled = YES;
    //saveChangesButton.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        saveChangesButton.alpha = 100.0;
    }];
}

- (void)disableSaveButton{
    [saveChangesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveChangesButton.userInteractionEnabled = NO;
    //saveChangesButton.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        saveChangesButton.alpha = 0.0;
    }];
}

#pragma mark - textfield delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [contentTextView becomeFirstResponder];
    return NO;
}

-(void)textFieldDidChange :(UITextField *)textField{
    if ([textField.text length] > 3 && [contentTextView.text length] > 3) {
        [self enableSaveButton];
    }else{
        [self disableSaveButton];
    }
    
}

#pragma mark - text view delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([titleTextField.text length] > 3 && [textView.text length] > 3) {
        [self enableSaveButton];
    }else{
        [self disableSaveButton];
    }
    return YES;
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
    countOfImages++;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    if (countOfImages == 1) {
        [self makePreviewForSelectedImage:attchImageButton.frame.origin.y + 50];
        attachImageView.image = chosenImage;
    }
    
    if (countOfImages == 2 && documentView2) {
        [self makePreviewForSelectedImage:attchImageButton.frame.origin.y + 50];
        attachImageView.image = chosenImage;
        [UIView animateWithDuration:0.5 animations:^{
            CGRect frame = documentView2.frame;
            frame.origin.y = frame.origin.y + 60;
            [documentView2 setFrame:frame];
        }];
    }else if (countOfImages == 2) {
        [self disableAttachButton];
        [self makePreviewForSelectedImage2:attchImageButton.frame.origin.y + 110];
        attachImageView2.image = chosenImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    //upload new image to server
    //[self sendPhotoToServer];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
}
#pragma mark - connection

- (void)sendToServer{
    if ([titleTextField.text length]  < 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@" فیلد عنوان را پر کنید" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            // ////NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if ([contentTextView.text length]  < 3) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@" فیلد محتوا را پر کنید" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            // ////NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [ProgressHUD show:@"در حال ارسال..."];
    NSDictionary *params = @{@"title":titleTextField.text,
                             @"text":contentTextView.text
                             };
    NSData *coverData = UIImagePNGRepresentation(attachImageView.image);
    NSData *imageData = UIImagePNGRepresentation(attachImageView2.image);
    NSString *url = [NSString stringWithFormat:@"%@post/add", BaseURL];
    AFHTTPSessionManager *manager = [NetworkManager shareManager2];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (coverData) {
            [formData appendPartWithFileData:coverData
                                        name:@"cover"
                                    fileName:@"cover" mimeType:@"image/jpeg"];
        }
        
        if (imageData) {
            [formData appendPartWithFileData:imageData
                                        name:@"image"
                                    fileName:@"image" mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [saveChangesButton setTitle:[NSString stringWithFormat:@"%2.0f %%", uploadProgress.fractionCompleted * 100] forState:UIControlStateNormal];
            
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *resDic  =responseObject;
        if ([[resDic objectForKey:@"success"]integerValue] == 1) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@", [resDic objectForKey:@"message"]] preferredStyle:UIAlertControllerStyleAlert];
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
