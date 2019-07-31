//
//  NetworkTools.m
//  ZYXMPPChat
//
//  Created by Peyton on 2019/3/19.
//  Copyright © 2019 李坚. All rights reserved.
//

#import "NetworkTools.h"
#import "AFNetworking.h"

static const int timeoutInterval = 15;

@implementation NetworkTools

+ (void)getDataWithURLString:(NSString *)url parameters:(NSDictionary * _Nullable)parameters success:(successBlock)succeed failed:(failureBlock)failed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 15;
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //成功
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dic = (NSDictionary *)responseObject;
        succeed(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //失败
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failed(error);
    }];
}

+ (void)postDataWithURLString:(NSString *)url parameters:(NSDictionary *)parameters success:(successBlock)succeed failed:(failureBlock)failed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = timeoutInterval;
    
    
    [manager POST:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        //成功
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dic = (NSDictionary *)responseObject;
        succeed(dic);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        //失败
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        failed(error);
    }];
    
}
@end
