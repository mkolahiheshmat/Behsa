    //
    //  AllSessionsViewController.m
    //  BehsaClinic-Patient
    //
    //  Created by Yarima on 3/4/17.
    //  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
    //

#import "ErjaViewController.h"

@interface ErjaViewController ()<UITextFieldDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate>
{
    UITextField *searchTextField;
    UIScrollView *scrollView;
    
    UIView *borderView;
    UITextView* _textView;
    UIImageView *attachImageView;
    UIView *documentView;
    UILabel *fileNameLabel;
    UIButton *deleteButtonForAttach;
    UIButton *attachButton;
    UIImage *chosenImage;
    UIButton *recorderButton;
    UIButton *saveChangesButton;
    
    UIView *recordingView;
    UIView *replyViewBG;
    UILabel *recordingTimerLabel;
    NSString *recordingVoiceNameStr;
    NSTimer *playbackTimer;
    UIProgressView *playbackProgress;
    UIProgressView *playSoundeProgress;
    BOOL isPlayingTempVoice;
    UIView *playRecordedSoundView;
    NSString *documentsDirectory;
    NSArray *healthRecordsItems;
    UIView *bgViewForHealthRecords;
    CGFloat cellHeight;
    UIView *gridView;
    NSMutableArray *listOfFrames;
    UIImageView *tikImgeview;
}
@property(nonatomic, retain)NSMutableArray *tableArray;
@property(nonatomic, retain)NSMutableArray *tableArrayCopy;
@property (strong, nonatomic)AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) NSTimer *myTimer;
@property int currentTimeInSeconds;
@property NSInteger doctorID;
@end

@implementation ErjaViewController

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
    [self setTitleLabel:@"ارجاع به درمانگر"];
    
    cellHeight = 100;
    
        //save button
    saveChangesButton= [CustomButton initButtonWithTitle:@"ثبت ارجاع" withTitleColor:[UIColor grayColor] withBackColor:BUTTON_COLOR
                                               withFrame:CGRectMake(screenWidth - 90, 25, 80, 30)];
    saveChangesButton.titleLabel.minimumScaleFactor = 0.5;
    saveChangesButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    saveChangesButton.userInteractionEnabled = NO;
    saveChangesButton.alpha = 0.0;
        //saveChangesButton.hidden = YES;
    [saveChangesButton addTarget:self action:@selector(sendToServer) forControlEvents:UIControlEventTouchUpInside];
    [self addOnTopView:saveChangesButton];
    
        //back button
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 16 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
    
    self.tableArray = [[NSMutableArray alloc]init];
    [self getDoctors];
    [self scrollviewMaker];
    [self topSection];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}
#pragma mark - custom methods
- (void)backButtonImgAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)topSection{
        // name
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 74, screenWidth - 40, 35)];
    titleLabel.font = FONT_NORMAL(17);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"به کدام درمانگر ارجاع می دهید؟";
    [self.view addSubview:titleLabel];
    
    UIView *searchBorderView = [[UIView alloc]initWithFrame:
                                CGRectMake(20, 115, screenWidth - 40, 25)];
    searchBorderView.backgroundColor = [UIColor clearColor];
    searchBorderView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchBorderView.layer.borderWidth = 1.0;
    searchBorderView.layer.cornerRadius = 10;
    searchBorderView.clipsToBounds = YES;
    [self.view addSubview:searchBorderView];
    
    searchTextField = [[UITextField alloc]initWithFrame:
                       CGRectMake(50, 1, searchBorderView.frame.size.width - 50, 23)];
    searchTextField.backgroundColor = [UIColor whiteColor];
    searchTextField.placeholder = @"                 جستجو مراجعه کننده";
    searchTextField.tag = 103;
    searchTextField.delegate = self;
    searchTextField.font = FONT_NORMAL(12);
    searchTextField.layer.borderColor = [UIColor clearColor].CGColor;
    searchTextField.layer.borderWidth = 1.0;
    searchTextField.layer.cornerRadius = 10;
    searchTextField.clipsToBounds = YES;
    searchTextField.minimumFontSize = 0.5;
    searchTextField.adjustsFontSizeToFitWidth = YES;
    searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    searchTextField.textAlignment = NSTextAlignmentCenter;
    searchTextField.userInteractionEnabled = YES;
    [searchTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [searchTextField addToolbar];
    [searchBorderView addSubview:searchTextField];
}

- (void)scrollviewMaker{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 140, screenWidth, screenHeight - 140)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 2);
}

- (void)makeGridView:(NSArray *)elements{
    CGFloat heightOfEachRow = 150;
    [gridView removeFromSuperview];
    NSInteger counter = [elements count] / 2;
    counter++;
    gridView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, heightOfEachRow * counter)];
    gridView.backgroundColor = [UIColor whiteColor];
        //[self updateGridViewSize];
    [scrollView addSubview:gridView];
    listOfFrames = [[NSMutableArray alloc]init];
    CGFloat yPos = 0;
    for (NSInteger i = 0; i < [self.tableArray count]; i++) {
        ErjaEntity *entity = [self.tableArray  myObjectAtIndex:i];
        CGFloat widthOfEachElement = screenWidth / 2;
            //doctor avatar and name
        CGFloat xPos = (i % 2) * widthOfEachElement;
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(xPos, yPos, widthOfEachElement, cellHeight)];
        [gridView addSubview:bgView];
        
        NSString *nameStr = entity.nameString;
        NSString *expertiseStr = entity.expertiseString;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@", entity.avatarString]];
        UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(bgView.frame.size.width / 2 - 25, 15, 50, 50)];
        [listOfFrames addObject:avatarImageView];
        avatarImageView.tag = i;//entity.idx;
        avatarImageView.userInteractionEnabled = YES;
            //call online_booking/check_doctor after user tap to get visit time
            // on success go to visit time view
            //on false go to visit time view for Arzyab
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarImageViewAction:)];
        [avatarImageView addGestureRecognizer:tap];
        avatarImageView.layer.cornerRadius = 25;
        [avatarImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"dontprofile"]];
        avatarImageView.clipsToBounds = YES;
        [bgView addSubview:avatarImageView];
        
        tikImgeview = [[UIImageView alloc]initWithFrame:CGRectMake(avatarImageView.frame.origin.x + avatarImageView.frame.size.width, 15, 15, 15)];
        tikImgeview.image = [UIImage imageNamed:@"tik"];
        tikImgeview.tag = i;
        tikImgeview.hidden = YES;
        [bgView addSubview:tikImgeview];
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 70, bgView.frame.size.width, 25)];
        nameLabel.font = FONT_NORMAL(13);
        nameLabel.adjustsFontSizeToFitWidth = YES;
        nameLabel.minimumScaleFactor = 0.5;
        nameLabel.text = nameStr;
        nameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapy = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avatarImageViewAction:)];
        nameLabel.tag = i;//entity.idx;
        [nameLabel addGestureRecognizer:tapy];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:nameLabel];
        
        UILabel *jobLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 100, bgView.frame.size.width, 25)];
        jobLabel.font = FONT_NORMAL(13);
        jobLabel.adjustsFontSizeToFitWidth = YES;
        jobLabel.minimumScaleFactor = 0.5;
        jobLabel.text = expertiseStr;
        jobLabel.textColor = [UIColor grayColor];
        jobLabel.textAlignment = NSTextAlignmentCenter;
        [bgView addSubview:jobLabel];
        
            //yPosOfJobTitle += heightOfEachRow;
        if (i % 2 == 1) {
            yPos += heightOfEachRow;
        }
    }
    scrollView.contentSize = CGSizeMake(screenWidth, heightOfEachRow * counter);
    
    [self makeNeveshtaneSharhehalView];
}

- (void)avatarImageViewAction:(UITapGestureRecognizer *)tap{
    
    ErjaEntity *entity = [self.tableArray  myObjectAtIndex:tap.view.tag];
    _doctorID = entity.idx;
    NSLog(@"%ld", (long)_doctorID);
    
    [self clearAllTiks];
    
    for (UIView *aview in gridView.subviews) {
        if ([aview isKindOfClass:[UIView class]]) {
            UIView *bgviwe = (UIView *)aview;
            for (UIView *bgview2 in bgviwe.subviews)
                if ([bgview2 isKindOfClass:[UIImageView class]]) {
                    UIImageView *tik = (UIImageView *)bgview2;
                    if ([tik.image isEqual:[UIImage imageNamed:@"tik"]] &&
                        tik.tag == tap.view.tag) {
                        tik.hidden = NO;
                    }
                }
        }
    }
    
    [self enableSaveButton];
}

- (void)clearAllTiks{
    for (UIView *aview in gridView.subviews) {
        if ([aview isKindOfClass:[UIView class]]) {
            UIView *bgviwe = (UIView *)aview;
            for (UIView *bgview2 in bgviwe.subviews)
                if ([bgview2 isKindOfClass:[UIImageView class]]) {
                    UIImageView *tik = (UIImageView *)bgview2;
                    if ([tik.image isEqual:[UIImage imageNamed:@"tik"]]) {
                        tik.hidden = YES;
                    }
                }
        }
    }

}
- (void)updateGridViewSize{
    CGFloat height = cellHeight;
    height *= self.tableArray.count;
    
    CGRect tableFrame = gridView.frame;
    tableFrame.size.height = height;
    gridView.frame = tableFrame;
}

- (void)disableAttachButton{
    [attachButton setHidden:YES];
    attachButton.userInteractionEnabled = NO;
}

- (void)enableAttachButton{
    [attachButton setHidden:NO];
    attachButton.userInteractionEnabled = YES;
}

- (void)disableVoiceButton{
    [recorderButton setHidden:YES];
    recorderButton.userInteractionEnabled = NO;
}

- (void)enableVoiceButton{
    [recorderButton setHidden:NO];
    recorderButton.userInteractionEnabled = YES;
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

- (void)makeNeveshtaneSharhehalView{
    
    borderView = [[UIView alloc]initWithFrame:CGRectMake(10, gridView.frame.origin.y + gridView.frame.size.height, screenWidth - 20, 120)];
    borderView.layer.borderColor = MAIN_COLOR.CGColor;
    borderView.layer.borderWidth = 1.0;
    borderView.layer.cornerRadius = 8.0;
    borderView.clipsToBounds = YES;
    [scrollView addSubview:borderView];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 2, borderView.frame.size.width, 95)];
    _textView.font = FONT_NORMAL(12);
    _textView.tag = 534;
    _textView.autocorrectionType = UITextAutocorrectionTypeNo;
    _textView.delegate = self;
    _textView.layer.borderColor = [UIColor clearColor].CGColor;
    _textView.layer.borderWidth = 1.0;
    _textView.layer.cornerRadius = 8.0;
    _textView.clipsToBounds = YES;
    _textView.textColor = MAIN_COLOR;
    _textView.contentSize = CGSizeMake(screenWidth, 1000);
    [_textView setScrollEnabled:YES];
    _textView.text = @"دلیل ارجاع را بنویسید...";
    _textView.textAlignment = NSTextAlignmentRight;
    [_textView addToolbar];
    [borderView addSubview:_textView];
    
        //30 × 54
    recorderButton = [[UIButton alloc]initWithFrame:CGRectMake(20, borderView.frame.size.height - 30, 64 * 0.4, 64 * 0.4)];
    [recorderButton setBackgroundImage:[UIImage imageNamed:@"voice icon"] forState:UIControlStateNormal];
    [recorderButton addTarget:self action:@selector(recorderButtonAction) forControlEvents:UIControlEventTouchDown];
    [recorderButton addTarget:self action:@selector(recorderButtonStopAction) forControlEvents:UIControlEventTouchUpInside];
    [recorderButton addTarget:self action:@selector(dragOutside:withEvents:) forControlEvents:UIControlEventTouchDragOutside];
    [borderView addSubview:recorderButton];
    
        //43 × 47
    attachButton = [[UIButton alloc]initWithFrame:CGRectMake(60, borderView.frame.size.height - 23, 43 * 0.4, 47 * 0.4)];
    [attachButton setBackgroundImage:[UIImage imageNamed:@"attach file"] forState:UIControlStateNormal];
    [attachButton addTarget:self action:@selector(attachButtonAction) forControlEvents:UIControlEventTouchDown];
    [borderView addSubview:attachButton];
    
    scrollView.contentSize = CGSizeMake(screenWidth, borderView.frame.origin.y + borderView.frame.size.height + 10);
}

#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 534) {
        if ([textView.text isEqualToString:@"دلیل ارجاع را بنویسید..."]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
        
//        if ([textView.text length] > 5) {
//            [self enableSaveButton];
//        } else {
//            [self disableSaveButton];
//        }
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 534) {
        if ([textView.text isEqualToString:@"دلیل ارجاع را بنویسید..."]) {
            textView.text = @"";
        }
    }
    
    scrollView.contentSize = CGSizeMake(screenWidth, borderView.frame.origin.y + borderView.frame.size.height + 300);
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
    [scrollView setContentOffset:bottomOffset animated:YES];
}

#pragma mark - text field delegate

-(void)textFieldDidChange :(UITextField *)textField{
    self.tableArray = [[NSMutableArray alloc]initWithArray:self.tableArrayCopy];
    if ([textField.text length] == 0) {
        [self makeGridView:self.tableArray];
        return;
    }
    
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    for (NSInteger i = 0; i < [self.tableArray count]; i++) {
        ErjaEntity *entity = [self.tableArray  myObjectAtIndex:i];
        if ([entity.nameString containsString:textField.text]) {
            [tempArray addObject:entity];
        }
    }
    self.tableArray = [[NSMutableArray alloc]initWithArray:tempArray];
    [self makeGridView:self.tableArray];
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
    [self disableAttachButton];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self makePreviewForSelectedImage];
    scrollView.contentSize = CGSizeMake(screenWidth, borderView.frame.origin.y + borderView.frame.size.height + 300);
    CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
    [scrollView setContentOffset:bottomOffset animated:YES];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
}

- (void)makePreviewForSelectedImage{
    if (playRecordedSoundView) {
        documentView = [[UIView alloc]initWithFrame:CGRectMake(10, playRecordedSoundView.frame.origin.y + playRecordedSoundView.frame.size.height + 1, screenWidth - 20, 50)];
    }else{
        documentView = [[UIView alloc]initWithFrame:CGRectMake(10, borderView.frame.origin.y + borderView.frame.size.height + 10, screenWidth - 20, 50)];
    }
    documentView.userInteractionEnabled = YES;
    documentView.backgroundColor = [UIColor clearColor];
    documentView.layer.cornerRadius = 5.0;
    documentView.clipsToBounds = YES;
        //documentView.hidden = YES;
    [scrollView addSubview:documentView];
    
    deleteButtonForAttach = [CustomButton initButtonWithImage:[UIImage imageNamed:@"delete"] withFrame:CGRectMake(10, 24, 140 * 0.1, 140 * 0.1)];
    [deleteButtonForAttach addTarget:self action:@selector(deleteButtonForAttachAction) forControlEvents:UIControlEventTouchUpInside];
    [documentView addSubview:deleteButtonForAttach];
    
    UIView *greenBGView = [[UIView alloc]initWithFrame:CGRectMake(deleteButtonForAttach.frame.origin.x + deleteButtonForAttach.frame.size.width + 5, 10, documentView.frame.size.width - (deleteButtonForAttach.frame.origin.x + deleteButtonForAttach.frame.size.width + 5), 40)];
    greenBGView.backgroundColor = PREVIEW_COLOR;
    greenBGView.layer.cornerRadius = 20;
    greenBGView.clipsToBounds = YES;
    [documentView addSubview:greenBGView];
    
    attachImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - 90, 5, 30, 30)];
    attachImageView.layer.cornerRadius = 5.0;
    attachImageView.image = chosenImage;
    attachImageView.clipsToBounds = YES;
    [greenBGView addSubview:attachImageView];
    
    fileNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, screenWidth - 160, 25)];
        //fileNameLabel.font = FONT_NORMAL(15);
    fileNameLabel.text = @"27484973918.jpeg";
    fileNameLabel.minimumScaleFactor = 0.7;
    fileNameLabel.textColor = [UIColor blackColor];
    fileNameLabel.textAlignment = NSTextAlignmentLeft;
    fileNameLabel.adjustsFontSizeToFitWidth = YES;
    [greenBGView addSubview:fileNameLabel];
    
    CGRect frame = bgViewForHealthRecords.frame;
    frame.origin.y += 50;
    [bgViewForHealthRecords setFrame:frame];
    
    scrollView.contentSize = CGSizeMake(screenWidth, bgViewForHealthRecords.frame.origin.y + bgViewForHealthRecords.frame.size.height + 50);
}

- (void)deleteButtonForAttachAction{
    [self enableAttachButton];
    [documentView removeFromSuperview];
    documentView = nil;
    attachImageView.image = nil;
    chosenImage = nil;
    
    if (playRecordedSoundView) {
        if (playRecordedSoundView.frame.origin.y - 60 > borderView.frame.origin.y + borderView.frame.size.height) {
            [UIView animateWithDuration:0.4 animations:^{
                CGRect frame = playRecordedSoundView.frame;
                frame.origin.y -= 60;
                [playRecordedSoundView setFrame:frame];
            }];
        }
    }
    
    CGRect frame = bgViewForHealthRecords.frame;
    frame.origin.y -= 50;
    [bgViewForHealthRecords setFrame:frame];
    
    scrollView.contentSize = CGSizeMake(screenWidth, bgViewForHealthRecords.frame.origin.y + bgViewForHealthRecords.frame.size.height - 50);
}

- (void)attachButtonAction{
    [self dismissTextField];
    NSLog(@"attach");
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
#pragma mark - play, delete, record audio
- (void)recorderButtonAction{
    [self dismissTextField];
    NSLog(@"Start recording...");
    [self.audioPlayer stop];
    [self startTimer];
    CGFloat xPosOfrecordingView = recorderButton.frame.origin.x + (67 * 0.3);
    recordingView = [[UIView alloc]initWithFrame:CGRectMake(20, borderView.frame.size.height -44, screenWidth - xPosOfrecordingView, 60)];
    recordingView.backgroundColor = [UIColor clearColor];
    [borderView addSubview:recordingView];
    
    recordingTimerLabel = [[UILabel alloc]initWithFrame:CGRectMake(recordingView.frame.size.width - 80, 20, 50, 20)];
    recordingTimerLabel.text = @"03:00";
    recordingTimerLabel.textColor = [UIColor blackColor];
    recordingTimerLabel.backgroundColor = [UIColor whiteColor];
    recordingTimerLabel.textAlignment = NSTextAlignmentRight;
    [recordingView addSubview:recordingTimerLabel];
    UILabel *slideLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 200, 20)];
    slideLabel.text = @"swipe right to cancel > > >";
    slideLabel.font = [UIFont systemFontOfSize:11];
    slideLabel.textColor = [UIColor redColor];
    slideLabel.textAlignment = NSTextAlignmentRight;
    slideLabel.backgroundColor = [UIColor whiteColor];
    [recordingView addSubview:slideLabel];
    
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(
                                                   NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
        //NSLog(@"%@", currentDate);
    NSString *soundFilePath = [docsDir
                               stringByAppendingPathComponent:@"tempVoice.caf"];
    
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    NSDictionary *recordSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatAppleIMA4], AVFormatIDKey,
                                    [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
                                    [NSNumber numberWithInt:16], AVEncoderBitRateKey,
                                    [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithFloat:8000.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:8], AVLinearPCMBitDepthKey,
                                    nil];
    NSError *error = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                        error:nil];
    [audioSession setActive:YES error:nil];
    
    _audioRecorder = [[AVAudioRecorder alloc]
                      initWithURL:soundFileURL
                      settings:recordSettings
                      error:&error];
    
    if (error)
        {
            //NSLog(@"error: %@", [error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Error" message:[error localizedDescription] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
        [alert show];
        } else {
#if !(TARGET_IPHONE_SIMULATOR)
                //NSLog(@"Running on device");
            [_audioRecorder prepareToRecord];
            [_audioRecorder record];
            recordingVoiceNameStr = soundFilePath;
#endif
            
        }
    
}

-(void)dragOutside:(UIButton *) sender withEvents:(UIEvent *) event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint relativeLocToInitialCell = [touch locationInView:sender];
        //NSLog(@"%f--%f", relativeLocToInitialCell.x, relativeLocToInitialCell.y);
    
    if (relativeLocToInitialCell.x > screenWidth/4) {
            //NSLog(@"swipe right");
        [self stopTimer];
        [UIView animateWithDuration:1.0 animations:^{
            CGRect rect = recordingView.frame;
            rect.origin.x = relativeLocToInitialCell.x+40.0;
            [recordingView setFrame:rect];
        } completion:^(BOOL finished) {
            [recordingView removeFromSuperview];
            [_audioRecorder stop];
            [self deleteFileAtPath:[NSString stringWithFormat:@"%@",recordingVoiceNameStr]];
            [self loadAudioFiles];
        }];
    }
    
    
}
- (void)recorderButtonStopAction{
    [self disableVoiceButton];
    isPlayingTempVoice = YES;
        //NSLog(@"Stop recording");
    [self stopTimer];
    [recordingView removeFromSuperview];
    [_audioRecorder stop];
    
    [playRecordedSoundView removeFromSuperview];
    if (documentView) {
        playRecordedSoundView = [[UIView alloc]initWithFrame:CGRectMake(10, documentView.frame.origin.y + documentView.frame.size.height, screenWidth - 20, 60)];
    } else {
        playRecordedSoundView = [[UIView alloc]initWithFrame:CGRectMake(10, borderView.frame.origin.y + borderView.frame.size.height + 5, screenWidth - 20, 60)];
    }
    
    playRecordedSoundView.backgroundColor = [UIColor clearColor];
    playRecordedSoundView.layer.cornerRadius = 5.0;
    playRecordedSoundView.clipsToBounds = YES;
    [scrollView addSubview:playRecordedSoundView];
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 24, 140 * 0.1, 140 * 0.1)];
    [deleteButton setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteAudio) forControlEvents:UIControlEventTouchUpInside];
    [playRecordedSoundView addSubview:deleteButton];
    
    UIView *greenBGView = [[UIView alloc]initWithFrame:CGRectMake(deleteButton.frame.origin.x + deleteButton.frame.size.width + 5, 10, playRecordedSoundView.frame.size.width - (deleteButton.frame.origin.x + deleteButton.frame.size.width + 5), 40)];
    greenBGView.backgroundColor = PREVIEW_COLOR;
    greenBGView.layer.cornerRadius = 20;
    greenBGView.clipsToBounds = YES;
    [playRecordedSoundView addSubview:greenBGView];
    
    UIButton *playSoundButton = [[UIButton alloc]initWithFrame:CGRectMake(5, 3, 170 * 0.2, 170 * 0.2)];
    [playSoundButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    [playSoundButton addTarget:self action:@selector(playAudio) forControlEvents:UIControlEventTouchUpInside];
    [greenBGView addSubview:playSoundButton];
    
    CGFloat ratio = 1155 / greenBGView.frame.size.width;
    ratio /= 20;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(playSoundButton.frame.size.width + 15, 7, 1155 * ratio, 102 * ratio)];
    imageView.image = [UIImage imageNamed:@"wave"];
    [greenBGView addSubview:imageView];
    
    CGRect frame = bgViewForHealthRecords.frame;
    frame.origin.y += 60;
    [bgViewForHealthRecords setFrame:frame];
    
    scrollView.contentSize = CGSizeMake(screenWidth, bgViewForHealthRecords.frame.origin.y + bgViewForHealthRecords.frame.size.height + 60);
}

- (void)playAudio{
    isPlayingTempVoice = YES;
    [self playAudioWithName:recordingVoiceNameStr];
}

- (void)deleteAudio{
    if (documentView) {
        if (documentView.frame.origin.y - 60 > borderView.frame.origin.y + borderView.frame.size.height) {
            [UIView animateWithDuration:0.4 animations:^{
                CGRect frame = documentView.frame;
                frame.origin.y -= 60;
                [documentView setFrame:frame];
            }];
        }
    }
    [_audioPlayer stop];
    [playRecordedSoundView removeFromSuperview];
    playRecordedSoundView = nil;
    [self deleteFileAtPath:[NSString stringWithFormat:@"%@",recordingVoiceNameStr]];
    
    [self enableVoiceButton];
    
    CGRect frame = bgViewForHealthRecords.frame;
    frame.origin.y -= 50;
    [bgViewForHealthRecords setFrame:frame];
    
    scrollView.contentSize = CGSizeMake(screenWidth, bgViewForHealthRecords.frame.origin.y + bgViewForHealthRecords.frame.size.height - 50);
}

- (void)deleteFileAtPath:(NSString *)nameOfVoice{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:nameOfVoice error:&error];
    if (!success) {
        [playRecordedSoundView removeFromSuperview];
    }else{
        [playRecordedSoundView removeFromSuperview];
    }
}

- (void)playAudioWithName:(NSString *)nameOfVoice {
    
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:nameOfVoice]
                                                              error:nil];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    NSError *setCategoryError = nil;
        //improve voice for playback
    if (![session setCategory:AVAudioSessionCategoryPlayback
                  withOptions:AVAudioSessionCategoryOptionMixWithOthers
                        error:&setCategoryError]) {
            // handle error
    }
        //    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        //    AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
        //                             sizeof (audioRouteOverride),&audioRouteOverride);
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    if (error){
            //NSLog(@"Error: %@",[error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"error", @"") message:[NSString stringWithFormat:@"%@", [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
    }else{
        [self.audioPlayer play];
        playbackTimer=[NSTimer scheduledTimerWithTimeInterval:0.01
                                                       target:self
                                                     selector:@selector(playbackTimerAction:)
                                                     userInfo:nil
                                                      repeats:YES];
    }
}

-(void)playbackTimerAction:(NSTimer*)timer {
    
    float total = self.audioPlayer.duration;
    float f = self.audioPlayer.currentTime / total;
    
    if (isPlayingTempVoice) {
        playSoundeProgress.progress = f;
    } else {
        playbackProgress.progress = f;
    }
    
    if ((total * 0.95) <= self.audioPlayer.currentTime) {
        if (isPlayingTempVoice) {
            playSoundeProgress.progress = 0.0;
            
        } else {
            [playbackProgress removeFromSuperview];
        }
        
        [playbackTimer invalidate];
        [self stopTimer];
        isPlayingTempVoice = NO;
    }
    
        //NSLog(@"%f--%f", total, self.audioPlayer.currentTime);
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
        //NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        //[self.tableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)loadAudioFiles{
    documentsDirectory = [DocumentDirectoy getDocuementsDirectory];
        //NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsDirectory  error:nil];
        //    for (int i = 0; i < [filePathsArray count]; i++) {
        //        NSDictionary *tempDic = [[NSDictionary alloc]initWithObjectsAndKeys:
        //                                 [filePathsArray  myObjectAtIndex:i], @"answer", nil];
        //    }
}

- (void)playBeepSound{
    NSString *soundPath =[[NSBundle mainBundle] pathForResource:@"censor-beep-01" ofType:@"mp3"];
    NSURL *soundURL = [NSURL fileURLWithPath:soundPath];
    NSError *error = nil;
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL error:&error];
    self.audioPlayer.delegate = self;
    [self.audioPlayer prepareToPlay];
    if (error){
            //NSLog(@"Error: %@",[error localizedDescription]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"error", @"") message:[NSString stringWithFormat:@"%@", [error localizedDescription]] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"") otherButtonTitles:nil, nil];
        [alert show];
    }else
        [self.audioPlayer play];
}

#pragma mark - timer

- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)timerTicked:(NSTimer *)timer {
    
    _currentTimeInSeconds--;
    if (self.currentTimeInSeconds < 15) {
        [self playBeepSound];
        recordingTimerLabel.textColor = [UIColor redColor];
    }
    
    if (_currentTimeInSeconds == 0) {
        [self recorderButtonStopAction];
    }
    
    recordingTimerLabel.text = [self formattedTime:_currentTimeInSeconds];
    
}

- (NSString *)formattedTime:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}



- (void)startTimer {
    
    if (!_currentTimeInSeconds) {
        _currentTimeInSeconds = 3 * 60 ;
    }
    
    if (!_myTimer) {
        _myTimer = [self createTimer];
    }
}

- (void)stopTimer {
    recordingTimerLabel.text = @"03:00";
    _currentTimeInSeconds = 0;
    [_myTimer invalidate];
}

#pragma mark - connection
- (void)getDoctors{
    dispatch_async(dispatch_get_main_queue(), ^{
        [ProgressHUD show:@""];
    });
    
    self.tableArray = [[NSMutableArray alloc]init];
    [Networking formDataWithPath:@"profile/doctors" parameters:@{@"id":@"0"} success:^(NSDictionary * _Nonnull responseDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        
        if ([[responseDict myObjectForKey:@"success"]integerValue] == 1) {
            for (NSDictionary *dic in [[responseDict myObjectForKey:@"data"]objectForKey:@"items"]) {
                for (NSDictionary *dicDoc in [dic myObjectForKey:@"doctors"]) {
                    ErjaEntity *entity = [ErjaEntity new];
                    entity.nameString = [dicDoc myObjectForKey:@"name"];
                    entity.avatarString = [dicDoc myObjectForKey:@"avatar"];
                    entity.idx = [[dicDoc myObjectForKey:@"id"]integerValue];
                    entity.expertiseString = [[dic myObjectForKey:@"job_title"]objectForKey:@"name"];
                    [self.tableArray addObject:entity];
                }
            }
        }
        
        self.tableArrayCopy = [[NSMutableArray alloc]initWithArray:self.tableArray];
        [self makeGridView:self.tableArray];
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [ProgressHUD dismiss];
        });
        [self getDoctors];
    }];
}

- (void)sendToServer{

    if ([_textView.text length] < 5 || [_textView.text isEqualToString:@"دلیل ارجاع را بنویسید..."]) {
        [[AZJAlertView sharedInstance]showMessage:@"لطفا علت ارجاع را تکمیل نمایید." withType:AZJAlertMessageTypeError];
        scrollView.contentSize = CGSizeMake(screenWidth, borderView.frame.origin.y + borderView.frame.size.height + 300);
        CGPoint bottomOffset = CGPointMake(0, scrollView.contentSize.height - scrollView.bounds.size.height);
        [scrollView setContentOffset:bottomOffset animated:YES];
        [_textView becomeFirstResponder];
        return;
    }
        [ProgressHUD show:@""];
    NSData *voiceData = [NSData dataWithContentsOfFile:recordingVoiceNameStr];
    NSDictionary *params = @{
                             @"treatment_id":[NSNumber numberWithDouble:_treatmentID],
                             @"doctor_id":[NSNumber numberWithDouble:_doctorID],
                             @"title":@"",
                             @"description":_textView.text,
                             };
    [Networking uploadVoiceWithPath:@"online_booking/refer" parameters:params voice:voiceData success:^(NSDictionary * _Nonnull responseDict) {
        [[AZJAlertView sharedInstance]showMessage:[responseDict myObjectForKey:@"message"] withType:AZJAlertMessageTypeInfo];
        [self backButtonImgAction];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissTimesView" object:nil];
    } failure:^(NSError * _Nonnull error) {
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}
@end
