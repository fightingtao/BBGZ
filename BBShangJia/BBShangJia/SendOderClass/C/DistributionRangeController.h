//
//  DistributionRangeController.h
//  BBShangJia
//
//  Created by cbwl on 16/9/24.
//  Copyright © 2016年 CYT. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol selectedDistributionDelegate <NSObject>

-(void)selectedDistribution:(NSString*)text requiment:(NSString *)requiment;
@end

@interface DistributionRangeController : UIViewController
@property(nonatomic,weak)id <selectedDistributionDelegate>delegate;

@end
