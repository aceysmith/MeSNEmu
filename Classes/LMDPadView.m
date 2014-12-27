//
//  LMDPadView.m
//  MeSNEmu
//
//  Created by Lucas Menge on 1/4/12.
//  Copyright (c) 2012 Lucas Menge. All rights reserved.
//

#import "LMDPadView.h"

#import "../SNES9XBridge/Snes9xMain.h"

@implementation LMDPadView(Privates)

- (void)handleTouches:(NSSet*)touches
{
  UITouch* touch = [touches anyObject];
  if(touch.phase == UITouchPhaseCancelled || touch.phase == UITouchPhaseEnded || touch == nil)
  {
    SISetControllerReleaseButton(SI_BUTTON_UP);
    SISetControllerReleaseButton(SI_BUTTON_LEFT);
    SISetControllerReleaseButton(SI_BUTTON_RIGHT);
    SISetControllerReleaseButton(SI_BUTTON_DOWN);
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
    SISetControllerPushButton(SI_BUTTON_LEFT);
  }
  if (location.x > CGRectGetMaxX(centerSquareRect)) {
    SISetControllerPushButton(SI_BUTTON_RIGHT);
  }
  if (location.y < CGRectGetMinY(centerSquareRect)) {
    SISetControllerPushButton(SI_BUTTON_UP);
  }
  if (location.y > CGRectGetMaxY(centerSquareRect)) {
    SISetControllerPushButton(SI_BUTTON_DOWN);
  }
}

@end

@implementation LMDPadView

@end

#pragma mark -

@implementation LMDPadView(UIView)

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if(self)
  {
    self.userInteractionEnabled = YES;
    
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