//
//  DemoTaggingMediaViewController.m
//  DemoAppInfra
//
//  Created by Murali on 9/17/16.
//  Copyright © 2016 philips. All rights reserved.
//

#import "DemoTaggingMediaViewController.h"
#import "AilShareduAppDependency.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#define VIDEOFILENAME @"DemoTaggingPlayback"
#define FILETYPE    @"mov"

@interface DemoTaggingMediaViewController ()
{
    AVPlayerViewController *movieViewController;
}

@end

@implementation DemoTaggingMediaViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem setTitle:@"App Tagging Video"];
    [self configureMedia];
}
    
    
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureNotifications];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) configureMedia
{
    NSBundle *bundle = [NSBundle bundleForClass:self.class];
    NSString *moviePath = [bundle pathForResource:VIDEOFILENAME ofType:FILETYPE];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath] ;
    movieViewController = [[AVPlayerViewController alloc] init];
    movieViewController.player = [AVPlayer playerWithURL:movieURL];
    movieViewController.showsPlaybackControls = YES;
}

- (void) configureNotifications{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AVMoviePlayerPlaybackStateDidFail:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:nil];
}

// display and begin playing the media
- (IBAction)playMedia:(id)sender {
    [self presentViewController:movieViewController animated:YES completion:^{
        [self->movieViewController.player play];
        [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackVideoStart:@"DemoTaggingPlayback.mov"];
    }];
}

-(void)AVMoviePlayerPlaybackStateDidFail:(NSNotification *)notification{
    [[AilShareduAppDependency sharedDependency].uAppDependency.appInfra.tagging trackVideoEnd:@"DemoTaggingPlayback.mov"];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:nil];
}

@end
