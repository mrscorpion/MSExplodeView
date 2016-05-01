//
//  MSExplodeView.h
//  MSExplodeView
//
//  Created by mr.scorpion on 12/14/14.
//  Copyright (c) 2014 mr.scorpion. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSExplodeView;

@protocol MSExplodeViewDelegate <NSObject>
/**
 *  开始动画回调
 */
- (void)explodeViewBegainExplode:(MSExplodeView *)explodeView;
/**
 *  结束动画回调
 */
- (void)explodeViewFinishExplode:(MSExplodeView *)explodeView;
@end

@interface MSExplodeView : UIImageView
/**
 *  代理
 */
@property (nonatomic, assign) id<MSExplodeViewDelegate> delegate;

/**
 *  动画爆炸
 */
- (void)explode;

/**
 *  动画爆炸，切换图片
 *
 *  @param prepareImage 切换的图片
 */
- (void)explodeWithPrepareImage:(UIImage *)prepareImage;
@end
