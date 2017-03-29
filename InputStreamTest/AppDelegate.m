//
//  AppDelegate.m
//  InputStreamTest
//
//  Created by Chris Eidhof on 06/17/13.
//  Copyright (c) 2013 Chris Eidhof. All rights reserved.
//

#import "AppDelegate.h"
#import "Reader.h"

@interface AppDelegate ()

@property (nonatomic, strong) Reader *reader;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UILabel *label;

@end


/*
 错误提示：虽然编译通过，也能运行，但是底下有错误提示“application windows are expected to have a root view controller”
 
 原因：在较新的xcod上都会出现这种错误。在iOS5之前的版本，应用加载时，需要一个root view controller，在iOS5以下的版本会有MainWindow作为启动文件，iOS5以后的版本没有了。需要手动创建一个root view controller
 */
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *rootViewController = [[UIViewController alloc] init];
    rootViewController.view.backgroundColor = [UIColor whiteColor];
    [rootViewController.view setFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController  = rootViewController;
    
    [self addViews];

    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)addViews
{
    self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.button.frame = CGRectMake(0, 10, 320, 100);
    [self.button addTarget:self action:@selector(import:) forControlEvents:UIControlEventTouchUpInside];
    [self.button setTitle:@"Press Me" forState:UIControlStateNormal];
    [self.window.rootViewController.view addSubview:self.button];

    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 120, 320, 64)];
    slider.continuous = YES;
    [slider addTarget:self action:@selector(sliderMoved:) forControlEvents:UIControlEventValueChanged];
    [self.window.rootViewController.view addSubview:slider];

    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 200, 320, 64)];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.window.rootViewController.view addSubview:self.label];
}

- (void)sliderMoved:(UISlider *)sender;
{
    self.label.text = [NSString stringWithFormat:@"%g", [sender value]];
}

- (void)import:(id)sender
{
    NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"Clarissa Harlowe" withExtension:@"txt"];
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]], @"Please download the sample data");
    
    self.reader = [[Reader alloc] initWithFileAtURL:fileURL];
    [self.reader enumerateLinesWithBlock:^(NSUInteger i, NSString *line){
        if ((i % 2000ull) == 0) {
            NSLog(@"i: %d", i);
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.button setTitle:line forState:UIControlStateNormal];
            }];
        }
    } completionHandler:^(NSUInteger numberOfLines){
        NSLog(@"lines: %d", numberOfLines);
        [self.button setTitle:@"Done" forState:UIControlStateNormal];
    }];
}

@end
