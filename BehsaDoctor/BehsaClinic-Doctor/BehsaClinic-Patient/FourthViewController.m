//
//  FourthViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/11/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UIImageView *profileImageView;
    UILabel *usernameLabel;
    UILabel *jobTitleLabel;
    UIScrollView *scrollView;
    UIButton *infoButton;
    UIButton *postButton;
    UIView *infoView;
    UIView *infoView2;
    UIView *indicatorView;
    NSInteger  selectedRow;
    //UILabel *descriptionLabel;
    UITextView *aboutTextView;
    BOOL    isExpand;
    UIRefreshControl *refreshControl;
    BOOL isMenuOpen;
    UIView *menuView;
    UIImageView *menuImageView;
    NSMutableArray *menuItemsArray;
    UIScrollView *menuScrollView;
    UIImageView *selectImageView;
    NSInteger selectedItemNumber;
    UIButton *categoryButton;
    BOOL    isPagingForCategories;
    BOOL    noMoreData;
    BOOL    isRightMenuAppears;
    BOOL    isDownloadingAudio;
    BOOL    isDownloadingVideo;
    UIButton *menubuttons;
    UIView *rightMenuView;
    NSString *documentsDirectory;
    AVAudioPlayer *audioPlayer;
    BOOL isPlayingTempVoice;
    NSInteger playingAudioRowNumber;
    NSInteger whichRowShouldBeReload;
    NSTimer *playbackTimer;
    NSTimer *myTimer;
    UIView *blurViewForMenu;
    CGFloat waveformProgressNumber;
    BOOL disableTableView;
    NSInteger page;
    NSInteger entityId;
    BOOL isSettingMenuShown;
    UILabel *noResultLabelPost;
    NSMutableArray *tableArrayCopy;
    BOOL isBusyNow;
    NSDictionary *dictionary;
    
}
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *tableArray;
@property(nonatomic, retain)NSMutableArray *likeArray;
@property(nonatomic, retain)NSMutableArray *favArray;

@end

@implementation FourthViewController

- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitleLabel:@"صفحه درمانگر"];
    
    [self scrollviewMaker];
    [self topSectionView];
    [self segmentView];
    [self makeInfoView];
    [self makePostTableView];
    self.tableView.hidden = YES;
    infoView.hidden = NO;
    
    [self showMenuButton];
    
    [infoView2 removeFromSuperview];
    [self getProfileDataFromServer];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods

- (void)scrollviewMaker{
    scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, screenHeight - 70)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    //scrollView.backgroundColor = [UIColor redColor];
}
- (void)topSectionView{
    NSInteger authorImageWidth = 50;
    profileImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth - authorImageWidth - 20, 5, authorImageWidth, authorImageWidth)];
    profileImageView.layer.cornerRadius = authorImageWidth/2;
    profileImageView.clipsToBounds = YES;
    profileImageView.image = [UIImage imageNamed:@"icon upload ax"];
    profileImageView.userInteractionEnabled = YES;
    //UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(profileImageViewAction)];
    //[profileImageView addGestureRecognizer:tap2];
    [scrollView addSubview:profileImageView];
    
    usernameLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, profileImageView.frame.origin.y, screenWidth - authorImageWidth - 40, 50)];
    usernameLabel.numberOfLines = 2;
    usernameLabel.font = FONT_NORMAL(13);
    usernameLabel.minimumScaleFactor = 0.5;
    usernameLabel.adjustsFontSizeToFitWidth = YES;
    //usernameLabel.text = @"آرش جهانگیری\nمهندس نرم افزار";
    usernameLabel.textColor = [UIColor blackColor];
    usernameLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:usernameLabel];
    
    jobTitleLabel =[[UILabel alloc]initWithFrame:CGRectMake(10, profileImageView.frame.origin.y + 20, screenWidth - authorImageWidth - 40, 50)];
    jobTitleLabel.numberOfLines = 2;
    jobTitleLabel.font = FONT_NORMAL(13);
    jobTitleLabel.minimumScaleFactor = 0.5;
    jobTitleLabel.adjustsFontSizeToFitWidth = YES;
    jobTitleLabel.textColor = [UIColor grayColor];
    jobTitleLabel.textAlignment = NSTextAlignmentRight;
    [scrollView addSubview:jobTitleLabel];

    UIButton *editButton = [CustomButton initButtonWithImage:[UIImage imageNamed:@"edit"] withFrame:CGRectMake(20, profileImageView.frame.origin.y + 10, 40, 40)];
    [editButton addTarget:self action:@selector(editButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:editButton];
}

- (void)editButtonAction{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    EditProfileViewController *view = (EditProfileViewController *)[story instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    view.dictionary = dictionary;
    view.profileImage = profileImageView.image;
    [self presentViewController:view animated:YES completion:nil];
}

- (void)segmentView{
    UIView *horizontalLine = [[UIView alloc]initWithFrame:CGRectMake(20, profileImageView.frame.origin.y + profileImageView.frame.size.height + 15, screenWidth - 40, 1)];
    horizontalLine.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:horizontalLine];
    
    indicatorView = [[UIView alloc]initWithFrame:CGRectMake(screenWidth/2, horizontalLine.frame.origin.y + 1, screenWidth/2 - 20, 3)];
    indicatorView.backgroundColor = MAIN_COLOR;
    [scrollView addSubview:indicatorView];
    
    infoButton = [CustomButton initButtonWithTitle:@"مشخصات پزشک" withTitleColor:[UIColor grayColor] withBackColor:[UIColor clearColor] withFrame:CGRectMake(screenWidth/2, horizontalLine.frame.origin.y + 10, screenWidth/2, 25)];
    [infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:infoButton];
    
    postButton = [CustomButton initButtonWithTitle:@"پست" withTitleColor:[UIColor grayColor] withBackColor:[UIColor clearColor] withFrame:CGRectMake(0, horizontalLine.frame.origin.y + 10, screenWidth/2, 25)];
    [postButton addTarget:self action:@selector(postButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:postButton];
}

- (void)infoButtonAction{
    CGRect frame = indicatorView.frame;
    frame.origin.x = screenWidth/2;
    [UIView animateWithDuration:0.5 animations:^{
        [indicatorView setFrame:frame];
    }];
    
    self.tableView.hidden = YES;
    infoView.hidden = NO;
}
- (void)postButtonAction{
    CGRect frame = indicatorView.frame;
    frame.origin.x = 20;
    [UIView animateWithDuration:0.5 animations:^{
        [indicatorView setFrame:frame];
    }];
    
    self.tableView.hidden = NO;
    infoView.hidden = YES;
}

- (void)makeInfoView{
    infoView = [[UIView alloc]initWithFrame:CGRectMake(0, postButton.frame.origin.y + postButton.frame.size.height + 10, screenWidth, screenHeight)];
    //infoView.backgroundColor = [UIColor lightGrayColor];
    [scrollView addSubview:infoView];
    
    aboutTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, screenWidth - 20, 70)];
    aboutTextView.textAlignment = NSTextAlignmentRight;
    aboutTextView.font= FONT_NORMAL(13);
    aboutTextView.editable = NO;
    [infoView addSubview:aboutTextView];
    /*descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, screenWidth - 20, 50)];
    descriptionLabel.numberOfLines = 0;
    descriptionLabel.font = FONT_NORMAL(13);
    descriptionLabel.minimumScaleFactor = 0.5;
    descriptionLabel.adjustsFontSizeToFitWidth = YES;
    descriptionLabel.textColor = [UIColor blackColor];
    descriptionLabel.textAlignment = NSTextAlignmentRight;
    [infoView addSubview:descriptionLabel];
    */
    
    UILabel *omomiLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, aboutTextView.frame.origin.y + aboutTextView.frame.size.height + 5, screenWidth - 20, 20)];
    omomiLabel.numberOfLines = 0;
    omomiLabel.font = FONT_NORMAL(16);
    omomiLabel.text = @"اطلاعات عمومی";
    omomiLabel.textColor = [UIColor grayColor];
    omomiLabel.textAlignment = NSTextAlignmentRight;
    [infoView addSubview:omomiLabel];
}

- (void)makeElementsOFInfoView:(NSDictionary *)elements{
    CGFloat ypos2 = aboutTextView.frame.origin.y + aboutTextView.frame.size.height + 20;
    infoView2 = [[UIView alloc]initWithFrame:CGRectMake(0, ypos2 + 20, screenWidth, screenHeight)];
    [infoView addSubview:infoView2];
    CGFloat ypos = 0;
    for (NSDictionary *dic in elements) {
        NSString *nameStr = [dic  myObjectForKey:@"name"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake((screenWidth - 10) - nameStr.getWidthOfString, ypos, /*screenWidth/2 - 30*/nameStr.getWidthOfString, 25)];
        label.numberOfLines = 0;
        label.font = FONT_NORMAL(13);
        label.minimumScaleFactor = 0.5;
        label.adjustsFontSizeToFitWidth = YES;
        label.text = nameStr;
        label.textColor = [UIColor grayColor];
        label.textAlignment = NSTextAlignmentRight;
        //label.backgroundColor = [UIColor cyanColor];
        [infoView2 addSubview:label];
        
        NSString *valueStr = [dic  myObjectForKey:@"value"];
        NSLog(@"%@:%f", valueStr,valueStr.getWidthOfString);
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(((screenWidth - 10) - nameStr.getWidthOfString) - (valueStr.getWidthOfString), ypos,
        valueStr.getWidthOfString, 25)];
        label2.numberOfLines = 0;
        label2.font = FONT_NORMAL(11);
        label2.minimumScaleFactor = 0.5;
        label2.adjustsFontSizeToFitWidth = YES;
        label2.text = valueStr;
        label2.textColor = [UIColor blackColor];
        label2.textAlignment = NSTextAlignmentRight;
        //label2.backgroundColor = [UIColor redColor];
        [infoView2 addSubview:label2];
        
        ypos += 35;
    }
    
    CGRect frame = infoView2.frame;
    frame.size.height = ypos + 50;
    [infoView2 setFrame:frame];
    scrollView.contentSize = CGSizeMake(screenWidth, ypos + ypos2 + 200);
}

- (void)makePostTableView{
    _tableArray = [[NSMutableArray alloc]init];
    CGFloat ypos = postButton.frame.origin.y + postButton.frame.size.height + 10;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ypos, screenWidth, screenHeight - ypos - 40)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [scrollView addSubview:self.tableView];
}

- (CGFloat)getHeightOfString:(NSString *)labelText{
    
    UIFont *font = FONT_NORMAL(16);
    if (IS_IPAD) {
        font = FONT_NORMAL(26);
    }
    CGSize sizeOfText = [labelText boundingRectWithSize: CGSizeMake( self.view.bounds.size.width - 30,CGFLOAT_MAX)
                                                options: (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                             attributes: [NSDictionary dictionaryWithObject:font
                                                                                     forKey:NSFontAttributeName]
                                                context: nil].size;
    CGFloat height = sizeOfText.height + 50;
    if (height < screenWidth + 10)
        height = screenWidth + 10;
    return height;
    
}

- (void)favButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    UIImage *offImage = [UIImage imageNamed:@"fav off"];
    UIImage *onImage = [UIImage imageNamed:@"fav on"];
    UIImage *currentImage = [btn imageForState:UIControlStateNormal];
    if ([UIImagePNGRepresentation(offImage) isEqualToData:UIImagePNGRepresentation(currentImage)]) {
        [btn setImage:onImage forState:UIControlStateNormal];
    }else{
        [btn setImage:offImage forState:UIControlStateNormal];
    }
    NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:btn.tag];
    NSDictionary *tempDic = [[NSDictionary alloc]initWithObjectsAndKeys:landingPageDic.LPPostID, @"id", [NSNumber numberWithInteger:btn.tag], @"index", nil];
    [_favArray addObject:tempDic];
    [self favOnServerWithID:landingPageDic.LPPostID];
    
}

- (void)likeButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    UIImage *offImage = [UIImage imageNamed:@"like icon"];
    UIImage *onImage = [UIImage imageNamed:@"like"];
    UIImage *currentImage = [btn imageForState:UIControlStateNormal];
    
    NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:btn.tag];
    NSMutableDictionary *landingPageDic2 = [[NSMutableDictionary alloc]initWithDictionary:landingPageDic];
    NSDictionary *tempDic = [[NSDictionary alloc]initWithObjectsAndKeys:landingPageDic2.LPPostID, @"id", [NSNumber numberWithInteger:btn.tag], @"index", nil];
    [_likeArray addObject:tempDic];
    [self likeOnServerWithID:landingPageDic2.LPPostID];
    
    NSInteger likes = [landingPageDic2.LPTVLikes_count integerValue];
    if ([landingPageDic2.LPLiked integerValue] == 0) {
        likes++;
        //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPPostID];
        
    }else{
        if (likes == 0) {
            likes = 0;
        }else{
            likes--;
        }
        
        //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPPostID];
        
    }
    
    [landingPageDic2 setObject:[NSString stringWithFormat:@"%ld", (long)likes] forKey:@"like_count"];
    
    if ([UIImagePNGRepresentation(offImage) isEqualToData:UIImagePNGRepresentation(currentImage)]) {
        [btn setImage:onImage forState:UIControlStateNormal];
        [landingPageDic2 setObject:[NSString stringWithFormat:@"%d",1] forKey:@"liked"];
        
    }else{
        [btn setImage:offImage forState:UIControlStateNormal];
        [landingPageDic2 setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"liked"];
    }
    
    //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%@", [[tempDic  myObjectForKey:@"data"]  myObjectForKey:@"count"]] field:@"likes_count" postId:landingPageDic2.LPPostID];
    
    [self.tableArray replaceObjectAtIndex:btn.tag withObject:landingPageDic2];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)rollbackLikeButtonActionForIndexPath:(NSIndexPath *)indexpath{
    LandingPageCustomCell *cell = (LandingPageCustomCell *)[self.tableView cellForRowAtIndexPath:indexpath];
    UIButton *btn = cell.heartButton;
    UIImage *offImage = [UIImage imageNamed:@"like"];
    UIImage *onImage = [UIImage imageNamed:@"like on"];
    UIImage *currentImage = [btn imageForState:UIControlStateNormal];
    if ([UIImagePNGRepresentation(offImage) isEqualToData:UIImagePNGRepresentation(currentImage)]) {
        [btn setImage:onImage forState:UIControlStateNormal];
    }else{
        [btn setImage:offImage forState:UIControlStateNormal];
    }
    
    NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:btn.tag];
    NSMutableDictionary *landingPageDic2 = [[NSMutableDictionary alloc]initWithDictionary:landingPageDic];
    
    NSInteger likes = [landingPageDic2.LPTVLikes_count integerValue];
    if ([landingPageDic2.LPLiked integerValue] == 0) {
        likes++;
        [landingPageDic2 setObject:[NSString stringWithFormat:[NSString stringWithFormat:@"%d", 1], likes] forKey:@"liked"];
        //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPPostID];
        
    }else{
        likes--;
        [landingPageDic2 setObject:[NSString stringWithFormat:[NSString stringWithFormat:@"%d", 0], likes] forKey:@"liked"];
        //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPPostID];
        
    }
    
    [landingPageDic2 setObject:[NSString stringWithFormat:@"%ld", (long)likes] forKey:@"likesCount"];
    //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%@", [[tempDic  myObjectForKey:@"data"]  myObjectForKey:@"count"]] field:@"likes_count" postId:landingPageDic2.LPPostID];
    
    [self.tableArray replaceObjectAtIndex:btn.tag withObject:landingPageDic2];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)shareButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:btn.tag];
    
    NSString *textToShare = landingPageDic.LPTitle;
    NSString *textToShare2 = landingPageDic.LPContent;
    NSString *textToShare3 = @"این متن توسط کلینیک بهسا به اشتراک گذاشته شده است\n";
    
    NSArray *objectsToShare = @[textToShare, textToShare2, textToShare3];

    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}

- (void)tapOnAuthorImage:(UITapGestureRecognizer *)tap{
    NSDictionary *tempDic = [_tableArray myObjectAtIndex:tap.view.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController *view = (UserProfileViewController *)[story instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    view.entityID = [tempDic.LPUserEntityId integerValue];//[[[tempDic  myObjectForKey:@"entity"] myObjectForKey:@"id"]integerValue];
    // view.dictionary = tempDic;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)commentImageViewAction:(UITapGestureRecognizer *)tap{
    //NSLog(@"%ld", (long)tap.view.tag);
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *view = (CommentViewController *)[story instantiateViewControllerWithIdentifier:@"CommentViewController"];
    view.postId = [[[_tableArray myObjectAtIndex:tap.view.tag] myObjectForKey:@"id"]integerValue];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}
- (void)videoButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = [self.tableArray myObjectAtIndex:btn.tag];
    //NSLog(@"%@", [dic  myObjectForKey:@"videoUrl"]);
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoPlayerViewController *view = (VideoPlayerViewController *)[story instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    view.urlString = [dic  myObjectForKey:@"videoUrl"];
    view.titleString = [dic  myObjectForKey:@"title"];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)audioButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = [self.tableArray myObjectAtIndex:btn.tag];
    //NSLog(@"%@", [dic  myObjectForKey:@"audioUrl"]);
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoPlayerViewController *view = (VideoPlayerViewController *)[story instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    view.urlString = [dic  myObjectForKey:@"audioUrl"];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)deleteDuplicateData{
    if ([self.tableArray count] == 0) {
        return;
    }
    NSDictionary *tempDic = [self.tableArray myObjectAtIndex:0];
    NSMutableArray *indexToBeDeletedArray = [[NSMutableArray alloc]initWithArray:self.tableArray];
    for (NSInteger i = 0; i < [self.tableArray count] - 1; i++) {
        if ([[[self.tableArray myObjectAtIndex:i+1]  myObjectForKey:@"id"]integerValue] == [tempDic.LPPostID integerValue]) {
            if (i+1 < [self.tableArray count]) {
                [indexToBeDeletedArray removeObjectAtIndex:i+1];
            }
            tempDic = [self.tableArray myObjectAtIndex:i];
        }
    }
    
    self.tableArray = [[NSMutableArray alloc]initWithArray:indexToBeDeletedArray];
    NSLog(@"%@", self.tableArray);
}
#pragma mark - table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        return screenWidth + 10;
    }else {//iphone
        NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:indexPath.row];
        NSString *postType = landingPageDic.LPPostType;
        if (([postType isEqualToString:@"audio"])) {
            if ([landingPageDic.LPCoverRatio floatValue] == 1) {
                return 280 + [[landingPageDic objectForKey:@"text"] getHeightOfString] - 50;
            } else {
                return 200 + [[landingPageDic objectForKey:@"text"] getHeightOfString] - 50 + (screenWidth / [landingPageDic.LPCoverRatio floatValue]);
            }
        }
        
        if (([postType isEqualToString:@"document"]) && ([landingPageDic.LPImageUrl length] <= 6)) {
            if ([landingPageDic.LPCoverRatio floatValue] == 1) {
                return 200 + [[landingPageDic objectForKey:@"content"] getHeightOfString] - 50;
            } else {
                return 120 + [[landingPageDic objectForKey:@"content"] getHeightOfString] - 50 + (screenWidth / [landingPageDic.LPCoverRatio floatValue]);
            }
        }
        
        if ([landingPageDic.LPImageUrl length] == 0 || (([landingPageDic.LPImageUrl isEqualToString:@"(null)"]) && ([landingPageDic.LPVideoUrl length] <= 6)) ) {
            return 210 + [[landingPageDic objectForKey:@"text"] getHeightOfString] - 50;
        }
        return screenWidth + [[landingPageDic objectForKey:@"text"] getHeightOfString] - 150 + (screenWidth / [landingPageDic.LPCoverRatio floatValue]) - 10;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cellToReturn=nil;
    if ([self.tableArray count] == 0) {
        return cellToReturn;
    }

    NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:indexPath.row];
    NSString *postType = landingPageDic.LPPostType;
    
    if ([[landingPageDic allKeys]count] == 0) {
        LandingPageCustomCellAudio *cell = (LandingPageCustomCellAudio *)[[LandingPageCustomCellAudio alloc]
                                                                          initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.contentLabel.text = @"هیچ پستی وجود ندارد";
        cellToReturn = cell;
    }
    
    //audio
    if ([postType isEqualToString:@"audio"]) {
        //NSString *cellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
        LandingPageCustomCellAudio *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        //if (indexPath.row < [self.tableArray count] - 1) {
        
        if (cell == nil)
            cell = (LandingPageCustomCellAudio *)[[LandingPageCustomCellAudio alloc]
                                                  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1" coverRatio:[landingPageDic.LPCoverRatio floatValue]];
        //if (indexPath.row < [self.tableArray count] - 1) {
        if ([self.tableArray count] > 0) {
            cell.tag = indexPath.row;
            
            //title
            cell.titleLabel.text = landingPageDic.LPTitle;
            
            //cell.jobLabel.text = landingPageDic.LPUserJobTitle;
            
            //date
            NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc]init];
            [currentDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *endDate = [NSDate date];
            
            double timestampval = [landingPageDic.LPPublish_date doubleValue];
            NSTimeInterval timestamp = (NSTimeInterval)timestampval;
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                   [TimeAgoViewController timeIntervalWithStartDate:startDate withEndDate:endDate]];
            
            //post image
            //451 × 73
            cell.postImageView.image = [UIImage imageNamed:@"progress play"];
            
            cell.downloadPlayButton.tag = indexPath.row;
            [cell.downloadPlayButton addTarget:self action:@selector(audioButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            //category
            cell.categoryLabel.text = landingPageDic.LPCategoryName;
            if ([cell.categoryLabel.text length] == 0) {
                cell.categoryLabel.text = landingPageDic.LPCategoryName;
            }
            //seen label
            cell.commentCountLabel.text = landingPageDic.LPRecommends_count;
            cell.commentCountLabel.text = [cell.commentCountLabel.text convertEnglishNumbersToFarsi];
            //like label
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)landingPageDic.LPLikes_count];
            cell.likeCountLabel.text = [cell.likeCountLabel.text convertEnglishNumbersToFarsi];

            cell.likeCountLabel.tag = indexPath.row;
            //author image
            [cell.authorImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", landingPageDic.LPUserAvatarUrl]] placeholderImage:[UIImage imageNamed:@"dontprofile"]];
            cell.authorImageView.userInteractionEnabled = YES;
            cell.authorImageView.tag = indexPath.row;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapOnAuthorImage:)];
            [cell.authorImageView addGestureRecognizer:tap];
            
            //author name
            cell.authorNameLabel.text = landingPageDic.LPUserTitle;
            
            //author job title
            cell.authorJobLabel.text = landingPageDic.LPUserJobTitle;
            
            //content
            cell.contentLabel.text = landingPageDic.LPContent;
            //cell.contentLabel.text = [[cell.contentLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            /*
             if (selectedRow == indexPath.row) {
             cell.commentImageView.image = [UIImage imageNamed:@"comment"];
             CGRect rect = cell.contentLabel.frame;
             rect.size.height = [landingPageDic.LPContent];
             //rect.origin.y = cell.authorImageView.frame.origin.y - 100;
             if (rect.origin.y < cell.authorImageView.frame.origin.y) {
             rect.origin.y = cell.authorImageView.frame.origin.y;
             }
             [cell.contentLabel setFrame:rect];
             [cell.contentLabel sizeToFit];
             }else{
             cell.commentImageView.image = [UIImage imageNamed:@"comment"];
             }
             */
            cell.commentImageView.tag = indexPath.row;
            cell.commentImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentImageViewAction:)];
            [cell.commentImageView addGestureRecognizer:tap2];
            
            cell.favButton.tag = indexPath.row;
            [cell.favButton addTarget:self action:@selector(favButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.heartButton.tag = indexPath.row;
            [cell.heartButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.shareButton.tag = indexPath.row;
            [cell.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([landingPageDic.LPFavorite integerValue] == 0) {
                [cell.favButton setImage:[UIImage imageNamed:@"fav off"] forState:UIControlStateNormal];
            }else{
                [cell.favButton setImage:[UIImage imageNamed:@"fav on"] forState:UIControlStateNormal];
            }
            
            if ([landingPageDic.LPLiked integerValue] == 0) {
                [cell.heartButton setImage:[UIImage imageNamed:@"like icon"] forState:UIControlStateNormal];
            }else{
                [cell.heartButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            }
        }
        //}
        cellToReturn = cell;
        //        }else{
        //            return [self loadingCell];
        //        }
        //video
    }else if ([postType isEqualToString:@"video"]){
        //NSString *cellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
        LandingPageCustomCellVideo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        //if (indexPath.row < [self.tableArray count] - 1) {
        
        if (cell == nil)
            cell = (LandingPageCustomCellVideo *)[[LandingPageCustomCellVideo alloc]
                                                  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2" coverRatio:[landingPageDic.LPCoverRatio floatValue]];
        //if (indexPath.row < [self.tableArray count] - 1) {
        if ([self.tableArray count] > 0) {
            cell.tag = indexPath.row;
            
            //title
            cell.titleLabel.text = landingPageDic.LPTitle;
            
            //cell.jobLabel.text = landingPageDic.LPUserJobTitle;
            
            //action for video
            cell.videoButton.tag = indexPath.row;
            [cell.videoButton addTarget:self action:@selector(videoButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            //date
            NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc]init];
            [currentDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *endDate = [NSDate date];
            
            double timestampval = [landingPageDic.LPPublish_date doubleValue];
            NSTimeInterval timestamp = (NSTimeInterval)timestampval;
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                   [TimeAgoViewController timeIntervalWithStartDate:startDate withEndDate:endDate]];
            
            //post image
            [cell.postImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", landingPageDic.LPImageUrl]] placeholderImage:[UIImage imageNamed:@"broken_image"]];
            
            //category
            cell.categoryLabel.text = landingPageDic.LPCategoryName;
            if ([cell.categoryLabel.text length] == 0) {
                cell.categoryLabel.text = landingPageDic.LPCategoryName;
            }
            //seen label
            cell.commentCountLabel.text = landingPageDic.LPRecommends_count;
            cell.commentCountLabel.text = [cell.commentCountLabel.text convertEnglishNumbersToFarsi];
            
            //like label
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)landingPageDic.LPLikes_count];
            cell.likeCountLabel.text = [cell.likeCountLabel.text convertEnglishNumbersToFarsi];
            cell.likeCountLabel.tag = indexPath.row;
            //author image
            [cell.authorImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", landingPageDic.LPUserAvatarUrl]] placeholderImage:[UIImage imageNamed:@"dontprofile"]];
            cell.authorImageView.userInteractionEnabled = YES;
            cell.authorImageView.tag = indexPath.row;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapOnAuthorImage:)];
            [cell.authorImageView addGestureRecognizer:tap];
            
            //author name
            cell.authorNameLabel.text = landingPageDic.LPUserTitle;
            
            //author job title
            cell.authorJobLabel.text = landingPageDic.LPUserJobTitle;
            
            //content
            cell.contentLabel.text = landingPageDic.LPContent;
            //cell.contentLabel.text = [[cell.contentLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            /*
             if (selectedRow == indexPath.row) {
             cell.commentImageView.image = [UIImage imageNamed:@"comment"];
             CGRect rect = cell.contentLabel.frame;
             rect.size.height = [landingPageDic.LPContent];
             //rect.origin.y = cell.authorImageView.frame.origin.y - 100;
             if (rect.origin.y < cell.authorImageView.frame.origin.y) {
             rect.origin.y = cell.authorImageView.frame.origin.y;
             }
             [cell.contentLabel setFrame:rect];
             [cell.contentLabel sizeToFit];
             }else{
             cell.commentImageView.image = [UIImage imageNamed:@"comment"];
             }
             */
            cell.commentImageView.tag = indexPath.row;
            cell.commentImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentImageViewAction:)];
            [cell.commentImageView addGestureRecognizer:tap2];
            
            cell.favButton.tag = indexPath.row;
            [cell.favButton addTarget:self action:@selector(favButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.heartButton.tag = indexPath.row;
            [cell.heartButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.shareButton.tag = indexPath.row;
            [cell.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([landingPageDic.LPFavorite integerValue] == 0) {
                [cell.favButton setImage:[UIImage imageNamed:@"fav off"] forState:UIControlStateNormal];
            }else{
                [cell.favButton setImage:[UIImage imageNamed:@"fav on"] forState:UIControlStateNormal];
            }
            
            if ([landingPageDic.LPLiked integerValue] == 0) {
                [cell.heartButton setImage:[UIImage imageNamed:@"like icon"] forState:UIControlStateNormal];
            }else{
                [cell.heartButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            }
        }
        //}
        cellToReturn = cell;
        //        }else{
        //            return [self loadingCell];
        //        }
        
    }else{//other post type
        NSString *cellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
        LandingPageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        //if (indexPath.row < [self.tableArray count] - 1) {
        
        if (cell == nil){
            if (([landingPageDic.LPImageUrl length] > 10) || ([landingPageDic.LPImageUrl length] > 10)) {
                cell = (LandingPageCustomCell *)[[LandingPageCustomCell alloc]
                                                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier isPostImage:YES height:[[landingPageDic objectForKey:@"text"] getHeightOfString]coverRatio:[landingPageDic.LPCoverRatio floatValue]];
            }else{
                cell = (LandingPageCustomCell *)[[LandingPageCustomCell alloc]
                                                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier isPostImage:NO height:[[landingPageDic objectForKey:@"text"] getHeightOfString]coverRatio:[landingPageDic.LPCoverRatio floatValue]];
            }
            
        }
        // if (indexPath.row < [self.tableArray count] - 1) {
        if ([self.tableArray count] > 0) {
            cell.tag = indexPath.row;
            
            //title
            cell.titleLabel.text = landingPageDic.LPTitle;
            
            //cell.jobLabel.text = landingPageDic.LPUserJobTitle;
            
            //date
            NSDateFormatter *currentDateFormatter = [[NSDateFormatter alloc]init];
            [currentDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate *endDate = [NSDate date];
            
            double timestampval = [landingPageDic.LPPublish_date doubleValue];
            NSTimeInterval timestamp = (NSTimeInterval)timestampval;
            NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
            cell.dateLabel.text = [NSString stringWithFormat:@"%@",
                                   [TimeAgoViewController timeIntervalWithStartDate:startDate withEndDate:endDate]];
            
            //post image
            if ([landingPageDic.LPImageUrl length] > 10) {
                [cell.postImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", landingPageDic.LPImageUrl]] placeholderImage:[UIImage imageNamed:@"broken_image"]];
            }else{
                [cell.postImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", landingPageDic.LPImageUrl]]];
            }
            
            
            //category
            cell.categoryLabel.text = landingPageDic.LPCategoryName;
            if ([cell.categoryLabel.text length] == 0) {
                cell.categoryLabel.text = landingPageDic.LPCategoryName;
            }
            //seen label
            cell.commentCountLabel.text = landingPageDic.LPRecommends_count;
            cell.commentCountLabel.text = [cell.commentCountLabel.text convertEnglishNumbersToFarsi];
            //like label
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%ld",(long)landingPageDic.LPLikes_count];
            cell.likeCountLabel.text = [cell.likeCountLabel.text convertEnglishNumbersToFarsi];
            cell.likeCountLabel.tag = indexPath.row;
            //author image
            [cell.authorImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", landingPageDic.LPUserAvatarUrl]] placeholderImage:[UIImage imageNamed:@"dontprofile"]];
            cell.authorImageView.userInteractionEnabled = YES;
            cell.authorImageView.tag = indexPath.row;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tapOnAuthorImage:)];
            [cell.authorImageView addGestureRecognizer:tap];
            
            //author name
            cell.authorNameLabel.text = landingPageDic.LPUserTitle;
            
            //author job title
            cell.authorJobLabel.text = landingPageDic.LPUserJobTitle;
            
            //content
            cell.contentLabel.text = landingPageDic.LPContentSummary;
            //cell.contentLabel.text = [[cell.contentLabel.text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] componentsJoinedByString:@" "];
            
            /*
             if (selectedRow == indexPath.row) {
             cell.commentImageView.image = [UIImage imageNamed:@"comment"];
             CGRect rect = cell.contentLabel.frame;
             rect.size.height = [landingPageDic.LPContent];
             //rect.origin.y = cell.authorImageView.frame.origin.y - 100;
             if (rect.origin.y < cell.authorImageView.frame.origin.y) {
             rect.origin.y = cell.authorImageView.frame.origin.y;
             }
             [cell.contentLabel setFrame:rect];
             [cell.contentLabel sizeToFit];
             }else{
             cell.commentImageView.image = [UIImage imageNamed:@"comment"];
             }
             */
            
            cell.commentImageView.tag = indexPath.row;
            cell.commentImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(commentImageViewAction:)];
            [cell.commentImageView addGestureRecognizer:tap2];
            
            cell.favButton.tag = indexPath.row;
            [cell.favButton addTarget:self action:@selector(favButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.heartButton.tag = indexPath.row;
            [cell.heartButton addTarget:self action:@selector(likeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.shareButton.tag = indexPath.row;
            [cell.shareButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            if ([landingPageDic.LPFavorite integerValue] == 0) {
                [cell.favButton setImage:[UIImage imageNamed:@"fav off"] forState:UIControlStateNormal];
            }else{
                [cell.favButton setImage:[UIImage imageNamed:@"fav on"] forState:UIControlStateNormal];
            }
            
            if ([landingPageDic.LPLiked integerValue] == 0) {
                [cell.heartButton setImage:[UIImage imageNamed:@"like icon"] forState:UIControlStateNormal];
            }else{
                [cell.heartButton setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            }
        }
        //}
        cellToReturn = cell;
        //        }else{
        //            return [self loadingCell];
        //        }
        
    }
    return cellToReturn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [_tableArray myObjectAtIndex:indexPath.row];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LandingPageDetailViewController *view = (LandingPageDetailViewController *)[story instantiateViewControllerWithIdentifier:@"LandingPageDetailViewController"];
    view.dictionary = dic;
    [self.navigationController pushViewController:view animated:YES];
}

#pragma mark - Connection
-(void)getProfileDataFromServer
{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
    [ProgressHUD show:@""];
    NSString *url = [NSString stringWithFormat:@"%@doctor/profile", BaseURL];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    manager.requestSerializer.timeoutInterval = 45;
    //NSLog(@"token: %@", [GetUsernamePassword getAccessToken]);
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [GetUsernamePassword getAccessToken]] forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [ProgressHUD dismiss];
        dictionary  =responseObject;
        if ([[dictionary  myObjectForKey:@"error_code"]integerValue] == 401) {
            return;
        }
        entityId = [[[dictionary  myObjectForKey:@"data"] myObjectForKey:@"id"]integerValue];
        aboutTextView.text = [NSString stringWithFormat:@"%@", [[dictionary  myObjectForKey:@"data"] myObjectForKey:@"about"]];
        jobTitleLabel.text = [NSString stringWithFormat:@"%@", [[[dictionary  myObjectForKey:@"data"] myObjectForKey:@"job_title"] myObjectForKey:@"name"]];
        [profileImageView setImageWithURL:[NSURL URLWithString:
                                           [NSString stringWithFormat:@"%@", [[dictionary  myObjectForKey:@"data"] myObjectForKey:@"avatar"]]]
                         placeholderImage:[UIImage imageNamed:@"icon upload ax"]];
        usernameLabel.text = [[dictionary  myObjectForKey:@"data"] myObjectForKey:@"name"];
        [self makeElementsOFInfoView:[[dictionary  myObjectForKey:@"data"] myObjectForKey:@"options"]];
        
        self.tableArray = [[NSMutableArray alloc]init];
        page = 1;
        [self fetchPostsFromServer:page];
        
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
- (void)fetchPostsFromServer:(NSInteger)pageOf{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
    if (!isBusyNow) {
        isBusyNow = YES;
        [refreshControl endRefreshing];
        [ProgressHUD show:@""];
        //NSInteger profileId = [[[NSUserDefaults standardUserDefaults] myObjectForKey:@"profileID"]integerValue];
        NSDictionary *params = @{
                                 @"id":[NSNumber numberWithInteger:entityId],
                                 @"page":[NSNumber numberWithInteger:pageOf]
                                 };
        NSString *url = [NSString stringWithFormat:@"%@timeline/doctor_profile", BaseURL];

        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
        manager.requestSerializer.timeoutInterval = 45;
        //NSLog(@"%@", [GetUsernamePassword getAccessToken]);
        [manager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@", [GetUsernamePassword getAccessToken]] forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
        } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [ProgressHUD dismiss];
            isBusyNow = NO;
            NSDictionary *tempDic = (NSDictionary *)responseObject;
            
            for (NSDictionary *post in [tempDic  myObjectForKey:@"data"]) {
                [self.tableArray addObject:post];
            }
            isBusyNow = NO;
            [self deleteDuplicateData];
            [self.tableView reloadData];
            
            [noResultLabelPost removeFromSuperview];
            if ([self.tableArray count] == 0) {
                [noResultLabelPost removeFromSuperview];
                noResultLabelPost = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 220, 10, 200,  25)];
                noResultLabelPost.font = FONT_NORMAL(13);
                noResultLabelPost.text = NSLocalizedString(@"noContent", @"");
                noResultLabelPost.minimumScaleFactor = 0.7;
                noResultLabelPost.textColor = [UIColor blackColor];
                noResultLabelPost.textAlignment = NSTextAlignmentRight;
                noResultLabelPost.adjustsFontSizeToFitWidth = YES;
                [self.tableView addSubview:noResultLabelPost];
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            isBusyNow = NO;
            [ProgressHUD dismiss];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"%@", [error localizedDescription]] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                // ////NSLog(@"You pressed button OK");
            }];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
            
        }];
    }
}

- (void)likeOnServerWithID:(NSString *)idOfPost{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
    NSDictionary *params = @{@"model":@"post",
                             @"id":[NSString stringWithFormat:@"%@", idOfPost]
                             };
    NSString *url = [NSString stringWithFormat:@"%@social_activity/like", BaseURL];
    AFHTTPSessionManager *manager = [NetworkManager shareManager2];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *tempDic = (NSDictionary *)responseObject;
        
        if ([[[tempDic  myObjectForKey:@"data"] myObjectForKey:@"status"] isEqualToString:@"+"]) {
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_likeArray count]; i++) {
                NSDictionary *likeDic = [_likeArray myObjectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic  myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic  myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            if (idOfTargetDelete < [_likeArray count]) {
                [_likeArray removeObjectAtIndex:idOfTargetDelete];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:idOfPost];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%@", [[tempDic  myObjectForKey:@"data"] myObjectForKey:@"count"]] field:@"likes_count" postId:idOfPost];
                
                //[self populateTableViewArray];
            }
        }else{//status = "-"
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_likeArray count]; i++) {
                NSDictionary *likeDic = [_likeArray myObjectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic  myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic  myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            //NSIndexPath *indexpath = [NSIndexPath indexPathForRow:idOfRow inSection:0];
            //[self rollbackLikeButtonActionForIndexPath:indexpath];
            [_likeArray removeObjectAtIndex:idOfTargetDelete];
            /*
             if (idOfTargetDelete < [_likeArray count]) {
             [_likeArray removeObjectAtIndex:idOfTargetDelete];
             [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"0" field:@"liked" postId:idOfPost];
             [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%@", [[tempDic  myObjectForKey:@"data"]  myObjectForKey:@"count"]] field:@"likes_count" postId:idOfPost];
             [self populateTableViewArray];
             }
             */
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        
        NSInteger idOfTargetDelete = 1000;
        NSInteger idOfRow = 1000;
        for (int i = 0; i < [_likeArray count]; i++) {
            NSDictionary *likeDic = [_likeArray myObjectAtIndex:i];
            if ([idOfPost integerValue] == [[likeDic  myObjectForKey:@"id"]integerValue]) {
                idOfTargetDelete = i;
                idOfRow = [[likeDic  myObjectForKey:@"index"]integerValue];
                break;
            }
        }
        //NSIndexPath *indexpath = [NSIndexPath indexPathForRow:idOfRow inSection:0];
        //[self rollbackLikeButtonActionForIndexPath:indexpath];
        /*
         if (idOfTargetDelete < [_likeArray count]) {
         [_likeArray removeObjectAtIndex:idOfTargetDelete];
         //
         NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:idOfRow];
         NSMutableDictionary *landingPageDic2 = [[NSMutableDictionary alloc]initWithDictionary:landingPageDic];
         NSInteger likes = [landingPageDic2.LPLikes_count integerValue];
         likes--;
         [landingPageDic2 setObject:[NSString stringWithFormat:@"%ld", (long)likes] forKey:@"likesCount"];
         [landingPageDic2 setObject:[NSString stringWithFormat:[NSString stringWithFormat:@"%d", 0], likes] forKey:@"liked"];
         [self.tableArray replaceObjectAtIndex:idOfRow withObject:landingPageDic2];
         [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idOfRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
         
         */
        //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%ld", (long)likes] field:@"liked" postId:idOfPost];
        //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idOfRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        //}
        
    }];
}

- (void)favOnServerWithID:(NSString *)idOfPost{
    if (![Networking hasConnectivity]) {
        [[AZJAlertView sharedInstance]showMessage:@"شما در حالت آفلاین هستید!" withType:AZJAlertMessageTypeError];
        return;
    }
    NSDictionary *params = @{@"model":@"post",
                             @"id":[NSString stringWithFormat:@"%@", idOfPost]
                             };
    NSString *url = [NSString stringWithFormat:@"%@social_activity/favorite", BaseURL];
    AFHTTPSessionManager *manager = [NetworkManager shareManager2];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *tempDic = (NSDictionary *)responseObject;
        
        if ([[[tempDic  myObjectForKey:@"data"] myObjectForKey:@"status"] isEqualToString:@"+"]) {
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_favArray count]; i++) {
                NSDictionary *likeDic = [_favArray myObjectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic  myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic  myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            if (idOfTargetDelete < [_favArray count]) {
                [_favArray removeObjectAtIndex:idOfTargetDelete];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"favorite" postId:idOfPost];
                //copy fav items into favorite table
                [Database copyLandingPageIntoFavoriteWithFilePath:[Database getDbFilePath] postID:idOfPost];
                
                //[self populateTableViewArray];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idOfRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }else if ([[[tempDic  myObjectForKey:@"data"] myObjectForKey:@"status"] isEqualToString:@"-"]){//status = "-"
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_favArray count]; i++) {
                NSDictionary *likeDic = [_favArray myObjectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic  myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic  myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            if (idOfTargetDelete < [_favArray count]) {
                [_favArray removeObjectAtIndex:idOfTargetDelete];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"0" field:@"favorite" postId:idOfPost];
                //delete fav item from favorite
                [Database deleteFavoriteWithFilePath:[Database getDbFilePath] withID:idOfPost];
                //[self populateTableViewArray];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idOfRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSInteger idOfTargetDelete = 1000;
        NSInteger idOfRow = 1000;
        for (int i = 0; i < [_favArray count]; i++) {
            NSDictionary *likeDic = [_favArray myObjectAtIndex:i];
            if ([idOfPost integerValue] == [[likeDic  myObjectForKey:@"id"]integerValue]) {
                idOfTargetDelete = i;
                idOfRow = [[likeDic  myObjectForKey:@"index"]integerValue];
                break;
            }
        }
        if (idOfTargetDelete < [_favArray count]) {
            [_favArray removeObjectAtIndex:idOfTargetDelete];
            [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"0" field:@"favorite" postId:idOfPost];
            //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idOfRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        }
        
    }];
}


#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = self.tableView.contentOffset.y + self.tableView.frame.size.height;
    if (bottomEdge >= _tableView.contentSize.height) {
        // we are at the end
        page++;
        [self fetchPostsFromServer:page];
    }
}
@end
