//
//  AnimationSectionViewController.m
//  IOSProgrammerTest
//
//  Created by Kritsakorn on 7/24/15.
//  Copyright (c) 2015 Kritsakorn. All rights reserved.
//


#import "AnimationSectionViewController.h"
#import "MainMenuViewController.h"

@interface AnimationSectionViewController ()
@property (nonatomic, strong) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@end

@implementation AnimationSectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"ANIMATION";
    [self.view sendSubviewToBack:self.backgroundImageView];
    //[self customizeTextView];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Spin the icon
- (IBAction)spinAction:(id)sender
{
   CABasicAnimation* rotationAnimation1;
    rotationAnimation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation1.toValue = [NSNumber numberWithFloat: M_PI * 2];
    rotationAnimation1.duration = 1.0;
    rotationAnimation1.repeatCount = 1;
    [self.iconView.layer addAnimation:rotationAnimation1 forKey:@"rotationAnimation"];
}

#pragma mark - Drag the icon
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch view] == self.iconView)
    {
        CGPoint touchPosition = [touch locationInView:touch.window];
        CGRect oldFrame = self.iconView.frame;
        CGRect newFrame = CGRectMake(touchPosition.x - oldFrame.size.width/2, touchPosition.y -oldFrame.size.height/2, oldFrame.size.width, oldFrame.size.height);
        self.iconView.frame = newFrame;
    }
}


@end
