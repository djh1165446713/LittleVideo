//
//  CTWebViewVC.m
//  TP
//
//  Created by Peter on 15/9/25.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import "CTWebViewVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "LVHomeleftController.h"
#import "ABHomeVC.h"
#import <WebKit/WebKit.h>
@protocol MyWebViewProtocol <JSExport>
@end


@interface CTWebViewVC ()<WKUIDelegate,WKNavigationDelegate,MyWebViewProtocol>
@property (nonatomic, weak  ) JSContext *jsContext;
@property (nonatomic, strong) WKWebView *web;
@end

@implementation CTWebViewVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUIS];
}


- (void)initUIS {
    ______WS();
    [self setShowBackBtn:YES];
    self.bDisableGesture = YES;
    
    [self actionBack:^{
        if (wSelf.isPop) {
            CTBaseNavVC *baseNavVC = [[CTBaseNavVC alloc] initWithRootViewController:[[ABHomeVC alloc] init]];
            LVHomeleftController  *leftCro = [[LVHomeleftController alloc] init];
            CTBaseNavVC *leftNav = [[CTBaseNavVC alloc] initWithRootViewController:leftCro];
            leftNav.navigationBar.hidden = YES;
            MMDrawerController *mmdVC = [[MMDrawerController alloc] initWithCenterViewController:baseNavVC leftDrawerViewController:leftNav];
            [UIApplication sharedApplication].delegate.window.rootViewController = mmdVC;
        }else{
            [wSelf.navigationController popViewControllerAnimated:YES];
        }
    }];
    
    self.web = [[WKWebView alloc] initWithFrame:self.view.bounds];
    self.web.backgroundColor = [UIColor clearColor];
    self.web.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.web];
    self.web.UIDelegate = self;
    self.web.navigationDelegate = self;

    [self.web loadRequest:[NSURLRequest requestWithURL:self.url]];
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"%@",navigationAction.request.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationActionPolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationActionPolicyCancel);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}



#pragma mark - JsAction

@end
