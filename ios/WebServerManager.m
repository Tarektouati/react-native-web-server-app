//
//  - Name it WebServerManager - Name it WebServerManager - Name it WebServerManager ## Expose `WebServerManager` methods to React Native Bridge WebServerManager.m
//  WebServerApp
//
//  Created by tarek touati on 22/11/2019.
//  Copyright © 2019 Facebook. All rights reserved.
//

#import "React/RCTBridgeModule.h"

@interface RCT_EXTERN_MODULE(WebServerManager, NSObject)
RCT_EXTERN_METHOD(initWebServer)
RCT_EXTERN_METHOD(startServer: (RCTPromiseResolveBlock) resolve
                  rejecter: (RCTPromiseRejectBlock)reject)
RCT_EXTERN_METHOD(stopServer)
@end
