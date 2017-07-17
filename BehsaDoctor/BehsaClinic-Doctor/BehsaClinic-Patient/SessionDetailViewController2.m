//
//  SessionDetailViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/28/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "SessionDetailViewController2.h"
@interface SessionDetailViewController2 ()<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UIScrollViewDelegate>
{
    UIScrollView *scrollView;
    UILabel *sessionLabel;
    UILabel *dateLabel;
    UIView *horizontalLineViewPart1;
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
}
@property (strong, nonatomic)AVAudioRecorder *audioRecorder;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) NSTimer *myTimer;
@property int currentTimeInSeconds;
@end

@implementation SessionDetailViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitleLabel:@"اطلاعات جلسه"];
    
    //save button
    saveChangesButton= [CustomButton initButtonWithTitle:@"ارسال شرح حال" withTitleColor:[UIColor grayColor] withBackColor:BUTTON_COLOR
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
    
    [self scrollviewMaker];
    [self makePart1];
    [self getSessionDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - custom methods

- (void)backButtonImgAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissTextField{
    [_textView resignFirstResponder];
}
- (void)scrollviewMaker{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, screenWidth, screenHeight - 64)];
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight * 2);
    
    UIButton *finishThreatment = [CustomButton initButtonWithTitle:@"پایان دوره درمان" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:NO withFrame:CGRectMake(-5, screenHeight - 38 - 50, screenWidth + 10,40)];
    [finishThreatment addTarget:self action:@selector(finishThreatmentAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishThreatment];
}
- (void)makePart1{
    UIButton *allSessionsButton = [CustomButton initButtonWithTitle:@"مشاهده تمام جلسات" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES
                                                          withFrame:CGRectMake(20, 5, 130, 30)];
    [allSessionsButton addTarget:self action:@selector(allSessionsButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:allSessionsButton];
    
    UIButton *parvandeButton = [CustomButton initButtonWithTitle:@"پرونده بیمار" withTitleColor:[UIColor whiteColor] withBackColor:MAIN_COLOR isRounded:YES
                                                       withFrame:CGRectMake(170, 5, 100, 30)];
    [parvandeButton addTarget:self action:@selector(parvandeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:parvandeButton];
    
    horizontalLineViewPart1 = [[UIView alloc]initWithFrame:CGRectMake(20, parvandeButton.frame.origin.y + 40, screenWidth - 40, 1)];
    horizontalLineViewPart1.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:horizontalLineViewPart1];
}

- (void)allSessionsButtonAction{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AllSessionsViewController *view = (AllSessionsViewController *)[story instantiateViewControllerWithIdentifier:@"AllSessionsViewController"];
    view.treatmentID = _treatmentID;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)parvandeButtonAction{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PatientViewController *view = (PatientViewController *)[story instantiateViewControllerWithIdentifier:@"PatientViewController"];
    view.patientID = _patientID;
    [self.navigationController pushViewController:view animated:YES];
}

- (NSString *)convertToShamsi:(double)timeStamp{
    double timestampval = timeStamp;
    NSTimeInterval timestamp = (NSTimeInterval)timestampval;
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
    return [ConvertToPersianDate ConvertToPersianFromGregorianDate:startDate];
}
- (void)makePart2WithTitle:(NSString *)title
                 startTime:(NSString *)startTime
                 endTime:(NSString *)endTime
                 date:(double)date{
    sessionLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2, horizontalLineViewPart1.frame.origin.y + 5, screenWidth/2 - 10, 25)];
    sessionLabel.font = FONT_NORMAL(15);
    sessionLabel.text = title;
    sessionLabel.textColor = [UIColor grayColor];
    sessionLabel.adjustsFontSizeToFitWidth = YES;
    sessionLabel.minimumScaleFactor = 0.5;
    sessionLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:sessionLabel];
    
    dateLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, horizontalLineViewPart1.frame.origin.y + 5, screenWidth/2 - 10, 50)];
    dateLabel.font = FONT_NORMAL(15);
    NSString *dateString = [self convertToShamsi:date];
    dateLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ \n %@ %@",
                      NSLocalizedString(@"hour1", @""),
                      startTime,
                      NSLocalizedString(@"hour2", @""),
                      endTime,
                      NSLocalizedString(@"date1", @""), dateString];
    dateLabel.textColor = [UIColor grayColor];
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.minimumScaleFactor = 0.5;
    dateLabel.textAlignment = NSTextAlignmentLeft;
    dateLabel.numberOfLines = 0;
    [scrollView addSubview:dateLabel];
}

- (void)makeNeveshtaneSharhehalView{
    
    borderView = [[UIView alloc]initWithFrame:CGRectMake(10, dateLabel.frame.origin.y + dateLabel.frame.size.height + 5, screenWidth - 20, 120)];
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
    _textView.text = @"نوشتن شرح حال...";
    _textView.textAlignment = NSTextAlignmentRight;
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
}
- (void)makeHealthRecordsView:(NSArray *)items{
    CGFloat ypos2;
    if (!playRecordedSoundView && !documentView) {
        ypos2 = borderView.frame.origin.y + borderView.frame.size.height + 10;
    }else if (playRecordedSoundView || documentView){
        ypos2 = borderView.frame.origin.y + borderView.frame.size.height + 50;
    }else if (playRecordedSoundView && documentView){
        ypos2 = borderView.frame.origin.y + borderView.frame.size.height + 110;
    }
    
    bgViewForHealthRecords = [[UIView alloc]initWithFrame:CGRectMake(0, ypos2, screenWidth, screenHeight)];
    [scrollView addSubview:bgViewForHealthRecords];
    
    CGFloat ypos = 0;
    for (NSInteger i = 0; i < [items count]; i++) {
        NSString *description = [[items myObjectAtIndex:i] myObjectForKey:@"description"];
        NSString *attachment = [[items myObjectAtIndex:i] myObjectForKey:@"attachment"];
        NSString *voice = [[items myObjectAtIndex:i] myObjectForKey:@"voice"];
        NSString *dateStr = [[items myObjectAtIndex:i] myObjectForKey:@"updated_at"];
        
        UIView *blueView;
        if (i == 0) {
            blueView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, ypos)];
            blueView.backgroundColor = [UIColor colorWithRed:0.2 green:0.1 blue:1.0 alpha:1.0];
            [bgViewForHealthRecords addSubview:blueView];
        }

        //date
        UILabel *dateLabel_ = [[UILabel alloc]initWithFrame:CGRectMake(10, ypos, screenWidth - 20, 25)];
        dateLabel_.font = FONT_NORMAL(13);
        dateLabel_.textColor = [UIColor lightGrayColor];
        dateLabel_.text = [ConvertToPersianDate ConvertToPersianDate:dateStr];
        dateLabel_.numberOfLines = 1;
        dateLabel_.textAlignment = NSTextAlignmentLeft;
        [bgViewForHealthRecords addSubview:dateLabel_];
        
        //description text
        UILabel *descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, ypos, screenWidth - 20, [description getHeightOfString])];
        descriptionLabel.font = FONT_NORMAL(13);
        descriptionLabel.textColor = [UIColor blackColor];
        descriptionLabel.text = description;
        descriptionLabel.attributedText = [[NSAttributedString alloc] initWithString:description attributes:[AttributedTextClass makeAttributedTextWithLineSpacing:19.0]];
        descriptionLabel.numberOfLines = 0;
        descriptionLabel.textAlignment = NSTextAlignmentRight;
        [bgViewForHealthRecords addSubview:descriptionLabel];
        ypos = descriptionLabel.frame.origin.y + descriptionLabel.frame.size.height;
        
        if ([attachment length] > 10) {
            CGFloat ratio = 0.7;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, ypos + 10, screenWidth - 20, screenWidth / ratio)];
            imageView.userInteractionEnabled = YES;
            imageView.tag = i;
            UITapGestureRecognizer *imageViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
            [imageView addGestureRecognizer:imageViewTap];
            [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", attachment]] placeholderImage:[UIImage imageNamed:@"format_png"]];
            [bgViewForHealthRecords addSubview:imageView];
            ypos = imageView.frame.origin.y + imageView.frame.size.height + 10;
        }
        
        if ([voice length] > 10) {
            UIButton *playSoundButton = [[UIButton alloc]initWithFrame:CGRectMake(5, ypos + 10, 170 * 0.2, 170 * 0.2)];
            [playSoundButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
            playSoundButton.tag = i;
            [playSoundButton addTarget:self action:@selector(playAudioForHealthRecord:) forControlEvents:UIControlEventTouchUpInside];
            [bgViewForHealthRecords addSubview:playSoundButton];
        ypos = playSoundButton.frame.origin.y + playSoundButton.frame.size.height + 5;
        }
        
        UIView *horizontalLineView = [[UIView alloc]initWithFrame:CGRectMake(0, ypos, screenWidth, 1)];
        horizontalLineView.backgroundColor = [UIColor lightGrayColor];
        [bgViewForHealthRecords addSubview:horizontalLineView];
        
        CGRect frame = blueView.frame;
        frame.size.height = ypos + blueView.frame.origin.y;
        [blueView setFrame:frame];
    }
    
    CGRect frame = bgViewForHealthRecords.frame;
    frame.size.height = ypos + bgViewForHealthRecords.frame.origin.y;
    [bgViewForHealthRecords setFrame:frame];
    
    scrollView.contentSize = CGSizeMake(screenWidth, ypos + bgViewForHealthRecords.frame.origin.y + 200);
}
- (void)tapImageView:(UITapGestureRecognizer *)tap{
    NSDictionary *tempDic = [healthRecordsItems myObjectAtIndex:tap.view.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ImageViewController *view = (ImageViewController *)[story instantiateViewControllerWithIdentifier:@"ImageViewController"];
    NSString *url = [NSString stringWithFormat:@"%@", [tempDic  myObjectForKey:@"attachment"]];
    view.imageViewURL = url;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)playAudioForHealthRecord:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *tempDic = [healthRecordsItems myObjectAtIndex:btn.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoPlayerViewController *view = (VideoPlayerViewController *)[story instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    NSString *url = [NSString stringWithFormat:@"%@", [tempDic  myObjectForKey:@"voice"]];
    view.urlString = url;
    [self.navigationController pushViewController:view animated:YES];
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

#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 534) {
        if ([textView.text isEqualToString:@"نوشتن شرح حال..."]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
        
        if ([textView.text length] > 5) {
            [self enableSaveButton];
        } else {
            [self disableSaveButton];
        }
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 534) {
        if ([textView.text isEqualToString:@"نوشتن شرح حال..."]) {
            textView.text = @"";
        }
    }
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
    //picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)selectPhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    //picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    chosenImage = info[UIImagePickerControllerEditedImage];
    [self disableAttachButton];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self makePreviewForSelectedImage];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (NSString *)encodeToBase64String:(UIImage *)image {
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:0];
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
//                                 [filePathsArray myObjectAtIndex:i], @"answer", nil];
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

- (void)sendToServer{
    [self dismissTextField];
    [ProgressHUD show:@""];
    NSDictionary *params = @{
                             @"visit_id":[NSNumber numberWithInteger:_patientID],
                             @"description":_textView.text
                             };
    //NSData *imageData = UIImagePNGRepresentation(attachImageView.image);
    NSData *voiceData = [NSData dataWithContentsOfFile:recordingVoiceNameStr];
    [Networking uploadVoiceWithPath:@"online_booking/submit_health_record" parameters:params voice:voiceData success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:[responseDict myObjectForKey:@"message"] withType:AZJAlertMessageTypeInfo];
        [self backButtonImgAction];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissTimesView" object:nil];
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}

- (void)getSessionDetail{
    [self dismissTextField];
    [ProgressHUD show:@""];
    NSDictionary *params = @{@"id":[NSNumber numberWithDouble:_patientID]
                             };
    [Networking formDataWithPath:@"online_booking/doctor/visit" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        if ([[responseDict  myObjectForKey:@"success"]integerValue] == 1) {
            [self makePart2WithTitle:[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"title"]
                           startTime:[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"time_start"]
                             endTime:[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"time_end"]
                                date:[[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"date"]doubleValue]];
            [self makeNeveshtaneSharhehalView];
            healthRecordsItems = [[NSArray alloc]initWithArray:[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"health_records"]];
            NSMutableArray *arr = [[NSMutableArray alloc]initWithArray:healthRecordsItems];
            [arr insertObject:[[responseDict  myObjectForKey:@"data"] myObjectForKey:@"treatment"] atIndex:0];
            [self makeHealthRecordsView:arr];
            healthRecordsItems = [[NSArray alloc]initWithArray:arr];
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
#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_textView resignFirstResponder];
}
@end
