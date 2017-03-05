//
//  BaseViewController.m
//  CCF-Project
//
//  Created by Joshua Jose Pecson on 25/01/2017.
//  Copyright © 2017 JoVhengshua Apps. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIWebView *webview;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)viewMapButton:(id)sender {
    
    UIButton *button = (UIButton*)sender;
    
    MapViewController *mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"mapsVC"];
    mapVC.titleName = button.locationName;
    mapVC.snippet = button.locationSnippet;
    mapVC.longitude = [button.longitude floatValue];
    mapVC.latitude = [button.latitude floatValue];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.6;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [mapVC.view.layer addAnimation:transition forKey:nil];
    
    
    mapVC.view.frame = self.view.bounds;
    [self.view addSubview:mapVC.view];
    [self addChildViewController:mapVC];
    [mapVC didMoveToParentViewController:self];
}

- (IBAction)backButton:(id)sender {
    
    UIView *viewShown = [[[(self.parentViewController.view) viewWithTag:1990] subviews] lastObject];
    
    if (viewShown == nil) {
        NSLog(@"ERROR !!");
        
        return;
    }
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.3;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.parentViewController.view.layer addAnimation:transition forKey:nil];
    
    [viewShown removeFromSuperview];
    
    [self removeFromParentViewController];
    
    
}

- (IBAction)facebookButton:(id)sender {
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Facebook?" message:@"Would you like to follow our Facebook Page?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showWebViewWithURL:@"https://www.facebook.com/TheCCFCenter"];
    }];
    
    [ac addAction:cancel];
    [ac addAction:ok];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)twitterButton:(id)sender {
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Twitter?" message:@"Would you like to follow our Twitter?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showWebViewWithURL:@"https://twitter.com/CCFmain"];
    }];
    
    [ac addAction:cancel];
    [ac addAction:ok];
    
    [self presentViewController:ac animated:YES completion:nil];
}


- (IBAction)googleplusButton:(id)sender {
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Google+?" message:@"Would you like to follow our Google+?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showWebViewWithURL:@"https://plus.google.com/110122766101184546528"];
    }];
    
    [ac addAction:cancel];
    [ac addAction:ok];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (IBAction)youtubeButton:(id)sender {
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Follow Youtube?" message:@"Would you like to follow our Youtube?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"CANCEL" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self showWebViewWithURL:@"https://www.youtube.com/user/CCFmainTV"];
    }];
    
    [ac addAction:cancel];
    [ac addAction:ok];
    
    [self presentViewController:ac animated:YES completion:nil];
}

- (void) showWebViewWithURL:(NSString*)urlString {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    self.backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    
    [window addSubview:self.backgroundView];
    
    if (!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.backgroundView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.backgroundView addSubview:blurEffectView];
    } else {
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.3f alpha:0.5f];
    }
    
    self.webview = [[UIWebView alloc] initWithFrame:CGRectMake(15.0f, 15.0f, self.backgroundView.frame.size.width - 30.0f, self.backgroundView.frame.size.height - 30.0f)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    self.webview.backgroundColor = [UIColor clearColor];
    self.webview.scrollView.bounces = NO;
    self.webview.delegate = self;
    self.webview.scalesPageToFit = YES;
    
    self.webview.layer.borderColor = [UIColor blackColor].CGColor;
    self.webview.layer.borderWidth = 2.0f;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"close-button"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(-15.0f, -15.0f, 28.0f, 28.0f)];
    button.layer.zPosition = 1.0f;
    
    [self.webview addSubview:button];
    
    UITapGestureRecognizer *tapClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeWebView)];
    [self.backgroundView addGestureRecognizer:tapClose];
    
    [self.backgroundView addSubview:self.webview];
    
    self.webview.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.webview.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.webview.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        } completion:^(BOOL finished) {
            [self.webview loadRequest:request];
        }];
    }];
    
    
}

- (void) closeWebView {
    
    [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.webview.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
    }];
    
}

- (void) openURL:(NSString*)urlstring {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlstring] options:@{} completionHandler:^(BOOL success) {
        
    }];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
    UIAlertController *ac  = [UIAlertController alertControllerWithTitle:@"Error Loading Page" message:@"We experienced loading the page. Try again later." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [ac addAction:cancel];
    
    [self presentViewController:ac animated:YES completion:nil];
}

@end
