//
//  ViewController.m
//  3DPictureRotation
//
//  Created by 区振轩 on 16/7/26.
//  Copyright © 2016年 区振轩. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>


@interface ViewController ()

@property (nonatomic,assign)   CGPoint originalPoint;
@property (nonatomic,assign)   int imageNum;
@property (nonatomic,strong) UIImageView * showImageView;

@property (nonatomic,strong) CMMotionManager * motionManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _imageNum = 0 ;
    UIView * panView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    panView.backgroundColor = [UIColor yellowColor];
    panView.userInteractionEnabled = YES;
    
    [self.view addSubview:panView];
    
    
    UIPanGestureRecognizer * thePan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandler:)];
    
    [panView addGestureRecognizer:thePan];
    
    
    _showImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 200, 300, 300)];
    
    [self startmotion];
    
    [self.view addSubview:_showImageView];
    _showImageView.image = [UIImage imageNamed:@"im-0"];
    
}

- (void)panHandler:(UIPanGestureRecognizer *)panRecognizer{
    
    CGPoint thePoint = [panRecognizer translationInView:panRecognizer.view];
    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
        _originalPoint = [panRecognizer translationInView:panRecognizer.view];
    }else if (panRecognizer.state == UIGestureRecognizerStateChanged){
        NSLog(@"%f",thePoint.x);
        [panRecognizer setTranslation:CGPointZero inView:panRecognizer.view];
        _imageNum += floor(thePoint.x);
        _imageNum = _imageNum>168?_imageNum-168 : _imageNum;
        _imageNum = _imageNum<0?_imageNum+168:_imageNum;
        
        
        _showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"im-%d",_imageNum]];
        
    }else if (panRecognizer.state == UIGestureRecognizerStateEnded){
        NSLog(@"end");
    }
    
}

//开始手机磁罗盘校准
#pragma mark 手机磁罗盘进行校准
- (void)startmotion
{
    //手机磁罗盘校准
    self.motionManager = [[CMMotionManager alloc] init];
    
    if ([self.motionManager isAccelerometerAvailable])
    {
        
        
        [self.motionManager startGyroUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMGyroData *gyroData, NSError *error) {
            
            [self.motionManager startDeviceMotionUpdates];
            
            
            double roll =  self.motionManager.deviceMotion.attitude.roll;
            
            _imageNum = floor(roll * 180/M_PI) ;
            _imageNum = _imageNum>168?168 : _imageNum;
            _imageNum = _imageNum<-168?-168:_imageNum;
            
            NSLog(@"%d",_imageNum);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _showImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"im-%d",_imageNum]];
            });
            
            
            
            double pitch =  self.motionManager.deviceMotion.attitude.pitch;
            double yaw =  self.motionManager.deviceMotion.attitude.yaw;
            
            
            NSLog(@"root=%f,pitch=%f,yaw=%f",roll,pitch,yaw);
//            [self.motionManager stopGyroUpdates];
//            [self.motionManager stopDeviceMotionUpdates];
            
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end















