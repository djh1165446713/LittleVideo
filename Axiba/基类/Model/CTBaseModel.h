//
//  CTBaseModel.h
//  CT
//
//  Created by Peter on 15/9/11.
//  Copyright (c) 2015年 VizLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JSONModel.h>

@interface CTBaseModel : JSONModel
@property (nonatomic,copy) NSString<Optional> *rspCode;
@property (nonatomic,copy) NSString<Optional> *rspMsg;
@end

@interface ABPageModel : CTBaseModel
@property (nonatomic, strong) NSNumber  *currentPageCount;
@property (nonatomic, strong) NSNumber  *pageSize;
@property (nonatomic, strong) NSNumber  *pageNumber;
@property (nonatomic, strong) NSNumber  *totalPage;
@end
