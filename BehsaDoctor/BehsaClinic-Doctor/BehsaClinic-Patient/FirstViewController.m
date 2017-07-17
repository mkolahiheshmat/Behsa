    //
    //  FirstViewController.m
    //  BehsaClinic-Patient
    //
    //  Created by Yarima on 2/11/17.
    //  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
    //

#import "FirstViewController.h"
#define loadingCellTag  1273


@interface FirstViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, AVAudioPlayerDelegate, UIWebViewDelegate, AudioCellDelegate, CustomCellDelegate, VideoCellDelegate>
{
    BOOL    isBusyNow;
    NSInteger  selectedRow;
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
        //DACircularProgressView *largeProgressView;
        //double progressViewArray[1000];
    NSInteger page;
    NSInteger entityId;
    BOOL isSettingMenuShown;
    UILabel *noResultLabelPost;
    NSMutableArray *tableArrayCopy;
}
@property(nonatomic, retain)UITableView *tableView;
@property(nonatomic, retain)NSMutableArray *tableArray;
@property(nonatomic, retain)NSMutableArray *likeArray;
@property(nonatomic, retain)NSMutableArray *favArray;
@property(nonatomic, strong)NSIndexPath *currentIndexPath;
@property (strong, nonatomic) NSTimer *timerForProgress;
@property (strong, nonatomic) NSTimer *timerForProgressFinal;
@end

@implementation FirstViewController


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
- (void)viewWillAppear:(BOOL)animated {
    [self refreshTable];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.tableView.userInteractionEnabled = YES;
}
- (void)testMethod{
        //NSLog(@"%@", self.delegate.testString);
}

- (void)testMonad{
    NSDictionary *person = @{@"name":@"Homer Simpson", @"address":@{@"street":@"123 Fake St", @"city_":@"Springfield"}};
    
    NSString *city = [NSString stringWithFormat:@"%@",  [[Maybe(person[@"address"][@"city"]) whenNothing:Maybe(@"No person.")]justValue]];
    NSLog(@"%@", city);
    
        //    NSString *cityString = [[[Maybe(person) whenNothing:Maybe(@"No person.") else:MapMaybe(person, [person myObjectForKey:@"address"])]
        //                             whenNothing:Maybe(@"No address.")] else:MapMaybe(address, [address myObjectForKey:@"city"])]
        //whenNothing:Maybe(@"No city.")] justValue];
}
- (void)viewDidLoad{
    [self testMonad];
    
        //page for request
    page = 1;
    
        //[self pushToNewPost];
    [self populateTableViewArray];
    disableTableView = YES;
    [self makeTopView];
    [self setTitleLabel:@"خانه"];
    NSDictionary *userpassDic = [GetUsernamePassword getUsernamePassword];
    NSString *username = [userpassDic objectForKey:@"username"];
    NSString *password = [userpassDic objectForKey:@"password"];
    
    if ([username length] == 0 || [password length] == 0) {
        [self pushToLoginView];
    }
    
        //entity id for request
    entityId = [[[NSUserDefaults standardUserDefaults]objectForKey:@"profileID"]integerValue];
    
    self.navigationController.navigationBar.hidden = YES;
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isFirstRun"];
    selectedRow = 1000;
    isBusyNow = NO;
    isPagingForCategories = NO;
    noMoreData = NO;
    self.tableArray = [[NSMutableArray alloc]init];
    tableArrayCopy = [[NSMutableArray alloc]init];
    self.likeArray = [[NSMutableArray alloc]init];
    self.favArray = [[NSMutableArray alloc]init];
        //make View
    [self makeTableViewWithYpos:64];
    [self populateTableViewArray];
    NSString *devToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    if ([devToken length] > 10) {
        [self registerUserDeviceTokenOnServer];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTable) name:@"refreshTimeLine" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(registerDeviceTokenOnServer:) name:@"registerDeviceTokenOnServer" object:nil];
    
    [self showMenuButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods
-(void)addNumber:(int)number1 withNumber:(int)number2 andCompletionHandler:(void (^)(int result))completionHandler{
    int result = number1 + number2;
    completionHandler(result);
}
- (void)makeTableViewWithYpos:(CGFloat )yPos{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, yPos, screenWidth, screenHeight - yPos - 55)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
        //make menu items and view
    menuView = [[UIView alloc]initWithFrame:CGRectMake(0, 70, screenWidth ,0)];
    menuView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:menuView];
    menuScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(menuView.frame.origin.x, 0, menuView.frame.size.width, menuView.frame.size.height)];
    [menuView addSubview:menuScrollView];
    selectImageView = [[UIImageView alloc]initWithFrame:CGRectMake(menuView.frame.size.width - 40, 40, 25, 25)];
    selectImageView.image = [UIImage imageNamed:@"following.png"];
    [menuScrollView addSubview:selectImageView];
}

- (LoginViewController *)LoginViewController{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *view = (LoginViewController *)[story instantiateViewControllerWithIdentifier:@"LoginViewController"];
    return view;
}

- (void)pushToLoginView{
    [self presentViewController:[self LoginViewController] animated:YES completion:nil];
}

- (void)refreshTable{
    page = 0;
    if ([self.tableArray count] > 0) {
        NSDictionary *landingPageDic = [self.tableArray myObjectAtIndex:1];
        NSInteger dateNumber = [landingPageDic.LPTVPublish_date integerValue];
        dateNumber += 1;
        
        if ([Networking hasConnectivity]) {
            [self performSelectorOnMainThread:@selector(showProgressHUD) withObject:nil waitUntilDone:NO];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"isFirstRun"];
            [self fetchPostsFromServerWithPage:page];
        } else {
            [refreshControl endRefreshing];
        }
    }else{
        if ([Networking hasConnectivity]) {
            self.tableArray = [[NSMutableArray alloc]init];
            [self performSelectorOnMainThread:@selector(showProgressHUD) withObject:nil waitUntilDone:NO];
                //[self fetchPostsFromServerWithRequest:@"new" WithDate:@""];
            [self fetchPostsFromServerWithPage:page];
        } else {
            [refreshControl endRefreshing];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:NSLocalizedString(@"offline", @"")
                                          preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"OK", @"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                 
                                 }];
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
    
}

- (void)populateTableViewArray{
    
        //datebase
    [Database initDB];
    self.tableArray = [[NSMutableArray alloc]init];
        //self.tableView.dataSource = nil;
    NSArray *array = [Database selectFromLandingPageWithFilePath:[Database getDbFilePath]];
    if ([array count] > 0) {
        for (NSDictionary *dic in array) {
            [self.tableArray addObject:dic];
        }
        
            //this is for first row, new post
        [self.tableArray insertObject:@"" atIndex:0];
        
        [self.tableView reloadData];
        NSString *selectedRowFromPush = [[NSUserDefaults standardUserDefaults]objectForKey:@"selectedRow"];
        if ([selectedRowFromPush length] > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[selectedRowFromPush integerValue] inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"selectedRow"];
        }
        self.tableView.scrollsToTop = YES;
            //NSString *isFirstRun = [[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstRun"];
        if ([_tableArray count] == 0/*[isFirstRun length] == 0*/) {
            if ([Networking hasConnectivity]) {
                    //[self performSelectorOnMainThread:@selector(showProgressHUD) withObject:nil waitUntilDone:NO];
                NSString *categoryId = [[NSUserDefaults standardUserDefaults]objectForKey:@"categoryId"];
                if ([categoryId length] > 0) {
                        //[self fetchPostsFromServerWithCategory:categoryId WithRequest:@"" WithDate:@""];
                    [self fetchPostsFromServerWithPage:page];
                } else {
                        //[self fetchPostsFromServerWithRequest:@"" WithDate:@""];
                    [self fetchPostsFromServerWithPage:page];
                }
            } else {
                
            }
        }else{
            [self.tableView reloadData];
            self.tableView.scrollsToTop = YES;
        }
    }else{
        if ([Networking hasConnectivity]) {
            [self performSelectorOnMainThread:@selector(showProgressHUD) withObject:nil waitUntilDone:NO];
                //[self fetchPostsFromServerWithRequest:@"new" WithDate:@""];
            [self fetchPostsFromServerWithPage:page];
        } else {
            
        }
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)showProgressHUD {
        //[ProgressHUD show:NSLocalizedString(@"retrievingdata", @"") Interaction:NO];
}

- (void)menuButtonAction {
        //[self showHideRightMenu];
    disableTableView = !disableTableView;
    self.tableView.userInteractionEnabled = disableTableView;
    [[NSNotificationCenter defaultCenter]postNotificationName:@"toggleMenuVisibility" object:nil];
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
    
    NSDictionary *landingPageDic = [ self.tableArray myObjectAtIndex:btn.tag];
    NSMutableDictionary *landingPageDic2 = [[NSMutableDictionary alloc]initWithDictionary:landingPageDic];
    
    NSInteger likes = [landingPageDic2.LPTVLikes_count integerValue];
    if ([landingPageDic2.LPTVLiked integerValue] == 0) {
        likes++;
        [landingPageDic2 setObject:[NSString stringWithFormat:[NSString stringWithFormat:@"%d", 1], likes] forKey:@"liked"];
            //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPTVPostID];
        
    }else{
        likes--;
        [landingPageDic2 setObject:[NSString stringWithFormat:[NSString stringWithFormat:@"%d", 0], likes] forKey:@"liked"];
            //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPTVPostID];
        
    }
    
    [landingPageDic2 setObject:[NSString stringWithFormat:@"%ld", (long)likes] forKey:@"likesCount"];
        //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%@", [[tempDic myObjectForKey:@"data"] myObjectForKey:@"count"]] field:@"likes_count" postId:landingPageDic2.LPTVPostID];
    
    [self.tableArray replaceObjectAtIndex:btn.tag withObject:landingPageDic2];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)saveImageIntoDocumetsWithImage:(UIImage*)image withName:(NSString*)imageName{
    NSData *imageData = UIImagePNGRepresentation(image); //convert image into .png format.
    NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
    NSString *appDocumentsDirectory = [DocumentDirectoy getDocuementsDirectory];
    NSString *fullPath = [appDocumentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", imageName]]; //add our image to the path
    BOOL resultSave = [fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
    if (resultSave) {
            ////NSLog(@"image saved");
    } else {
            ////NSLog(@"error saving image");
    }
}

- (UIImage *)loadImageFilesWithName:(NSString *)imageName{
    documentsDirectory = [DocumentDirectoy getDocuementsDirectory];
    
    UIImageView *tempImageView = [[UIImageView alloc]init];
    tempImageView.image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, imageName]];
    return tempImageView.image;
}

- (void)drawCircleOnView:(UIView *)aView withRadius:(NSInteger)radius{
        //int radius = 100;
    CAShapeLayer *circle = [CAShapeLayer layer];
        // Make a circular shape
    circle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 2.0*radius, 2.0*radius)
                                             cornerRadius:radius].CGPath;
        // Center the shape in self.view
    circle.position = CGPointMake(CGRectGetMidX(self.view.frame)-radius,
                                  CGRectGetMidY(self.view.frame)-radius);
    
        // Configure the apperence of the circle
    circle.fillColor = [UIColor clearColor].CGColor;
    circle.strokeColor = [UIColor blackColor].CGColor;
    circle.lineWidth = 5;
    
        // Add to parent layer
    [aView.layer addSublayer:circle];
    
        // Configure animation
    CABasicAnimation *drawAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    drawAnimation.duration            = 10.0; // "animate over 10 seconds or so.."
    drawAnimation.repeatCount         = 1.0;  // Animate only once..
    
        // Animate from no part of the stroke being drawn to the entire stroke being drawn
    drawAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    drawAnimation.toValue   = [NSNumber numberWithFloat:1.0f];
    
        // Experiment with timing to get the appearence to look the way you want
    drawAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
        // Add the animation to the circle
    [circle addAnimation:drawAnimation forKey:@"drawCircleAnimation"];
}

#pragma mark -custom cell delegate
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
    NSDictionary *landingPageDic = [ self.tableArray myObjectAtIndex:btn.tag];
    NSDictionary *tempDic = [[NSDictionary alloc]initWithObjectsAndKeys:landingPageDic.LPTVPostID, @"id", [NSNumber numberWithInteger:btn.tag], @"index", nil];
    [_favArray addObject:tempDic];
    [self favOnServerWithID:landingPageDic.LPTVPostID];
    
}

- (void)likeButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    UIImage *offImage = [UIImage imageNamed:@"like icon"];
    UIImage *onImage = [UIImage imageNamed:@"like"];
    UIImage *currentImage = [btn imageForState:UIControlStateNormal];
    
    NSDictionary *landingPageDic = [ self.tableArray myObjectAtIndex:btn.tag];
    NSMutableDictionary *landingPageDic2 = [[NSMutableDictionary alloc]initWithDictionary:landingPageDic];
    NSDictionary *tempDic = [[NSDictionary alloc]initWithObjectsAndKeys:landingPageDic2.LPTVPostID, @"id", [NSNumber numberWithInteger:btn.tag], @"index", nil];
    [_likeArray addObject:tempDic];
    [self likeOnServerWithID:landingPageDic2.LPTVPostID];
    
    NSInteger likes = [landingPageDic2.LPTVLikes_count integerValue];
    if ([landingPageDic2.LPTVLiked integerValue] == 0) {
        likes++;
            //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPTVPostID];
        
    }else{
        if (likes == 0) {
            likes = 0;
        }else{
            likes--;
        }
        
            //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:landingPageDic2.LPTVPostID];
        
    }
    
    [landingPageDic2 setObject:[NSString stringWithFormat:@"%ld", (long)likes] forKey:@"likesCount"];
    
    if ([UIImagePNGRepresentation(offImage) isEqualToData:UIImagePNGRepresentation(currentImage)]) {
        [btn setImage:onImage forState:UIControlStateNormal];
        [landingPageDic2 setObject:[NSString stringWithFormat:@"%d",1] forKey:@"liked"];
        
    }else{
        [btn setImage:offImage forState:UIControlStateNormal];
        [landingPageDic2 setObject:[NSString stringWithFormat:@"%d", 0] forKey:@"liked"];
    }
    
        //[Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%@", [[tempDic myObjectForKey:@"data"] myObjectForKey:@"count"]] field:@"likes_count" postId:landingPageDic2.LPTVPostID];
    
    [self.tableArray replaceObjectAtIndex:btn.tag withObject:landingPageDic2];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}
- (void)commentImageViewAction:(UITapGestureRecognizer *)tap{
        //NSLog(@"%ld", (long)tap.view.tag);
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentViewController *view = (CommentViewController *)[story instantiateViewControllerWithIdentifier:@"CommentViewController"];
    view.postId = [[[_tableArray objectAtIndex:tap.view.tag]objectForKey:@"postId"]integerValue];
    view.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)videoButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = [ self.tableArray myObjectAtIndex:btn.tag];
        //NSLog(@"%@", [dic myObjectForKey:@"videoUrl"]);
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoPlayerViewController *view = (VideoPlayerViewController *)[story instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    view.urlString = [dic myObjectForKey:@"videoUrl"];
    view.titleString = [dic myObjectForKey:@"title"];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)audioButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    NSDictionary *dic = [ self.tableArray myObjectAtIndex:btn.tag];
        //NSLog(@"%@", [dic myObjectForKey:@"audioUrl"]);
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    VideoPlayerViewController *view = (VideoPlayerViewController *)[story instantiateViewControllerWithIdentifier:@"VideoPlayerViewController"];
    view.titleString = [dic myObjectForKey:@"title"];
    view.urlString = [dic myObjectForKey:@"audioUrl"];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)pushToNewPost{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    NewPostViewController *view = (NewPostViewController *)[story instantiateViewControllerWithIdentifier:@"NewPostViewController"];
    [self.navigationController presentViewController:view animated:YES completion:nil];
}

- (void)tapOnAuthorImage:(UITapGestureRecognizer *)tap{
    NSDictionary *tempDic = [_tableArray objectAtIndex:tap.view.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UserProfileViewController *view = (UserProfileViewController *)[story instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
    view.entityID = [tempDic.LPTVUserEntityId integerValue];//[[[tempDic myObjectForKey:@"entity"]objectForKey:@"id"]integerValue];
                                                            //view.dictionary = tempDic;
    view.nameString = tempDic.LPTVUserTitle;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)shareButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    
    NSDictionary *landingPageDic = [ self.tableArray myObjectAtIndex:btn.tag];
    
    NSString *textToShare = landingPageDic.LPTVTitle;
    NSString *textToShare2 = landingPageDic.LPTVContent;
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

#pragma mark - table view delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tableArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (IS_IPAD) {
        return screenWidth + 10;
    }else {//iphone
        if (indexPath.row == 0) {
            return 75;
        }
        NSDictionary *landingPageDic = [ self.tableArray myObjectAtIndex:indexPath.row];
        NSString *postType = landingPageDic.LPTVPostType;
        
        if (([postType isEqualToString:@"audio"])) {
            if ([landingPageDic.LPTVCoverRatio floatValue] == 1) {
                return 280 + [[landingPageDic objectForKey:@"content"] getHeightOfString] - 50;
            } else {
                return 200 + [[landingPageDic objectForKey:@"content"] getHeightOfString] - 50 + (screenWidth / [landingPageDic.LPTVCoverRatio floatValue]);
            }
            
        }
        if (([postType isEqualToString:@"document"]) && ([landingPageDic.LPTVImageUrl length] <= 6)) {
            if ([landingPageDic.LPTVCoverRatio floatValue] == 1) {
                return 200 + [[landingPageDic objectForKey:@"content"] getHeightOfString] - 50;
            } else {
                return 120 + [[landingPageDic objectForKey:@"content"] getHeightOfString] - 50 + (screenWidth / [landingPageDic.LPTVCoverRatio floatValue]);
            }
            
        }
        
        if ([landingPageDic.LPTVImageUrl length] == 0 || (([landingPageDic.LPTVImageUrl isEqualToString:@"(null)"]) && ([landingPageDic.LPTVVideoUrl length] <= 6)) ) {
            return 210 + [[landingPageDic objectForKey:@"content"] getHeightOfString] - 60;
        }
        
            //if ([landingPageDic.LPTVCoverRatio floatValue] == 1) {
            //    return screenWidth +  [[landingPageDic objectForKey:@"content"] getHeightOfString] - 50;
            //} else {
        return screenWidth +  [[landingPageDic objectForKey:@"content"] getHeightOfString] - 150 + (screenWidth / [landingPageDic.LPTVCoverRatio floatValue]) - 10;
            //}
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    id cellToReturn=nil;
    if (indexPath.row == 0) {
        
        NewPostCell *cell = (NewPostCell *)[[NewPostCell alloc]
                                            initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cellToReturn = cell;
        return cellToReturn;
    }
    
    if (indexPath.row < 1) {
        self.tableView.separatorColor = [UIColor clearColor];
    } else {
        self.tableView.separatorColor = [UIColor lightGrayColor];
    }
    NSDictionary *landingPageDic = [ self.tableArray myObjectAtIndex:indexPath.row];
    NSString *postType = landingPageDic.LPTVPostType;
    
    if ([[landingPageDic allKeys]count] == 0) {
        LandingPageCustomCellAudio *cell = (LandingPageCustomCellAudio *)[[LandingPageCustomCellAudio alloc]
                                                                          initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        cell.contentLabel.text = @"هیچ پستی وجود ندارد";
        cellToReturn = cell;
    }
    
        //audio
    if ([postType isEqualToString:@"audio"]) {
        LandingPageCustomCellAudio *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
        if (cell == nil)
            cell = (LandingPageCustomCellAudio *)[[LandingPageCustomCellAudio alloc]
                                                  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell1"];
        if ([self.tableArray count] > 0) {
            cell.tag = indexPath.row;
            cell.delegate = self;
        }
        cellToReturn = [cell setEntity:landingPageDic indexPath:indexPath];
            //video
    }else if ([postType isEqualToString:@"video"]){
        LandingPageCustomCellVideo *cell = [tableView dequeueReusableCellWithIdentifier:@"cell2"];
        if (cell == nil)
            cell = (LandingPageCustomCellVideo *)[[LandingPageCustomCellVideo alloc]
                                                  initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell2"];
        if ([self.tableArray count] > 0) {
            cell.tag = indexPath.row;
                //cell.delegate = self;
        }
        cellToReturn = [cell setEntity:landingPageDic indexPath:indexPath];
            //other post type
    }else{
        NSString *cellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
        LandingPageCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell3"];
        if (cell == nil){
            if (([landingPageDic.LPTVImageUrl length] > 10) || ([landingPageDic.LPImageUrl length] > 10)) {
                cell = (LandingPageCustomCell *)[[LandingPageCustomCell alloc]
                                                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier isPostImage:YES height:[[landingPageDic objectForKey:@"content"] getHeightOfString] coverRatio:[landingPageDic.LPTVCoverRatio floatValue]];
            }else{
                cell = (LandingPageCustomCell *)[[LandingPageCustomCell alloc]
                                                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier isPostImage:NO height:[[landingPageDic objectForKey:@"content"] getHeightOfString] coverRatio:[landingPageDic.LPTVCoverRatio floatValue]];
            }
        }
        if ([self.tableArray count] > 0) {
            cell.tag = indexPath.row;
            cell.delegate = self;
        }
        cellToReturn = [cell setEntity:landingPageDic indexPath:indexPath];
    }
    return cellToReturn;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self pushToNewPost];
    } else {
        
        NSDictionary *dic = [_tableArray objectAtIndex:indexPath.row];
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LandingPageDetailViewController *view = (LandingPageDetailViewController *)[story instantiateViewControllerWithIdentifier:@"LandingPageDetailViewController"];
        view.dictionary = dic;
        [self.navigationController pushViewController:view animated:YES];
    }
}
#pragma mark - Connection
- (void)fetchPostsFromServerWithPage:(NSInteger)pageOf{
    if (!isBusyNow) {
        isBusyNow = YES;
        [refreshControl endRefreshing];
        [ProgressHUD show:@""];
        NSDictionary *params = @{
                                 @"page":[NSNumber numberWithInteger:pageOf],
                                 };
        [Networking formDataWithPath:@"timeline" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
            [ProgressHUD dismiss];
            isBusyNow = NO;
            [Database initDB];
            
                //check if this view, landingpage, is loaded from scratch
            NSString *isFirstRun = [[NSUserDefaults standardUserDefaults]objectForKey:@"isFirstRun"];
            if ([isFirstRun length] == 0) {
                [Database initDB];
                [Database deleteFavoriteWithFilePath:[Database getDbFilePath]];
                int result = [Database deleteLandingPageWithFilePath:[Database getDbFilePath]];
                if (result == 0) {
                    [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"isFirstRun"];
                }
            }
            
            for (NSDictionary *post in [responseDict myObjectForKey:@"data"]) {
                [tableArrayCopy addObject:post];
                [Database insertIntoLandingPageWithFilePath:[Database getDbFilePath] postID:post.LPPostID title:post.LPTitle content:post.LPContent contentSummary:post.LPContentSummary contentHTML:post.LPContentHTML imageUrl:post.LPImageUrl publish_date:post.LPPublish_date categoryId:post.LPCategoryId categoryName:post.LPCategoryName userAvatarUrl:post.LPUserAvatarUrl userTitle:post.LPUserTitle userJobTitle:post.LPUserJobTitle userPageId:post.LPUserPageId userEntity:post.LPUserEntity userEntityId:post.LPUserEntityId likes_count:[NSString stringWithFormat:@"%ld",(long)post.LPLikes_count] recommends_count:post.LPRecommends_count favorites_count:post.LPFavorites_count liked:post.LPLiked favorite:post.LPFavorite recommended:post.LPRecommended tags:post.LPTags postType:post.LPPostType audioUrl:post.LPAudioUrl videoUrl:post.LPVideoUrl audioSize:post.LPAudioSize videoSize:post.LPVideoSize videoSnapShot:post.LPVideoSnapshot votingOptions:post.LPvotingOptions coverRatio:post.LPCoverRatio];
                
                    //copy fav items into favorite table
                if ([post.LPFavorite integerValue] == 1) {
                    [Database copyLandingPageIntoFavoriteWithFilePath:[Database getDbFilePath] postID:post.LPPostID];
                }
            }
            [Database deleteDuplicateDataLandingPageWithFilePath:[Database getDbFilePath]];
            [Database updateURLLandingPageTable:[Database getDbFilePath]];
            isBusyNow = NO;
            
            if ([[responseDict myObjectForKey:@"data"]count] > 0) {
                [self populateTableViewArray];
            }else{
                noMoreData = YES;
            }
        } failure:^(NSError * _Nonnull error) {
            isBusyNow = NO;
            [ProgressHUD dismiss];
            [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
        }];
    }
}
- (void)likeOnServerWithID:(NSString *)idOfPost{
    NSDictionary *params = @{@"model":@"post",
                             @"id":[NSString stringWithFormat:@"%@", idOfPost]
                             };
    [Networking formDataWithPath:@"social_activity/like" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        if ([[[responseDict myObjectForKey:@"data"]objectForKey:@"status"] isEqualToString:@"+"]) {
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_likeArray count]; i++) {
                NSDictionary *likeDic = [_likeArray objectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            if (idOfTargetDelete < [_likeArray count]) {
                [_likeArray removeObjectAtIndex:idOfTargetDelete];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"liked" postId:idOfPost];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:[NSString stringWithFormat:@"%@", [[responseDict myObjectForKey:@"data"]objectForKey:@"count"]] field:@"likes_count" postId:idOfPost];
                
                [self populateTableViewArray];
            }
        }else{//status = "-"
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_likeArray count]; i++) {
                NSDictionary *likeDic = [_likeArray objectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            [_likeArray removeObjectAtIndex:idOfTargetDelete];
        }
        
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
        NSInteger idOfTargetDelete = 1000;
        NSInteger idOfRow = 1000;
        for (int i = 0; i < [_likeArray count]; i++) {
            NSDictionary *likeDic = [_likeArray objectAtIndex:i];
            if ([idOfPost integerValue] == [[likeDic myObjectForKey:@"id"]integerValue]) {
                idOfTargetDelete = i;
                idOfRow = [[likeDic myObjectForKey:@"index"]integerValue];
                break;
            }
        }
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:idOfRow inSection:0];
        [self rollbackLikeButtonActionForIndexPath:indexpath];
    }];
}

- (void)favOnServerWithID:(NSString *)idOfPost{
    NSDictionary *params = @{@"model":@"post",
                             @"id":[NSString stringWithFormat:@"%@", idOfPost]
                             };
    [Networking formDataWithPath:@"social_activity/favorite" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        if ([[[responseDict myObjectForKey:@"data"]objectForKey:@"status"] isEqualToString:@"+"]) {
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_favArray count]; i++) {
                NSDictionary *likeDic = [_favArray objectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            if (idOfTargetDelete < [_favArray count]) {
                [_favArray removeObjectAtIndex:idOfTargetDelete];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"1" field:@"favorite" postId:idOfPost];
                    //copy fav items into favorite table
                [Database copyLandingPageIntoFavoriteWithFilePath:[Database getDbFilePath] postID:idOfPost];
                
                [self populateTableViewArray];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idOfRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }else if ([[[responseDict myObjectForKey:@"data"]objectForKey:@"status"] isEqualToString:@"-"]){//status = "-"
            NSInteger idOfTargetDelete = 1000;
            NSInteger idOfRow = 1000;
            for (int i = 0; i < [_favArray count]; i++) {
                NSDictionary *likeDic = [_favArray objectAtIndex:i];
                if ([idOfPost integerValue] == [[likeDic myObjectForKey:@"id"]integerValue]) {
                    idOfTargetDelete = i;
                    idOfRow = [[likeDic myObjectForKey:@"index"]integerValue];
                    break;
                }
            }
            if (idOfTargetDelete < [_favArray count]) {
                [_favArray removeObjectAtIndex:idOfTargetDelete];
                [Database updateLandingPageWithFilePath:[Database getDbFilePath] SetValue:@"0" field:@"favorite" postId:idOfPost];
                    //delete fav item from favorite
                [Database deleteFavoriteWithFilePath:[Database getDbFilePath] withID:idOfPost];
                [self populateTableViewArray];
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idOfRow inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
    } failure:^(NSError * _Nonnull error) {
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
        NSInteger idOfTargetDelete = 1000;
        NSInteger idOfRow = 1000;
        for (int i = 0; i < [_favArray count]; i++) {
            NSDictionary *likeDic = [_favArray objectAtIndex:i];
            if ([idOfPost integerValue] == [[likeDic myObjectForKey:@"id"]integerValue]) {
                idOfTargetDelete = i;
                idOfRow = [[likeDic myObjectForKey:@"index"]integerValue];
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

- (void)registerDeviceTokenOnServer:(NSNotification *)notif{
    NSString *deviceToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceToken"];
    NSInteger userID = [GetUsernamePassword getUserId];
    if ([deviceToken length] == 0) {
        return;
    }
    if (userID == 0) {
        userID = 0;
    }
    NSDictionary *params = @{@"push_key":deviceToken,
                             @"user_id":[NSNumber numberWithInteger:userID],
                             @"type":@"apple",
                             @"channel_id":@"14",/*Behsa clinic channel_id*/
                             @"version_name":@"1.0",
                             @"imei": UDID
                             };
    NSString *url = @"http://notifpanel.yarima.co/web_services/push_notification/register_device";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.requestSerializer.timeoutInterval = 45;;
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *operation, id responseObject) {
        NSDictionary *tempDic = (NSDictionary *)responseObject;
        if ([[tempDic myObjectForKey:@"success"]integerValue] == 1) {
            [[NSUserDefaults standardUserDefaults]setObject:@"YES" forKey:@"registerDeviceToken"];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        [self registerDeviceTokenOnServer:nil];
    }];
}

#pragma mark - get notifications
- (void)getNotificationsFromServer{
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    NSString *mobile = [defualt objectForKey:@"mobile"];
    NSString *password = [defualt objectForKey:@"password"];
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BaseURL, @"notifications"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if ([mobile length] == 0) {
        mobile = @"";
    }
    
    if ([password length] == 0) {
        password = @"";
    }
    NSDictionary *params = @{
                             @"username":mobile,
                             @"password":password,
                             @"debug":@"1"
                             };
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        
        if ([[dict myObjectForKey:@"has_notification"]integerValue] > 0) {
            [self saveNotif:nil];
        }
            ////NSLog(@"%@", dict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD dismiss];
    }];
    
}

- (void)pushToConsultationList{
    [self performSegueWithIdentifier:@"fromHomeView" sender:nil];
}

- (IBAction)saveNotif:(id)sender
{
    UIMutableUserNotificationAction *notificationAction1 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction1.identifier = @"Accept";
    notificationAction1.title = @"مشاهده";
    notificationAction1.activationMode = UIUserNotificationActivationModeForeground;
    notificationAction1.destructive = NO;
    notificationAction1.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *notificationAction2 = [[UIMutableUserNotificationAction alloc] init];
    notificationAction2.identifier = @"Reject";
    notificationAction2.title = @"بعدا";
    notificationAction2.activationMode = UIUserNotificationActivationModeBackground;
    notificationAction2.destructive = YES;
    notificationAction2.authenticationRequired = YES;
    
    UIMutableUserNotificationCategory *notificationCategory = [[UIMutableUserNotificationCategory alloc] init];
    notificationCategory.identifier = @"Arash";
    [notificationCategory setActions:@[notificationAction1,notificationAction2] forContext:UIUserNotificationActionContextDefault];
    [notificationCategory setActions:@[notificationAction1,notificationAction2] forContext:UIUserNotificationActionContextMinimal];
    NSSet *categories = [NSSet setWithObjects:notificationCategory, nil];
    UIUserNotificationType notificationType = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:notificationType categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
    
        // New for iOS 8 - Register the notifications
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    UILocalNotification *notification = [[UILocalNotification alloc] init];
        //[self setNotificationTypesAllowed];
        //notification.fireDate = [NSDate date];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = 0;
    notification.category = @"Arash";
    notification.alertBody = @"به سوال شما پاسخ داده شده است. لطفا چک کنید.";
        //notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
        // this will schedule the notification to fire at the fire date
        //[[UIApplication sharedApplication] scheduleLocalNotification:notification];
        // this will fire the notification right away, it will still also fire at the date we set
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}

- (void)registerUserDeviceTokenOnServer{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BaseURL, @"push_notification/set_user"];
    NSUserDefaults *defualt = [NSUserDefaults standardUserDefaults];
    NSInteger user_id = [GetUsernamePassword getUserId];
    NSString *devToken = [defualt objectForKey:@"deviceToken"];
    
    if (user_id == 0) {
        user_id = 0;
    }
    
    if ([devToken length] == 0) {
        devToken = @"";
    }
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *params = @{@"push_key":devToken,
                             @"user_id":[NSNumber numberWithInteger:user_id],
                             @"type":@"apple",
                             @"channel_id":@"14",
                             @"version_name":@"1.0",
                             @"imei": UDID
                             };
    
    [manager POST:urlString parameters:params progress:nil success:^(NSURLSessionTask *operation, id responseObject) {
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    float bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
    if (bottomEdge >= scrollView.contentSize.height) {
            // we are at the end
        page++;
        [self fetchPostsFromServerWithPage:page];
    }
}

@end
