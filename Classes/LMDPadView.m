//
//  LMDPadView.m
//  MeSNEmu
//
//  Created by Lucas Menge on 1/4/12.
//  Copyright (c) 2012 Lucas Menge. All rights reserved.
//

#import "LMDPadView.h"

#import "../SNES9XBridge/Snes9xMain.h"

typedef NS_OPTIONS(NSUInteger, LMDPadViewDirection) {
  LMDPadViewDirectionNone   = 0,
  LMDPadViewDirectionLeft   = 1 << 0,
  LMDPadViewDirectionRight  = 1 << 1,
  LMDPadViewDirectionUp     = 1 << 2,
  LMDPadViewDirectionDown   = 1 << 3,
};

@interface LMDPadView ()

- (void)setImageForDirection:(LMDPadViewDirection)direction;

@end

@implementation LMDPadView

- (void)setImageForDirection:(LMDPadViewDirection)direction
{
  CATransform3D transform = CATransform3DIdentity;
  transform.m34 = 1.0 / -500;
  
  CGFloat angle = 0.17f;
  
  if (direction & LMDPadViewDirectionUp) {
    transform = CATransform3DRotate(transform, angle, 1.0f, 0, 0);
  }
  if (direction & LMDPadViewDirectionDown) {
    transform = CATransform3DRotate(transform, -angle, 1.0f, 0, 0);
  }
  if (direction & LMDPadViewDirectionLeft) {
    transform = CATransform3DRotate(transform, -angle, 0, 1.0f, 0);
  }
  if (direction & LMDPadViewDirectionRight) {
    transform = CATransform3DRotate(transform, angle, 0, 1.0f, 0);
  }
  self.layer.transform = transform;
}

@end

@implementation LMDPadView(Privates)

- (void)handleTouches:(NSSet*)touches
{
  UITouch* touch = [touches anyObject];
  LMDPadViewDirection buttonDirection = LMDPadViewDirectionNone;
  if(touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded || touch == nil)
  {
    SISetControllerReleaseButton(SI_BUTTON_UP);
    SISetControllerReleaseButton(SI_BUTTON_LEFT);
    SISetControllerReleaseButton(SI_BUTTON_RIGHT);
    SISetControllerReleaseButton(SI_BUTTON_DOWN);
    [self setImageForDirection:buttonDirection];
    return;
  }

  CGPoint location = [touch locationInView:self];
  CGSize imageSize = self.image.size;
  CGSize viewSize = self.bounds.size;
  
  CGSize thirdImageSize = CGSizeMake(imageSize.width / 3.0f, imageSize.height / 3.0f);
  
  CGRect centerSquareRect = CGRectMake(((viewSize.width - imageSize.width) / 2.0f) + thirdImageSize.width,
                                       ((viewSize.height - imageSize.height) / 2.0f) + thirdImageSize.height,
                                       thirdImageSize.width,
                                       thirdImageSize.height);
  
  //For the middle area, just continue pressing what buttons were pressed before
  if (CGRectContainsPoint(centerSquareRect, location)) {
    return;
  }
  
  SISetControllerReleaseButton(SI_BUTTON_UP);
  SISetControllerReleaseButton(SI_BUTTON_LEFT);
  SISetControllerReleaseButton(SI_BUTTON_RIGHT);
  SISetControllerReleaseButton(SI_BUTTON_DOWN);
  
  if (location.x < CGRectGetMinX(centerSquareRect)) {
    buttonDirection |= LMDPadViewDirectionLeft;
    SISetControllerPushButton(SI_BUTTON_LEFT);
  }
  if (location.x > CGRectGetMaxX(centerSquareRect)) {
    buttonDirection |= LMDPadViewDirectionRight;
    SISetControllerPushButton(SI_BUTTON_RIGHT);
  }
  if (location.y < CGRectGetMinY(centerSquareRect)) {
    buttonDirection |= LMDPadViewDirectionUp;
    SISetControllerPushButton(SI_BUTTON_UP);
  }
  if (location.y > CGRectGetMaxY(centerSquareRect)) {
    buttonDirection |= LMDPadViewDirectionDown;
    SISetControllerPushButton(SI_BUTTON_DOWN);
  }
  [self setImageForDirection:buttonDirection];
}

@end

#pragma mark -

@implementation LMDPadView(UIView)

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if(self)
  {
    self.userInteractionEnabled = YES;
    self.layer.zPosition = 1000.0f;

    self.image = [UIImage imageNamed:@"ButtonDPad.png"];
    self.contentMode = UIViewContentModeCenter;
  }
  return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches:touches];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches:touches];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches:touches];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event
{
  [self handleTouches:touches];
}

@end