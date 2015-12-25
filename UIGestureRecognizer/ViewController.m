//
//  ViewController.m
//  UIGestureRecognizer
//
//  Created by admin on 15/8/11.
//  Copyright (c) 2015年 admin. All rights reserved.
//

#import "ViewController.h"

#define kOldFrame CGRectMake(50,200,275,267)

@interface ViewController ()
{

    UIView *_greenView;
}
@end

/**
 要使用手势的步骤：
 1.产生手势识别器对象
 2.设置参数
 3.添加监听方法   即触发的事件
 4.把手势识别器对象添加到适当的视图上
 
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _greenView = [[UIView alloc]initWithFrame:kOldFrame];
    [_greenView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:_greenView];
    
    /*
        六大手势
        1点击 轻点  tap
        2长按long press
        3捏合  pinch
        4扫 划  swipe
        5 拖动 pan
        6 旋转	  rotation
     */
    
    //点击手势
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
    [_greenView addGestureRecognizer:tgr];
    
    //long Press
    SEL longGesture = @selector(longPressGesture:);
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:longGesture];
    
    //为_greenView添加手势
    [_greenView addGestureRecognizer:lpgr];
    
    //pinch 手势
    UIPinchGestureRecognizer *pgr = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
    
    [_greenView addGestureRecognizer:pgr];
    
    //扫划手势
    UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    
    [sgr setDirection:UISwipeGestureRecognizerDirectionLeft];
    [_greenView addGestureRecognizer:sgr];
    
    //拖拽手势 pan
    UIPanGestureRecognizer *pgr2 = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [_greenView addGestureRecognizer:pgr2];
    
    //旋转手势 rotation
    UIRotationGestureRecognizer *rgr = [[UIRotationGestureRecognizer alloc]init];
    [rgr addTarget:self action:@selector(rotationGesture:)];
    [_greenView addGestureRecognizer:rgr];
    
}
#pragma mark 点击手势将view移出屏幕然后移回
-(void)tapGesture:(UITapGestureRecognizer *)sender
{
   // NSLog(@"%@",sender);
    //CGPoint point = [sender locationInView:self.view];
    //[_greenView setCenter:point];}
    
    CGRect newFrame = kOldFrame;
    newFrame.origin.y+=500;
    [UIView animateWithDuration:0.5f animations:^{
        [_greenView setFrame:newFrame];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5f animations:^{
            [_greenView setFrame:kOldFrame];
        }];
    }];
}
#pragma mark longPress 手势 将_greenView旋转一定角度
-(void)longPressGesture:(UILongPressGestureRecognizer *)sender
{
    if (UIGestureRecognizerStateBegan ==  sender.state) {
        [UIView animateWithDuration:0.5f animations:^{
            [_greenView setTransform:CGAffineTransformMakeRotation(M_PI_4)];
        } completion:^(BOOL finished) {
            [_greenView setTransform:CGAffineTransformIdentity];
        }];
    }

}
#pragma mark pinch手势 将_greenView 放大或者缩小一定比例
-(void)pinchGesture:(UIPinchGestureRecognizer *)sender
{
    if (UIGestureRecognizerStateChanged == sender.state) {
        [UIView animateWithDuration:0.5f animations:^{
            [_greenView setTransform:CGAffineTransformMakeScale(sender.scale, sender.scale)];
        } completion:^(BOOL finished) {
            [_greenView setTransform:CGAffineTransformIdentity];
        }];
    }
}
#pragma mark swipe手势将_greenView 移出屏幕再恢复
-(void)swipeGesture:(UISwipeGestureRecognizer *)sender
{
    if(sender.direction== UISwipeGestureRecognizerDirectionLeft)
    {
        UIBezierPath *path = [UIBezierPath bezierPath];
        CGPoint toPoint = CGPointMake(-300, sender.view.frame.origin.y);
        CGPoint fromPoint = [_greenView center];
        [path moveToPoint:fromPoint];
        [path addQuadCurveToPoint:toPoint controlPoint:CGPointMake(100, sender.view.frame.origin.y)];
        
        //关键帧动画
        CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        position.path = path.CGPath ;
        position.speed = 3;
        //自动恢复
        position.autoreverses = YES;
        position.duration = 1.0f;
        [_greenView.layer addAnimation:position forKey:@"position"];
    
    }

}
#pragma mark 拖拽pan手势 将_greenView的中心点设置成拖拽的点
-(void)panGesture:(UIPanGestureRecognizer *)sender
{
    CGRect newFrame = kOldFrame;
    CGPoint movePoint = [sender translationInView:self.view];
    newFrame.origin.x+=movePoint.x;
    newFrame.origin.y+=movePoint.y;
    [UIView animateWithDuration:0.2f animations:^{
        [_greenView setFrame:newFrame];
    }];
    
}
#pragma mark 旋转手势 将_greenView进行相应的旋转
-(void)rotationGesture:(UIRotationGestureRecognizer *)sender
{
    CABasicAnimation *rotationTran = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationTran.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    rotationTran.toValue = [NSValue valueWithCGAffineTransform:CGAffineTransformMakeRotation(sender.rotation)];
    rotationTran.duration = 1.0f;
    rotationTran.speed = 5;
    [_greenView.layer addAnimation:rotationTran forKey:@"rotation"];
}
@end
