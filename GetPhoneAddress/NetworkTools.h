//
//  NetworkTools.h
//  ZYXMPPChat
//
//  Created by Peyton on 2019/3/19.
//  Copyright © 2019 李坚. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^successBlock)(NSDictionary *dic);
typedef void (^failureBlock)(NSError *error);

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTools : NSObject

+ (void)getDataWithURLString:(NSString *)url parameters:(NSDictionary * _Nullable)parameters success:(successBlock)succeed failed:(failureBlock)failed;

+ (void)postDataWithURLString:(NSString *)url parameters:(NSDictionary * _Nullable)parameters success:(successBlock)succeed failed:(failureBlock)failed;

@end

NS_ASSUME_NONNULL_END
