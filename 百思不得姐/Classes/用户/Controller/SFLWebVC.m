//
//  SFLWebVC.m
//  百思不得姐
//
//  Created by Light on 7-11.
//  Copyright © 2016年 Light. All rights reserved.
//

#import "SFLWebVC.h"
#import <NJKWebViewProgress.h>

@interface SFLWebVC()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goBackItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *goForwardItem;
@property (weak, nonatomic) IBOutlet UIProgressView *processView;
/** 进度代理对象 */
@property (nonatomic, strong) NJKWebViewProgress *progress;
@end

@implementation SFLWebVC
- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.progress = [[NJKWebViewProgress alloc] init];
    self.webView.delegate = self.progress;
    __weak typeof(self) weakSelf = self;
    self.progress.progressBlock = ^(float progress) {
        weakSelf.processView.progress = progress;
        
        weakSelf.processView.hidden = (progress == 1.0);
    };
    self.progress.webViewProxyDelegate = self;

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
}

- (IBAction)reflash:(id)sender {
    [self.webView reload];
}

- (IBAction)goBack:(id)sender {
    [self.webView goBack];
}

- (IBAction)goForward:(id)sender {
    [self.webView goForward];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    self.goBackItem.enabled = webView.canGoBack;
    self.goForwardItem.enabled = webView.canGoForward;
}

@end
