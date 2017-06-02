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
//  ILABPopOverViewController.h
//  ILABPopOver
//
//  Created by Jon Gilkison on 6/2/17.
//  Copyright © 2017 interfacelab. All rights reserved.
//

@import UIKit;

#import "ILABPopOverView.h"

typedef void(^ILABPopOverCompleteBlock)();


@class ILABPopOverViewController;

/**
 ILABPopOverController delegate
 */
@protocol ILABPopOverDelegate <NSObject>

@optional

/**
 Sent before the popover is shown
 
 @param popOver The `ILABPopOver` to display
 */
-(void)popOverWillShow:(ILABPopOverViewController * _Nonnull)popOver;

/**
 Sent before the popover is dimissed
 
 @param popOver The `ILABPopOver` to display
 */
-(void)popOverWillDismiss:(ILABPopOverViewController * _Nonnull)popOver;

/**
 Sent after the popover is shown
 
 @param popOver The `ILABPopOver` to display
 */
-(void)popOverDidShow:(ILABPopOverViewController * _Nonnull)popOver;

/**
 Sent after the popover is dismissed
 
 @param popOver The `ILABPopOver` to display
 */
-(void)popOverDidDismiss:(ILABPopOverViewController * _Nonnull)popOver;

@end


/**
 View controller for the `ILABPopOverView` view.
 */
@interface ILABPopOverViewController : UIViewController

@property (weak, nonatomic, nullable) id<ILABPopOverDelegate> delegate;     /**< Delegate */
@property (readonly, nonnull) ILABPopOverView * popOverView;                /**< The `ILABPopOverView` */
@property (strong, nonatomic, nonnull) UIColor *overlayColor;               /**< The color to use for the overlay */
@property (assign, nonatomic) BOOL showOverlay;                             /**< Determines if the overlay is displayed or not */
@property (assign, nonatomic) BOOL dismissOnBackgroundTap;                  /**< Dismiss the pop over when the background is tapped */
@property (assign, nonatomic) BOOL showHighlight;                           /**< Determines if the from view should be highlighted */
@property (assign, nonatomic) UIEdgeInsets highlightPadding;                /**< Padding for the highlight rect */
@property (assign, nonatomic) CGFloat highlightCornerRadius;                /**< The corner radius for the highlight rectangle */
@property (assign, nonatomic) NSTimeInterval animateInSpeed;                /**< The animation speed when displaying */
@property (assign, nonatomic) NSTimeInterval animateOutSpeed;               /**< The animation speed when dismissing */
@property (assign, nonatomic) CGFloat edgeGap;                              /**< The edge gap between the screen's edges and the edge of the popover */
@property (strong, nonatomic, nullable) UIBlurEffect * overlayBlurEffect;   /**< The blur effect to use for the overlay */

/**
 Creates a new instance of the `ILABPopOverViewController`

 @param parentViewController The parent view controller that will be displaying the popover.
 @return The new instance
 */
-(instancetype _Nonnull)initWithViewController:(UIViewController * _Nonnull)parentViewController;


/**
 Shared instance for dialog popovers

 @return The shared `ILABPopOverViewController` instance
 */
+(instancetype _Nonnull)sharedDialog;

/**
 Shared instance for regular popovers
 
 @return The shared `ILABPopOverViewController` instance
 */

+(instancetype _Nonnull)sharedPopOver;


/**
 Displays the popover as a dialog.

 @param contentView The content view to display in the dialog.
 */
-(void)showAsDialog:(UIView * _Nonnull)contentView;


/**
 Displays the popover attached to a specific view

 @param contentView The content view to display in the dialog.
 @param fromView The view to display the popup from.
 */
-(void)show:(UIView * _Nonnull)contentView fromView:(UIView * _Nonnull)fromView;


/**
 Displays the popover from a specific point

 @param contentView The content view to display in the dialog.
 @param fromPoint The point to display the popup from, local to the view to display the popup from.
 @param fromView The view to display the popup from.
 */
-(void)show:(UIView * _Nonnull)contentView fromPoint:(CGPoint)fromPoint fromView:(UIView * _Nonnull)fromView;


/**
 Dismisses the popover

 @param completeBlock The block to trigger after the dismissal is complete.
*/
-(void)dismiss:(ILABPopOverCompleteBlock _Nullable)completeBlock;

@end
