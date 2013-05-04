/*The MIT License (MIT)

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/


#import <UIKit/UIKit.h>

@class PullableView;

/**
 Protocol for objects that wish to be notified when the state of a
 PullableView changes
 */
@protocol PullableViewDelegate <NSObject>

/**
 Notifies of a changed state
 @param pView PullableView whose state was changed
 @param opened The new state of the view
 */
- (void)pullableView:(PullableView *)pView didChangeState:(BOOL)opened;

@end

/**
 Class that implements a view that can be pulled out by a handle,
 similar to the Notification Center in iOS 5. This class supports
 pulling in the horizontal or vertical axis. This is determined by
 the values for openedCenter and closedCenter that you set: if
 both have the same x coordinate, the pulling should happen in the
 vertical axis, or the horizontal axis otherwise.
 @author Fabio Rodella fabio@crocodella.com.br
 */
@interface PullableView : UIView {
    
    CGPoint closedCenter;
    CGPoint openedCenter;
    
    UIView *handleView;
    UIPanGestureRecognizer *dragRecognizer;
    UITapGestureRecognizer *tapRecognizer;
    
    CGPoint startPos;
    CGPoint minPos;
    CGPoint maxPos;
    
    BOOL opened;
    BOOL verticalAxis;
    
    BOOL toggleOnTap;
    
    BOOL animate;
    float animationDuration;
}

/**
 The view that is used as the handle for the PullableView. You
 can style it, add subviews or set its frame at will.
 */
@property (nonatomic,readonly) UIView *handleView;

/**
 The point that defines the center of the view when in its closed
 state. You must set this before using the PullableView.
 */
@property (readwrite,assign) CGPoint closedCenter;

/**
 The point that defines the center of the view when in its opened
 state. You must set this before using the PullableView.
 */
@property (readwrite,assign) CGPoint openedCenter;

/**
 Gesture recognizer responsible for the dragging of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UIPanGestureRecognizer *dragRecognizer;

/**
 Gesture recognizer responsible for handling tapping of the handle view.
 It is exposed as a property so you can change the number of touches
 or created dependencies to other recognizers in your views.
 */
@property (nonatomic,readonly) UITapGestureRecognizer *tapRecognizer;

/**
 If set to YES, tapping the handle view will toggle the PullableView.
 Default value is YES.
 */
@property (readwrite,assign) BOOL toggleOnTap;

/**
 If set to YES, the opening or closing of the PullableView will
 be animated. Default value is YES.
 */
@property (readwrite,assign) BOOL animate;

/**
 Duration of the opening/closing animation, if enabled. Default
 value is 0.2.
 */
@property (readwrite,assign) float animationDuration;

/**
 Delegate that will be notified when the PullableView changes state.
 If the view is set to animate transitions, the delegate will be
 called only when the animation finishes.
 */
@property (readwrite,weak) id<PullableViewDelegate> delegate;

/**
 The current state of the `PullableView`.
 */
@property (readonly, assign) BOOL opened;

/**
 Toggles the state of the PullableView
 @param op New state of the view
 @param anim Flag indicating if the transition should be animated
 */
- (void)setOpened:(BOOL)op animated:(BOOL)anim;

@end