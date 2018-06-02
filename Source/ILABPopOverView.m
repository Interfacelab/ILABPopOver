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
//  ILABPopOverView.m
//  ILABPopOver
//
//  Created by Jon Gilkison on 6/2/17.
//  Copyright © 2017 interfacelab. All rights reserved.
//

#import "ILABPopOverView.h"

@interface ILABPopOverView() {
    
    __weak UIView *containerView;
    
    UIVisualEffectView *effectsView;
}
@end

@implementation ILABPopOverView

#pragma mark - Init/Setup

-(instancetype)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setup];
    }
    
    return self;
}

-(instancetype)init {
    if ((self = [super initWithFrame:CGRectZero])) {
        [self setup];
    }
    
    return self;
}

-(void)setup {
    _arrowSize = CGSizeMake(16, 10);
    _cornerRadius = 8.;
    _popoverColor = UIColor.whiteColor;
    _blurEffect = nil;
    _contentInset = UIEdgeInsetsZero;
    
    containerView = self;
    effectsView = nil;
    
    self.opaque = NO;
    self.backgroundColor = UIColor.clearColor;
    
    self.accessibilityViewIsModal = YES;
}

#pragma mark - Properties

-(void)setBlurEffect:(UIBlurEffect *)blurEffect {
    _blurEffect = blurEffect;
    
    if (effectsView) {
        [effectsView removeFromSuperview];
        effectsView = nil;
    }
    
    if (_blurEffect) {
        effectsView = [[UIVisualEffectView alloc] initWithEffect:_blurEffect];
        effectsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        effectsView.frame = self.bounds;
        [effectsView setUserInteractionEnabled:YES];
        [self addSubview:effectsView];
        
        containerView = effectsView;
    } else {
        containerView = self;
    }
}

#pragma mark - Prepare view

-(CGRect)proposedFrameWithContentView:(UIView * _Nonnull)contentView fromDirection:(ILABPopOverDirection)direction {
    CGSize proposedSize = CGSizeZero;
    proposedSize.width += (_contentInset.left + _contentInset.right);
    proposedSize.height += (_contentInset.top + _contentInset.bottom);
    if (direction != ILABPopOverDirectionNone) {
        proposedSize.height += _arrowSize.height;
    }
    proposedSize.width += contentView.frame.size.width;
    proposedSize.height += contentView.frame.size.height;
    
    return CGRectMake(0, 0, proposedSize.width, proposedSize.height);
}

-(void)prepareForDisplay:(UIView * _Nonnull)contentView fromDirection:(ILABPopOverDirection)direction arrowLocation:(CGPoint)arrowLocation {
//    arrowLocation.x = MAX(18, arrowLocation.x);
    
    self.layer.mask = nil;
    self.layer.backgroundColor = nil;
    
    CGPoint contentOrigin = CGPointZero;
    contentOrigin.x += _contentInset.left;
    contentOrigin.y += _contentInset.top;
    if (direction == ILABPopOverDirectionDown) {
        contentOrigin.y += _arrowSize.height;
    }

    CGRect proposedFrame = [self proposedFrameWithContentView:contentView fromDirection:direction];
    self.frame = proposedFrame;
    
    CAShapeLayer *maskLayer = [self buildLayerMask:direction arrowLocation:arrowLocation];

    if (effectsView && maskLayer) {
        if (@available(iOS 11.0, *)) {
            self.layer.mask = maskLayer;
        } else {
            UIView *maskView = [[UIView alloc] initWithFrame:self.bounds];
            maskView.backgroundColor = UIColor.blackColor;
            maskView.layer.mask = maskLayer;
            effectsView.maskView = maskView;
        }
    } else {
        self.layer.backgroundColor = self.popoverColor.CGColor;
        if (maskLayer) {
            self.layer.mask = maskLayer;
        }
    }
    
    contentView.opaque = NO;
    contentView.backgroundColor = UIColor.clearColor;
    [contentView removeFromSuperview];
    
    if ([containerView isKindOfClass:[UIVisualEffectView class]]) {
        [[((UIVisualEffectView *)containerView) contentView] addSubview:contentView];
    } else {
        [containerView addSubview:contentView];
    }
    
    contentView.frame = CGRectMake(contentOrigin.x, contentOrigin.y, contentView.frame.size.width, contentView.frame.size.height);
}

-(CAShapeLayer *)buildLayerMask:(ILABPopOverDirection)direction arrowLocation:(CGPoint)arrowLocation {
    if (direction == ILABPopOverDirectionUp) {
        return [self buildUpLayerMask:arrowLocation];
    } else if (direction == ILABPopOverDirectionDown) {
        return [self buildDownLayerMask:arrowLocation];
    } else {
        return [self buildDialogLayerMask];
    }
}

-(CAShapeLayer *)buildUpLayerMask:(CGPoint)arrowLocation {
    _originPoint = CGPointMake(arrowLocation.x, 0);

    UIBezierPath *containerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - _arrowSize.height) cornerRadius:_cornerRadius];
    containerPath.usesEvenOddFillRule = YES;
    
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    arrow.usesEvenOddFillRule = YES;
    [arrow moveToPoint:CGPointMake(arrowLocation.x - (_arrowSize.width / 2.), self.bounds.size.height - _arrowSize.height)];
    [arrow addLineToPoint:CGPointMake(arrowLocation.x + (_arrowSize.width / 2.), self.bounds.size.height - _arrowSize.height)];
    [arrow addLineToPoint:CGPointMake(arrowLocation.x, self.bounds.size.height)];
    [arrow addLineToPoint:CGPointMake(arrowLocation.x - (_arrowSize.width / 2.), self.bounds.size.height - _arrowSize.height)];
    
    [containerPath appendPath:arrow];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = containerPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    return maskLayer;
}

-(CAShapeLayer *)buildDownLayerMask:(CGPoint)arrowLocation {
    _originPoint = CGPointMake(arrowLocation.x, self.bounds.size.height);

    UIBezierPath *containerPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, _arrowSize.height, self.bounds.size.width, self.bounds.size.height - _arrowSize.height) cornerRadius:_cornerRadius];
    containerPath.usesEvenOddFillRule = YES;
    
    UIBezierPath *arrow = [UIBezierPath bezierPath];
    arrow.usesEvenOddFillRule = YES;
    [arrow moveToPoint:CGPointMake(arrowLocation.x - (_arrowSize.width / 2.), _arrowSize.height)];
    [arrow addLineToPoint:CGPointMake(arrowLocation.x + (_arrowSize.width / 2.), _arrowSize.height)];
    [arrow addLineToPoint:CGPointMake(arrowLocation.x, 0)];
    [arrow addLineToPoint:CGPointMake(arrowLocation.x - (_arrowSize.width / 2.), _arrowSize.height)];
    
    [containerPath appendPath:arrow];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = containerPath.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    return maskLayer;
}

-(CAShapeLayer *)buildDialogLayerMask {
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:_cornerRadius];
    path.usesEvenOddFillRule = YES;
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = path.CGPath;
    maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    return maskLayer;
}

@end
