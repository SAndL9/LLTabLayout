//
//  LLMainViewController.h
//  LLTabLayout
//
//  Created by LiLei on 9/5/2019.
//  Copyright © 2019 李磊. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LLDemoType) {
    LLDemoTypeFixedWidth,
    LLDemoTypeAutomatic,
    LLDemoTypeDefaultIndex,
};


@interface LLMainViewController : UIViewController

@property (nonatomic, assign) LLDemoType demoType;

@end

NS_ASSUME_NONNULL_END
