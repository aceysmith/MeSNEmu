//
//  LMButtonView.h
//  MeSNEmu
//
//  Created by Lucas Menge on 1/11/12.
//  Copyright (c) 2012 Lucas Menge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LMButtonView;

@protocol LMButtonViewDelegate <NSObject>

- (void)buttonViewTapped:(LMButtonView *)buttonView;

@end

@interface LMButtonView : UIImageView
{
  uint32_t _button;
  UILabel* _label;
  id<LMButtonViewDelegate> _delegate;
}

@property uint32_t button;
@property (readonly) UILabel* label;
@property (assign) id<LMButtonViewDelegate> delegate;

@end
