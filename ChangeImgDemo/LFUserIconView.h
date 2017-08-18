//
//  LFUserIconView.h
//  SmartHome
//
//  Created by LeadFair on 2017/7/8.
//  Copyright © 2017年 leadfair. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^LFChangeIconBlock) ();

@interface LFUserIconView : UIImageView

@property (nonatomic,copy) LFChangeIconBlock changeIconBlock;

@property (nonatomic,strong) NSString *userIdName;

@property (nonatomic,strong) UIImage *userIconImg;

@end
