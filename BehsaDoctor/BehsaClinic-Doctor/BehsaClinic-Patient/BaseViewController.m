//
//  BaseViewController.m
//  BehsaClinic-Patient
//
//  Created by Yarima on 2/11/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
{
    UIView *topView;
}
@property(nonatomic, retain)UILabel *myTitleLabel;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    [self makeTopView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated{
    //[ProgressHUD dismiss];
}

- (void)makeTopView{
    topView = UIView.new;
    topView.backgroundColor = MAIN_COLOR;
    topView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissTextField)];
    [topView addGestureRecognizer:tap];
    [self.view addSubview:topView];
    
    UIView *superview = self.view;
    [topView makeConstraints:^(MASConstraintMaker *make) {
        make.top.greaterThanOrEqualTo(superview.top);
        make.left.equalTo(superview.left);
        make.right.equalTo(superview.right);
        make.height.equalTo(@64);
    }];
    
    _myTitleLabel = [UILabel new];
    _myTitleLabel.font = FONT_NORMAL(18);
    _myTitleLabel.numberOfLines = 1;
    _myTitleLabel.backgroundColor = [UIColor clearColor];
    _myTitleLabel.textColor = [UIColor whiteColor];
    _myTitleLabel.textAlignment = NSTextAlignmentCenter;
    [topView addSubview:_myTitleLabel];
    
    [self.myTitleLabel makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(@10);
        make.width.equalTo(topView.mas_width).offset(-100);
        make.centerX.equalTo(topView.mas_centerX);
        make.centerY.equalTo(topView.mas_centerY).offset(8);
    }];
    
}

- (void)setTitleLabel:(NSString *)title{
    _myTitleLabel.text = title;
}

- (void)dismissTextField{
    
}

- (void)addOnTopView:(UIView *)aView{
    [topView addSubview:aView];
}

- (void)showMenuButton{
    UIButton *moreButton = [CustomButton initButtonWithImage:[UIImage imageNamed:@"moreButton"] withFrame:CGRectMake(screenWidth - 40, 25, 30, 30)];
    [moreButton addTarget:self action:@selector(moreButtonAction) forControlEvents:UIControlEventTouchUpInside];
    moreButton.tintColor = [UIColor whiteColor];;
    [topView addSubview:moreButton];
}

- (void)moreButtonAction{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"لغو" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        // Cancel button tappped do nothing.
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"نیاز به شرح ملاقات" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self sharhViewController];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"علاقه مندی ها" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self favoriteViewController];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"درباره ما" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self aboutViewController];
    }]];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)aboutViewController{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *view = (AboutViewController *)[story instantiateViewControllerWithIdentifier:@"AboutViewController"];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)favoriteViewController{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FavoritesViewController *view = (FavoritesViewController *)[story instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

- (void)sharhViewController{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SharhViewController *view = (SharhViewController *)[story instantiateViewControllerWithIdentifier:@"SharhViewController"];
    [self.navigationController pushViewController:view animated:YES];
}

@end
