/*
 Copyright (C) 2017 JOn Gilkison
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation  and/or other materials provided with the distribution.
 3. Neither the names of the copyright holders nor the names of any
 contributors may be used to endorse or promote products derived from this
 software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 */
//
//  ILABPopOverViewController.m
//  ILABPopOver
//
//  Created by Jon Gilkison on 6/2/17.
//  Copyright © 2017 interfacelab. All rights reserved.
//

#import "ILABPopOverViewController.h"

@interface ILABPopOverViewController () {
    UIControl *overlayControl;
    UIVisualEffectView *overlayEffectView;

    ILABPopOverView *popOverView;
    
    
    UIView *displayedContentView;
    
    BOOL displayedFromOrigin;
    ILABPopOverDirection displayedDirection;
    __weak UIView *displayedFromView;
    CGRect displayFromViewRect;
}

@end

@implementation ILABPopOverViewController

@synthesize popOverView = popOverView;

#pragma mark - Initialization

-(instancetype)initWithViewController:(UIViewController * _Nonnull)parentViewController {
    if ((self = [super init])) {
        [self setup];
        
        [parentViewController addChildViewController:self];
        [self didMoveToParentViewController:parentViewController];
    }
    
    return self;
}

-(instancetype)init {
    if ((self = [super init])) {
        [self setup];
    }
    
    return self;
}

+(instancetype _Nonnull)sharedDialog {
    static ILABPopOverViewController *sharedDialog = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDialog = [[ILABPopOverViewController alloc] init];
    });
    
    return sharedDialog;
}

+(instancetype _Nonnull)sharedPopOver {
    static ILABPopOverViewController *sharedPopOver = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedPopOver = [[ILABPopOverViewController alloc] init];
    });
    
    return sharedPopOver;
}

-(void)setup {
    popOverView = [[ILABPopOverView alloc] init];
    _overlayColor = [UIColor colorWithWhite:0.0 alpha:0.66];
    _showOverlay = YES;
    _showHighlight = NO;
    _highlightCornerRadius = 0.;
    _animateInSpeed = 0.5;
    _animateOutSpeed = 0.33;
    _edgeGap = 20.;
    _dismissOnBackgroundTap = YES;
    _highlightPadding = UIEdgeInsetsZero;

    overlayControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    overlayControl.opaque = NO;
    overlayControl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [overlayControl addTarget:self action:@selector(overlayTapped:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Properties

-(void)setOverlayBlurEffect:(UIBlurEffect *)overlayBlurEffect {
    _overlayBlurEffect = overlayBlurEffect;
    
    if (overlayEffectView) {
        [overlayEffectView removeFromSuperview];
        overlayEffectView = nil;
    }
    
    if (_overlayBlurEffect) {
        overlayEffectView = [[UIVisualEffectView alloc] initWithEffect:_overlayBlurEffect];
        overlayEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlayEffectView.frame = overlayControl.bounds;
        [overlayEffectView setUserInteractionEnabled:NO];
        [overlayControl addSubview:overlayEffectView];
    }
}

#pragma mark - Accessibility

-(BOOL)accessibilityPerformEscape {
    [self dismiss:nil];
    
    return YES;
}

#pragma mark - Actions

-(void)overlayTapped:(id)sender {
    if (_dismissOnBackgroundTap) {
        [self dismiss:nil];
    }
}

#pragma mark - Display/Dismiss

-(void)showAsDialog:(UIView *)contentView {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject] ?: [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        return;
    }
    
    displayedFromView = nil;
    displayedFromOrigin = NO;
    
    [popOverView prepareForDisplay:contentView fromDirection:ILABPopOverDirectionNone arrowLocation:CGPointZero];
    popOverView.frame = CGRectMake(CGRectGetMidX(window.bounds) - CGRectGetMidX(popOverView.frame), CGRectGetMidY(window.bounds) - CGRectGetMidY(popOverView.frame), popOverView.frame.size.width, popOverView.frame.size.height);

    displayedContentView = contentView;

    [self displayInView:window fromOrigin:NO];
    
}

-(void)show:(UIView *)contentView fromView:(UIView *)fromView {
    CGPoint pt = CGPointMake(CGRectGetMidX(fromView.bounds), 0);
    [self show:contentView fromPoint:pt fromView:fromView];
}

-(void)show:(UIView *)contentView fromPoint:(CGPoint)fromPoint fromView:(UIView *)fromView {
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject] ?: [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        return;
    }
    
    displayedFromView = fromView;
    displayedFromOrigin = YES;
    displayedContentView = contentView;

    displayFromViewRect = [fromView convertRect:fromView.bounds toView:window];
    displayedDirection = ILABPopOverDirectionUp;

    CGRect proposedRect = [popOverView proposedFrameWithContentView:contentView fromDirection:ILABPopOverDirectionUp];
    
    if ((displayFromViewRect.origin.y - proposedRect.size.height) < _edgeGap) {
        displayedDirection = ILABPopOverDirectionDown;
        fromPoint.y = displayFromViewRect.size.height;
        proposedRect = [popOverView proposedFrameWithContentView:contentView fromDirection:displayedDirection];
    }
    
    if (displayedDirection == ILABPopOverDirectionUp) {
        proposedRect = CGRectMake(CGRectGetMidX(displayFromViewRect) - CGRectGetMidX(proposedRect), displayFromViewRect.origin.y - proposedRect.size.height, proposedRect.size.width, proposedRect.size.height);
    } else {
        proposedRect = CGRectMake(CGRectGetMidX(displayFromViewRect) - CGRectGetMidX(proposedRect), displayFromViewRect.origin.y + displayFromViewRect.size.height, proposedRect.size.width, proposedRect.size.height);
    }
    
    if (proposedRect.origin.x < _edgeGap) {
        proposedRect.origin.x = _edgeGap;
    } else if (proposedRect.origin.x + proposedRect.size.width > window.bounds.size.width - _edgeGap) {
        proposedRect.origin.x = window.bounds.size.width - _edgeGap - proposedRect.size.width;
    }
    
    popOverView.frame = proposedRect;
    [popOverView prepareForDisplay:contentView fromDirection:displayedDirection arrowLocation:[popOverView convertPoint:fromPoint fromView:fromView]];
    popOverView.frame = proposedRect;
    
    overlayControl.maskView = nil;
    if (overlayEffectView) {
        overlayEffectView.maskView = nil;
    }
    
    if (_showHighlight && displayedFromView) {
        CGRect highlightRect = CGRectMake(displayFromViewRect.origin.x - _highlightPadding.left, displayFromViewRect.origin.y - _highlightPadding.top, displayFromViewRect.size.width + (_highlightPadding.left + _highlightPadding.right), displayFromViewRect.size.height + (_highlightPadding.top + _highlightPadding.bottom));

        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:window.bounds];
        
        UIBezierPath *highlightPath = [UIBezierPath bezierPathWithRoundedRect:highlightRect cornerRadius:_highlightCornerRadius];
        [maskPath appendPath:highlightPath];
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.path = maskPath.CGPath;
        maskLayer.fillRule = kCAFillRuleEvenOdd;
        
        UIView *maskView = [[UIView alloc] initWithFrame:window.bounds];
        maskView.backgroundColor = UIColor.blackColor;
        maskView.layer.mask = maskLayer;
        
        if (overlayEffectView) {
            overlayEffectView.maskView = maskView;
        } else {
            overlayControl.maskView = maskView;
        }
    }


    [self displayInView:window fromOrigin:YES];
}


-(void)displayInView:(UIView *)view fromOrigin:(BOOL)fromOrigin {
    if (!overlayEffectView) {
        if (!_showOverlay) {
            overlayControl.backgroundColor = UIColor.clearColor;
        } else {
            overlayControl.backgroundColor = _overlayColor;
        }
    } else {
        overlayControl.backgroundColor = UIColor.clearColor;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(popOverWillShow:)]) {
        [_delegate popOverWillShow:self];
    }
    
    
    overlayControl.frame = view.bounds;
    
    if (overlayEffectView) {
        overlayEffectView.alpha = 0.;
    } else {
        overlayControl.alpha = 0.;
    }
    [view addSubview:overlayControl];
    [UIView animateWithDuration:_animateInSpeed / 3.
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         if (overlayEffectView) {
                             overlayEffectView.alpha = 1.;
                         } else {
                             overlayControl.alpha = 1.;
                         }
                     }
                     completion:^(BOOL finished) {
                         
                     }];
    
    CGAffineTransform transformIn = CGAffineTransformIdentity;
    
    if (fromOrigin) {
        if (displayedDirection == ILABPopOverDirectionDown) {
            transformIn = CGAffineTransformMakeTranslation(-(CGRectGetMidX(popOverView.bounds) - popOverView.originPoint.x), -CGRectGetMidY(popOverView.bounds));
        } else {
            transformIn = CGAffineTransformMakeTranslation(-(CGRectGetMidX(popOverView.bounds) - popOverView.originPoint.x), CGRectGetMidY(popOverView.bounds));
        }
    }
    
    popOverView.transform =  CGAffineTransformScale(transformIn, 0.001, 0.001);
    
    [view addSubview:popOverView];
    [UIView animateWithDuration:_animateInSpeed
                          delay:0
         usingSpringWithDamping:0.7
          initialSpringVelocity:3
                        options:0
                     animations:^{
                         popOverView.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                         if (_delegate && [_delegate respondsToSelector:@selector(popOverDidShow:)]) {
                             [_delegate popOverDidShow:self];
                         }
                     }];
}

-(void)dismiss:(ILABPopOverCompleteBlock)completeBlock {
    if (popOverView.superview == nil) {
        return;
    }
    
    CGAffineTransform transformOut = CGAffineTransformIdentity;
    
    if (displayedFromOrigin) {
        if (displayedDirection == ILABPopOverDirectionDown) {
            transformOut = CGAffineTransformMakeTranslation(-(CGRectGetMidX(popOverView.bounds) - popOverView.originPoint.x), -CGRectGetMidY(popOverView.bounds));
        } else {
            transformOut = CGAffineTransformMakeTranslation(-(CGRectGetMidX(popOverView.bounds) - popOverView.originPoint.x), CGRectGetMidY(popOverView.bounds));
        }
    }
    
    transformOut = CGAffineTransformScale(transformOut, 0.0001, 0.0001);
    
    if (_delegate && [_delegate respondsToSelector:@selector(popOverWillDismiss:)]) {
        [_delegate popOverWillDismiss:self];
    }
    
    [UIView animateWithDuration:_animateOutSpeed
                          delay:0
                        options:0
                     animations:^{
                         if (overlayEffectView) {
                             overlayEffectView.alpha = 0.;
                         } else {
                             overlayControl.alpha = 0.;
                         }

                         popOverView.transform = transformOut;
                     }
                     completion:^(BOOL finished) {
                         [overlayControl removeFromSuperview];
                         [popOverView removeFromSuperview];
                         [displayedContentView removeFromSuperview];
                         
                         popOverView.transform = CGAffineTransformIdentity;
                         
                         if (_delegate && [_delegate respondsToSelector:@selector(popOverDidDismiss:)]) {
                             [_delegate popOverDidDismiss:self];
                         }

                         if (completeBlock) {
                             completeBlock();
                         }
                     }];
}



@end
