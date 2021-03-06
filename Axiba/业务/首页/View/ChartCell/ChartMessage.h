//
//  ChartMessage.h
//  气泡
//
//  Created by zzy on 14-5-13.
//  Copyright (c) 2014年 zzy. All rights reserved.
//
typedef enum {
  
    kMessageFrom=0,
    kMessageTo
 
}ChartMessageType;
#import <Foundation/Foundation.h>
#import "ABCommandListModel.h"

@interface ChartMessage : NSObject
@property (nonatomic,assign) ChartMessageType messageType;
@property (nonatomic,  copy) NSString       *icon;
@property (nonatomic,  copy) NSString       *time;
@property (nonatomic,  copy) NSString       *name;
@property (nonatomic,  copy) NSString       *content;
@property (nonatomic,  copy) NSString       *otherInfo;
@property (nonatomic,  copy) NSDictionary   *dict;
@property (nonatomic,  copy) ABCommentModel *commentModel;
@end
