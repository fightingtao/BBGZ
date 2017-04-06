//
//  DimChectViewController.h
//  BBZhongBao
//
//  Created by 李志明 on 16/8/31.
//  Copyright © 2016年 CYT. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PublicSouurce.h"
#import <AVFoundation/AVFoundation.h>
@protocol ScannerGoodsDelegate <NSObject>

- (void)getOrder_id:(NSString*)order_id;

@end
@interface DimChectViewController : UIViewController<AVCaptureMetadataOutputObjectsDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
}

@property (strong,nonatomic)AVCaptureDevice * device;
@property (strong,nonatomic)AVCaptureDeviceInput * input;
@property (strong,nonatomic)AVCaptureMetadataOutput * output;
@property (strong,nonatomic)AVCaptureSession * session;
@property (strong,nonatomic)AVCaptureVideoPreviewLayer * preview;
@property (nonatomic, retain) UIImageView * line;
@property(nonatomic,weak)id <ScannerGoodsDelegate>delegate;
@end
