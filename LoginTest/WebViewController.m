//
//  WebViewController.m
//  LoginTest
//
//  Created by Ajay Awasthi on 03/08/19.
//  Copyright © 2019 Ajay Awasthi. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "WebViewController.h"



@interface WebViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;
@property (strong, nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadUrl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)loadUrl
{
    _indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.hidesWhenStopped = YES;
    _indicator.color = [UIColor blackColor];
    _indicator.frame = CGRectMake(35, 15, 60, 60);
    _indicator.center = self.view.center;
    
    _webView = [[WKWebView alloc] initWithFrame:self.view.frame];
    _webView.frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    _webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    [self.view addSubview:_indicator];
    [self.view bringSubviewToFront:_indicator];
    
    [_indicator startAnimating];
    NSString *urlBase = [NSString stringWithFormat:@"https://mckinleyrice.com?token=%@",self.userToken];
    
    NSURL *url = [NSURL URLWithString:urlBase];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [_indicator stopAnimating];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
