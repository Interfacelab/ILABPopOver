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
//  ILABPopOverView.h
//  ILABPopOver
//
//  Created by Jon Gilkison on 6/2/17.
//  Copyright © 2017 interfacelab. All rights reserved.
//

@import UIKit;

@class ILABPopOver;

/**
 The direction of the popover
 */
typedef enum : NSUInteger {
    ILABPopOverDirectionNone,
    ILABPopOverDirectionUp,
    ILABPopOverDirectionDown
} ILABPopOverDirection;

/**
 PopOver view similar to UIPopOverController of days past, but better.
 */
@interface ILABPopOverView : UIView

@property (assign, nonatomic) CGSize arrowSize;                     /**< The size of the popover's arrow */
@property (assign, nonatomic) CGFloat cornerRadius;                 /**< The corner radius for the popover */
@property (strong, nonatomic, nonnull) UIColor *popoverColor;       /**< The color to use for the popover itself */
@property (strong, nonatomic, nullable) UIBlurEffect *blurEffect;   /**< The blur effect to use, if any */
@property (assign, nonatomic) UIEdgeInsets contentInset;            /**< Content inset for the popover */
@property (readonly) CGPoint originPoint;                           /**< Origin point of the popover */

/**
 Prepares the popover view for display.

 @param contentView The content view to display in the popover
 @param direction The direction of the arrow
 @param arrowLocation The location of the arrow
 */
-(void)prepareForDisplay:(UIView * _Nonnull)contentView fromDirection:(ILABPopOverDirection)direction arrowLocation:(CGPoint)arrowLocation;


/**
 Calculates the frame for the popover.

 @param contentView The content view that the pop over will be displaying
 @param direction The direction of the arrow
 @return The proposed frame
 */
-(CGRect)proposedFrameWithContentView:(UIView * _Nonnull)contentView fromDirection:(ILABPopOverDirection)direction;

@end
