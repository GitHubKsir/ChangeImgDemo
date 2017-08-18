//
//  LFUserIconView.m
//  SmartHome
//
//  Created by LeadFair on 2017/7/8.
//  Copyright © 2017年 leadfair. All rights reserved.
//

#import "LFUserIconView.h"
#import <Accelerate/Accelerate.h>
#import <AVFoundation/AVFoundation.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<CoreLocation/CoreLocation.h>


#define COLOR_RGB16(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])

#define self_H self.frame.size.height

#define self_W self.frame.size.width

@interface LFUserIconView ()<UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIView *coverView;

@property (nonatomic,strong) UIView *iconBgView;

@property (nonatomic,strong) UIImageView *iconImgView;

@property (nonatomic,strong) UILabel *userIdLbl;

@end


@implementation LFUserIconView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        [self createUI];
        
    }
    return self;
}

- (void)createUI{
    _coverView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:_coverView];
    _coverView.backgroundColor = COLOR_RGB16(0x5a9bfb);
    _coverView.alpha = 0.4;
    
    //白色外圈
    _iconBgView = [[UIView alloc] initWithFrame:CGRectMake((self_W - 80) / 2, (self_W - 80) / 2, 80, 80)];
    [self addSubview:_iconBgView];
    
    _iconBgView.backgroundColor = [UIColor whiteColor];
    _iconBgView.layer.masksToBounds = YES;
    _iconBgView.layer.cornerRadius = 40;
    
    //头像
    _iconImgView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 76, 76)];
    [_iconBgView addSubview:_iconImgView];

    _iconImgView.layer.masksToBounds = YES;
    _iconImgView.layer.cornerRadius = 38;
    UITapGestureRecognizer *pickImgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
    
    [_iconImgView addGestureRecognizer:pickImgTap];
    self.userInteractionEnabled = YES;
    _iconBgView.userInteractionEnabled = true;
    _iconImgView.userInteractionEnabled = true;
    _coverView.userInteractionEnabled = true;
    
    _userIdLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, (self_W - 80) / 2 + 88, self_W, 80)];
    [self addSubview:_userIdLbl];
    
    _userIdLbl.text = @"未命名";
    _userIdLbl.textColor = COLOR_RGB16(0xffffff);
    _userIdLbl.font = [UIFont systemFontOfSize:16];
    _userIdLbl.textAlignment = NSTextAlignmentCenter;
    
    self.image = [self boxblurImage:[UIImage imageNamed:@"Luff.jpeg"] withBlurNumber:0.4];
    _iconImgView.image = [UIImage imageNamed:@"Luff.jpeg"];
    
}

-(void)setUserIdName:(NSString *)userIdName{

    _userIdName = userIdName;
    _userIdLbl.text = userIdName;
}

- (void)setUserIconImg:(UIImage *)userIconImg{

    _userIconImg = userIconImg;
    _iconImgView.image = userIconImg;
    self.image = [self boxblurImage:userIconImg withBlurNumber:0.4];
}


#pragma mark - 设置背景图模糊效果
- (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur
{
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}


- (void)changeIcon{
    
    if (_changeIconBlock) {
        _changeIconBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
