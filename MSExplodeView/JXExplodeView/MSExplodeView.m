//
//  MSExplodeView.m
//  MSExplodeView
//
//  Created by mr.scorpion on 12/14/14.
//  Copyright (c) 2014 mr.scorpion. All rights reserved.
//

#import "MSExplodeView.h"
// 爆炸最大个数
static const int kMSExplodeViewVerticalCount   = 5;
static const int kMSExplodeViewHorizontalCount = 5;

// 旋转参数
static const float kMSExplodeViewRotationAngle   = M_PI;
static const float kMSExplodeViewRotationX       = 1;
static const float kMSExplodeViewRotationY       = 1;
static const float kMSExplodeViewRotationZ       = 1;

// 放大参数
static const float kMSExplodeViewScale = 1.2;

// 偏移参数
static const int kMSExplodeViewCenterPointRangeX = 1000;
static const int kMSExplodeViewCenterPointRangeY = 1000;

typedef struct MSExplodeViewDelegateState {
    BOOL respondsBegainExplode;
    BOOL respondsFinishExplode;
}MSExplodeViewDelegateState;

@interface MSExplodeView ()
{
    NSArray *_images;
    MSExplodeViewDelegateState _state;
}
@end

@implementation MSExplodeView
/**
 *  图层爆炸
 */
- (void)explode
{
    if (_state.respondsBegainExplode) {
        [_delegate explodeViewBegainExplode:self];
    }
    
    for (UIImageView *imageView in _images) {
        [UIView animateWithDuration:2.0 animations:^{
            // 旋转
            imageView.layer.transform = CATransform3DMakeRotation(kMSExplodeViewRotationAngle,
                                                                  kMSExplodeViewRotationX,
                                                                  kMSExplodeViewRotationY,
                                                                  kMSExplodeViewRotationZ);
            
            // 大小
            imageView.bounds = CGRectMake(0, 0,
                                          kMSExplodeViewScale * imageView.frame.size.width,
                                          kMSExplodeViewScale * imageView.frame.size.height);

            // 透明度
            imageView.alpha = 0;
            
            // 随机坐标
            int flagX = (arc4random()%2)==0 ? -1 : 1;
            int flagY = (arc4random()%2)==0 ? -1 : 1;
            
            int pointX = ( arc4random() % kMSExplodeViewCenterPointRangeX ) * flagX;
            int pointY = ( arc4random() % kMSExplodeViewCenterPointRangeY ) * flagY;
            
            imageView.center = CGPointMake( pointX, pointY );

        } completion:^(BOOL finished) {
            // 移除小模块
            [imageView removeFromSuperview];
            _images = nil;
            
            if (_state.respondsFinishExplode) {
                [_delegate explodeViewFinishExplode:self];
            }
        }];
    }
}

/**
 *  爆炸，切换图片
 *
 *  @param prepareImage 需要切换的图片
 */
- (void)explodeWithPrepareImage:(UIImage *)prepareImage
{
    [self prepareExplode:prepareImage];
    [self explode];
}

/**
 *  爆炸后图像切换
 */
- (void)prepareExplode:(UIImage *)nestImage
{
    _images = [self getExplodeViews];
    
    self.image = nestImage;
}

/**
 *  获取爆炸图像小元素块
 */
- (NSArray *)getExplodeViews
{
    // 最大个数
    int maxCount = kMSExplodeViewVerticalCount * kMSExplodeViewHorizontalCount;
    
    NSMutableArray *explodeElements = [NSMutableArray array];
    
    float imageHeight = self.image.size.height;
    float imageWidth  = self.image.size.width;
    
    CGRect frame;
    float imgHeight = imageHeight/kMSExplodeViewVerticalCount;
    float imgWidth  = imageWidth/kMSExplodeViewHorizontalCount;
    
    float divHeight = self.frame.size.height/kMSExplodeViewVerticalCount;
    float divWidth  = self.frame.size.width/kMSExplodeViewHorizontalCount;

    for (int i = 0; i < maxCount; i++) {
        // 设置坐标
        frame = CGRectMake(imgWidth  * (i%kMSExplodeViewHorizontalCount),
                           imgHeight * (i/kMSExplodeViewVerticalCount),
                           imgWidth, imgHeight);
                
        // 图像切割
        CGImageRef imageRef = CGImageCreateWithImageInRect(self.image.CGImage, frame);
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        
        // 切割图像贴入
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

        imageView.frame = CGRectMake(divWidth  * (i%kMSExplodeViewHorizontalCount),
                                     divHeight * (i/kMSExplodeViewVerticalCount),
                                     divWidth, divHeight);
        [self addSubview:imageView];
        
        // 缓存图像
        [explodeElements addObject:imageView];
    }
    
    _images = explodeElements;
    return _images;
}

- (void)setDelegate:(id<MSExplodeViewDelegate>)delegate
{
    _delegate = delegate;
    
    _state.respondsBegainExplode = [_delegate respondsToSelector:@selector(explodeViewBegainExplode:)];
    _state.respondsFinishExplode = [_delegate respondsToSelector:@selector(explodeViewFinishExplode:)];
}
@end
