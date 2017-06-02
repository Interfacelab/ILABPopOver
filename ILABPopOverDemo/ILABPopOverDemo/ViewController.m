//
//  ViewController.m
//  ILABPopOverDemo
//
//  Created by Jon Gilkison on 6/2/17.
//  Copyright © 2017 interfacelab. All rights reserved.
//

#import "ViewController.h"
#import "ILABPopOverView.h"
#import "ILABPopOverViewController.h"

@interface ViewController () {
    __weak IBOutlet UIScrollView *scrollView;
    
    IBOutlet UIView *popupView;
    IBOutlet UIView *dialogPopupView;
    IBOutlet UIView *highlightPopupView;
    
    ILABPopOverViewController *highlightPopOverVC;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * 3, 0);
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:@"Show Pop Up" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showPopOver:) forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 2., CGRectGetMidY(scrollView.bounds) - CGRectGetMidY(btn.bounds), btn.frame.size.width, btn.frame.size.height);
    [scrollView addSubview:btn];
    
    // View controller for popovers that highlight the view they are popping open from.
    highlightPopOverVC = [[ILABPopOverViewController alloc] initWithViewController:self];
    highlightPopOverVC.popOverView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    highlightPopOverVC.popOverView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    highlightPopOverVC.overlayBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    highlightPopOverVC.showHighlight = YES;
    highlightPopOverVC.highlightCornerRadius = 4.;
    highlightPopOverVC.highlightPadding = UIEdgeInsetsMake(4, 8, 4, 8);
    
    // Configure the shared instances for the two types of pop overs
    [ILABPopOverViewController sharedPopOver].popOverView.contentInset = UIEdgeInsetsMake(4, 10, 4, 10);
    [ILABPopOverViewController sharedPopOver].popOverView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    [ILABPopOverViewController sharedPopOver].showOverlay = NO;

    [ILABPopOverViewController sharedDialog].popOverView.contentInset = UIEdgeInsetsMake(4, 10, 4, 10);
    [ILABPopOverViewController sharedDialog].popOverView.blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    [ILABPopOverViewController sharedDialog].overlayBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPopOver:(id)sender {
    [[ILABPopOverViewController sharedPopOver] show:popupView fromView:(UIView *)sender];
}

- (IBAction)showHighlightPopOver:(id)sender {
    [highlightPopOverVC show:highlightPopupView fromView:(UIView *)sender];
}

- (IBAction)showDialogPopOver:(id)sender {
    [[ILABPopOverViewController sharedDialog] showAsDialog:dialogPopupView];
}

- (IBAction)actionTouched:(id)sender {
    [[ILABPopOverViewController sharedPopOver] dismiss:^{
        NSLog(@"DISMISSED");
    }];
}

- (IBAction)highlightActionTouched:(id)sender {
    [highlightPopOverVC dismiss:^{
        NSLog(@"DISMISSED");
    }];
}

- (IBAction)dialogActionTouched:(id)sender {
    [[ILABPopOverViewController sharedDialog] dismiss:nil];
}

@end
