# ILABPopOver

[![Version](https://img.shields.io/cocoapods/v/ILABPopOver.svg?style=flat)](http://cocoapods.org/pods/ILABPopOver)
[![License](https://img.shields.io/cocoapods/l/ILABPopOver.svg?style=flat)](http://cocoapods.org/pods/ILABPopOver)
[![Platform](https://img.shields.io/cocoapods/p/ILABPopOver.svg?style=flat)](http://cocoapods.org/pods/ILABPopOver)

![](https://github.com/interfacelab/ILABPopOver/blob/master/Screenshots/ILABPopOver.gif)

## Installation

### CocoaPods
```ruby
use_frameworks!
pod 'ILABPopOver'
```

## Demo Project

Clone the repo, run `pod install` in the demo project.


##Usage

Using ILABPopOver is a fairly simple and straight forward affair.  It works in two modes: as a modal dialog and as a popover similar to `UIPopOverController` or `UIMenuController`.

It is composed of two classes, the `ILABPopOverViewController` and the `ILABPopOverView`.

The `ILABPopOverViewController` is responsible for displaying the pop over view, while the `ILABPopOverView` simply renders the popup "balloon".

###Using as Dialog
In dialog mode, the pop over will display your view in a modal popup:

```objc
- (IBAction)showDialogPopOver:(id)sender {
    [[ILABPopOverViewController sharedDialog] showAsDialog:dialogPopupView];
}
```

In the above example, the `dialogPopupView` is a UIView instance that you want to display as the main content view of your popup.

To dismiss the popup:

```objc
- (IBAction)dismissDialogTouched:(id)sender {
    [[ILABPopOverViewController sharedDialog] dismiss:^{
        NSLog(@"DISMISSED");
    }];
}
```

###Using as Pop Over
In pop over mode, your view will be presented to the user as a balloon pop up.

```objc
- (IBAction)showPopOver:(id)sender {
    [[ILABPopOverViewController sharedPopOver] show:popupView fromView:(UIView *)sender];
}
```

In the above example `popupView` is the UIView instance you want to display as the main content view of the pop up.

To dismiss the popup:

```objc
- (IBAction)dismissDialogTouched:(id)sender {
    [[ILABPopOverViewController sharedDialog] dismiss:^{
        NSLog(@"DISMISSED");
    }];
}
```

###Shared Instances
The `ILABPopOverViewController` has two static shared instances to simplify usage.

The `sharedDialog` static instance is the view controller for displaying an pop over as a dialog.

The `sharedPopOver` static instance is the view controller for displaying all other pop overs.

You should configure these instances on app launch to match whatever styles and behaviors are appropriate for your app.

##Configuration

###ILABPopOverViewController

| Property | Type | Description |
| -------- | ---- | ----------- |
| popOverView | ILABPopOverView | The `ILABPopOverView` the view controller displays |
| overlayColor | UIColor | The color to use for the overlay background |
| showOverlay | BOOL | Determines if the overlay is displayed or not |
| dismissOnBackgroundTap | BOOL | Dismiss the pop over when the background is tapped |
| showHighlight | BOOL | Determines if the view displaying the popup should be highlighted by masking it's frame out of the overlay background. |
| highlightPadding | UIEdgeInsets | The padding to apply to the highlight rectangle. |
| highlightCornerRadius | CGFloat | The corner radius for the highlight rectangle. |
| animateInSpeed | NSTimeInterval | The animation speed when displaying the popover. |
| animateOutSpeed | NSTimeInterval | The animation speed when dismissing the popover. |
| edgeGap | CGFloat | The amount of gap or margin between any edge of the popover and the screen. |
| overlayBlurEffect | UIBlurEffect | The blur effect to use for the overlay background. |

###ILABPopOverView

| Property | Type | Description |
| -------- | ---- | ----------- |
| arrowSize | CGSize | The size of the popover's arrow |
| cornerRadius | CGFloat | The corner radius of the popover |
| popoverColor | UIColor | The color of the popover's background |
| blurEffect | UIBlurEffect | The blur effect to use for the pop over's background |
| contentInset | UIEdgeInsets | Content inset for the pop over |


## License

Popover is available under the MIT license. See the LICENSE file for more info.


