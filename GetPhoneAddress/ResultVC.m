//
//  ResultVC.m
//  GetPhoneAddress
//
//  Created by Peyton on 2019/7/29.
//  Copyright © 2019 Peyton. All rights reserved.
//

#import "ResultVC.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@interface ResultVC ()<WKNavigationDelegate>
@property (weak, nonatomic) IBOutlet WKWebView *webView;

@end

@implementation ResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.navigationDelegate = self;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *str2 = [self.address componentsJoinedByString:@"<br>"];
    NSString *jsString = [NSString stringWithFormat:@"showAddresses('%@')", str2];
    [self.webView evaluateJavaScript:jsString completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        //调用JS方法结束后的动作放这里
    }];
}

- (IBAction)disMiss:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)getJSONString {
    NSDictionary *dic = @{@"addresses" : self.address};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}

#pragma mark lazy
- (NSArray *)address {
    if (!_address) {
        _address = [NSArray array];
    }
    return _address;
}

@end
