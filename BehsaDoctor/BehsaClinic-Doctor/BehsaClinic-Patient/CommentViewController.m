//
//  CommentViewController.m
//  MSN
//
//  Created by Yarima on 11/23/16.
//  Copyright © 2016 Arash. All rights reserved.
//

#import "CommentViewController.h"
#import "Header.h"
#import <AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "GetUsernamePassword.h"
#import "CommentCustomCell.h"
#import <UIImageView+AFNetworking.h>
#import "NSDictionary+LandingPage.h"
#import "CustomButton.h"
#import "ReportAbuseViewController.h"
#import "CommentReplyViewController.h"
#import "TimeAgoViewController.h"
#define Height_QuestionView 40
#define Height_FOR_REPLY 30
@interface CommentViewController ()<UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, CommentCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *tableArray;
    UIView *replyViewBG;
    UIButton *sendButton;
    UITextView *questionTextView;
    CGFloat lastHeightOfQuestionTextView;
    NSInteger profileID;
    UILabel *noResultLabelPost;
}
@end

@implementation CommentViewController

- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ////NSLog(@"%ld", (long)_postId);
    profileID = [GetUsernamePassword getUserId];
    [self makeTopBar];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, screenWidth, screenHeight - 70 - Height_QuestionView) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.estimatedRowHeight = 44.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:_tableView];
    
    replyViewBG = [[UIView alloc]initWithFrame:CGRectMake(0, screenHeight - Height_QuestionView, screenWidth, Height_QuestionView)];
    replyViewBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:replyViewBG];
    sendButton = [CustomButton initButtonWithTitle:NSLocalizedString(@"ارسال", @"") withTitleColor:[UIColor whiteColor] withBackColor:[UIColor colorWithRed:92/255.0 green:134/255.0 blue:217/255.0 alpha:1.0] isRounded:NO withFrame:CGRectMake(screenWidth - 60, 0, 60, Height_QuestionView)];
    [sendButton addTarget:self action:@selector(sendButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [replyViewBG addSubview:sendButton];
    
    questionTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, screenWidth - 60, Height_QuestionView)];
    questionTextView.font = FONT_NORMAL(12);
    questionTextView.tag = 534;
    questionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    questionTextView.delegate = self;
    questionTextView.layer.borderColor = [UIColor grayColor].CGColor;
    questionTextView.layer.borderWidth = 1.0;
    questionTextView.textColor = [UIColor grayColor];
    questionTextView.contentSize = CGSizeMake(screenWidth, 1000);
    [questionTextView setScrollEnabled:YES];
    questionTextView.text = NSLocalizedString(@"نظر خود را بنویسید", @"");
    questionTextView.textAlignment = NSTextAlignmentRight;
    [replyViewBG addSubview:questionTextView];
    lastHeightOfQuestionTextView = 40;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHideHandler:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    tableArray =[[NSMutableArray alloc]init];
    [self fetchCommentsWithID:_postId];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - custom methods
- (void)makeTopBar{
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 70)];
    topView.backgroundColor = MAIN_COLOR;
    
    topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTextView)];
    [topView addGestureRecognizer:tap];
    [self.view addSubview:topView];
    
    CGFloat topViewHeight = topView.frame.size.height;
    
    UILabel *titleLabel =[[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2 - 100, topViewHeight/2 - 15, 200, 40)];
    titleLabel.font = FONT_NORMAL(16);
    titleLabel.text = NSLocalizedString(@"نظرات کاربران", @"");
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:titleLabel];
    
    UIButton *backButtonImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 14 , 45, 45)];
    [backButtonImg setBackgroundImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backButtonImg addTarget:self action:@selector(backButtonImgAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButtonImg];
}

- (void)dismissTextView{
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = replyViewBG.frame;
        rect.origin.y = screenHeight - Height_QuestionView;
        [replyViewBG setFrame:rect];
        [questionTextView resignFirstResponder];
    }];
}

- (void)sendButtonAction{
    [self sendCommentsWithID:_postId];
}

- (void)backButtonImgAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissTextField{
    
}

#pragma mark - comment cell delegate
- (void)replyButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    CommentEntity *entity = [tableArray myObjectAtIndex:btn.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommentReplyViewController *view = (CommentReplyViewController *)[story instantiateViewControllerWithIdentifier:@"CommentReplyViewController"];
    view.commentId = [entity.dictionary.LPPostID integerValue];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)reportButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    CommentEntity *entity = [tableArray myObjectAtIndex:btn.tag];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ReportAbuseViewController *view = (ReportAbuseViewController *)[story instantiateViewControllerWithIdentifier:@"ReportAbuseViewController"];
    view.idOfProfile = [entity.dictionary.LPPostID integerValue];
    view.model = @"comment";
    [self presentViewController:view animated:YES completion:nil];
}

- (void)deleteButtonAction:(id)sender{
    UIButton *btn = (UIButton *)sender;
    CommentEntity *entity = [tableArray myObjectAtIndex:btn.tag];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"آیا از حذف کامنت مطمئن هستید؟" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"حذف" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [self deleteCommentsWithID:[[entity.dictionary myObjectForKey:@"id"]integerValue]];
    }];
    [alert addAction:deleteAction];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - connection

- (void)fetchCommentsWithID:(NSInteger)idOfPost{
    _tableView.userInteractionEnabled = NO;
    [ProgressHUD show:@""];
    NSDictionary *params = @{@"model":@"post",
                             @"foreign_key":[NSNumber numberWithInteger:idOfPost],
                             @"offset":[NSNumber numberWithInteger:0],
                             @"limit":[NSNumber numberWithInteger:200]
                             };
    [Networking formDataWithPath:@"social_activity/comments" parameters:params success:^(NSDictionary * _Nonnull responseDict) {
        [ProgressHUD dismiss];
        _dictionary = [responseDict myObjectForKey:@"data"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"updateCommentsCount"
                                                           object:[NSNumber numberWithInteger:
                                                                   [[_dictionary myObjectForKey:@"count"]integerValue]]];
        for (NSDictionary *dic in [_dictionary myObjectForKey:@"comments"]) {
            CommentEntity *entity = [CommentEntity new];
            entity.dictionary = dic;
            entity.profileID = profileID;
            [tableArray addObject:entity];
            
            //check for reply comments, inline comments
            if ([[dic myObjectForKey:@"comments"]count]  > 0) {
                for (NSDictionary *dic2 in [dic myObjectForKey:@"comments"]) {
                    CommentEntity *entity = [CommentEntity new];
                    entity.dictionary = dic2;
                    entity.profileID = profileID;
                    NSLog(@"%@", entity.dictionary.LPUserAvatarUrl);
                    [tableArray addObject:entity];
                }
            }
        }
        
        [noResultLabelPost removeFromSuperview];
        
        if ([tableArray count] == 0) {
            noResultLabelPost = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 220, 10, 200,  25)];
            noResultLabelPost.font = FONT_NORMAL(13);
            noResultLabelPost.text = @"تاکنون نظری ثبت نشده است";
            noResultLabelPost.minimumScaleFactor = 0.7;
            noResultLabelPost.textColor = [UIColor blackColor];
            noResultLabelPost.textAlignment = NSTextAlignmentRight;
            noResultLabelPost.adjustsFontSizeToFitWidth = YES;
            [_tableView addSubview:noResultLabelPost];
        }
        [_tableView reloadData];
        _tableView.userInteractionEnabled = YES;

    } failure:^(NSError * _Nonnull error) {
        _tableView.userInteractionEnabled = YES;
        [ProgressHUD dismiss];
        [[AZJAlertView sharedInstance]showMessage:error.localizedDescription withType:AZJAlertMessageTypeError];
    }];
}

- (void)sendCommentsWithID:(NSInteger)idOfPost{
    [self resignQuestionTextView];
    [ProgressHUD show:@""];
    NSDictionary *params = @{@"model":@"post",
                             @"id":[NSNumber numberWithInteger:idOfPost],
                             @"comment":questionTextView.text
                             };
    NSString *url = [NSString stringWithFormat:@"%@social_activity/comment", BaseURL];
    AFHTTPSessionManager *manager = [NetworkManager shareManager2];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [ProgressHUD dismiss];
        NSDictionary *resDic  = (NSDictionary *)responseObject;
        if ([[resDic myObjectForKey:@"success"]integerValue] == 1) {
            questionTextView.text = @"";
            tableArray = [[NSMutableArray alloc]init];
            [self fetchCommentsWithID:_postId];
        } else {
            [[AZJAlertView sharedInstance]showMessage:[NSString stringWithFormat:@"%@", [resDic myObjectForKey:@"message"]] withType:AZJAlertMessageTypeError];
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

- (void)deleteCommentsWithID:(NSInteger)idOfPost{
    [self resignQuestionTextView];
    [ProgressHUD show:@""];
    NSDictionary *params = @{@"id":[NSNumber numberWithInteger:idOfPost]
                             };
    NSString *url = [NSString stringWithFormat:@"%@social_activity/delete_comment", BaseURL];
    AFHTTPSessionManager *manager = [NetworkManager shareManager2];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        [ProgressHUD dismiss];
        NSDictionary *resDic = (NSDictionary *)responseObject;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@" حذف کامنت" message:[resDic myObjectForKey:@"message"]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"بازگشت" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            // ////NSLog(@"You pressed button OK");
        }];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        tableArray =[[NSMutableArray alloc]init];
        [self fetchCommentsWithID:_postId];
        
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

#pragma mark - tableview delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentEntity *entity = [tableArray myObjectAtIndex:indexPath.row];
    CGFloat height = 0;
    if ([entity.dictionary count] == 9) {
        height =  [[entity.dictionary myObjectForKey:@"comment"] getHeightOfString];
        if (height < 25) {
            return 20 + Height_FOR_REPLY;
        } else {
            height = height + 25 + Height_FOR_REPLY + 15;
        }
    }else if ([entity.dictionary count] == 8){
        height = [[entity.dictionary myObjectForKey:@"comment"] getHeightOfString];
        if (height < 25) {
            return 20 + Height_FOR_REPLY;
        } else {
            height = height + 25 + Height_FOR_REPLY;
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CommentCustomCell *cell = (CommentCustomCell *)[[CommentCustomCell alloc]
                                                    initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.delegate = self;
    [cell setEntity:[tableArray myObjectAtIndex:indexPath.row] indexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - textview delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (textView.tag == 534) {
        if ([textView.text isEqualToString:NSLocalizedString(@"enteryouText", @"")]) {
            textView.text = @"";
            textView.textColor = [UIColor blackColor];
        }
        if( [text rangeOfCharacterFromSet:[NSCharacterSet newlineCharacterSet]].location != NSNotFound ) {
            CGRect rect = textView.frame;
            if (rect.size.height <= screenHeight * 0.3){
                rect.size.height += 25;
                lastHeightOfQuestionTextView = rect.size.height;
                //rect.origin.y -= 25;
                [textView setFrame:rect];
                
                rect = sendButton.frame;
                rect.origin.y += 25;
                [sendButton setFrame:rect];
                
//                rect = attachButton.frame;
//                rect.origin.y += 25;
//                [attachButton setFrame:rect];
                
                rect = replyViewBG.frame;
                rect.size.height += 25;
                rect.origin.y -= 25;
                [replyViewBG setFrame:rect];
            }else
                NSLog(@"this is enough frame");
        }
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 534) {
        if ([textView.text isEqualToString:NSLocalizedString(@"نظر خود را بنویسید",@"")]) {
            textView.text = @"";
        }
        [UIView animateWithDuration:0.5 animations:^{
            CGRect rect = replyViewBG.frame;
            if (IS_IPAD) rect.origin.y = screenHeight - 360;
            else rect.origin.y = screenHeight - 260;
            [replyViewBG setFrame:rect];
            
            rect = questionTextView.frame;
            rect.size.height = lastHeightOfQuestionTextView;
            if (lastHeightOfQuestionTextView > 40) {
                CGFloat numOfEnters = lastHeightOfQuestionTextView / 25;
                numOfEnters --;
                rect.origin.y = 0;//-= numOfEnters * 25;
                [questionTextView setFrame:rect];
                
                rect = sendButton.frame;
                rect.origin.y += replyViewBG.frame.size.height/2 - 25;
                [sendButton setFrame:rect];
                
//                rect = attachButton.frame;
//                rect.origin.y += replyViewBG.frame.size.height/2 - 25;
//                [attachButton setFrame:rect];
                
                rect = replyViewBG.frame;
                rect.size.height = lastHeightOfQuestionTextView + 25;
                numOfEnters --;
                rect.origin.y -= numOfEnters * 25;
                [replyViewBG setFrame:rect];
                
                rect = sendButton.frame;
                rect.origin.y = replyViewBG.frame.size.height - 65;
                [sendButton setFrame:rect];
                
//                rect = attachButton.frame;
//                rect.origin.y = replyViewBG.frame.size.height - 70;
//                [attachButton setFrame:rect];
            }
            
            [textView layoutIfNeeded];
            [textView becomeFirstResponder];
        }];
    }
}

- (void)resignQuestionTextView {
    [UIView animateWithDuration:0.5 animations:^{
        CGRect rect = replyViewBG.frame;
        rect.origin.y = screenHeight - Height_QuestionView;
        rect.size.height = Height_QuestionView;
        [replyViewBG setFrame:rect];
        
        rect = sendButton.frame;
        rect.origin.y = 0;
        [sendButton setFrame:rect];
        
//        rect = attachButton.frame;
//        rect.origin.y = replyViewBG.frame.size.height/2 - 25;
//        [attachButton setFrame:rect];
        
        //CGRectMake(attachButton.frame.size.width + attachButton.frame.origin.x + 10, 5, screenWidth - 120, 40)
        rect = questionTextView.frame;
        rect.size.height = 40;
        rect.origin.y = 0;
        [questionTextView setFrame:rect];
        [questionTextView resignFirstResponder];
    }];
}

- (void) keyboardWillHideHandler:(NSNotification *)notification {
    //show another viewcontroller here
    [self resignQuestionTextView];
}

- (void) keyboardDidHideHandler:(NSNotification *)notification {
    //show another viewcontroller here
    //[self resignQuestionTextView];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    [self resignQuestionTextView];
}

@end
