//
//  AddressModel.h
//  addressPicker
//
//  Created by 汪泽天 on 2018/7/26.
//  Copyright © 2018年 霍. All rights reserved.
//
/**
 
 {
 "citycode": [],
 "adcode": "440000",
 "name": "广东省",
 "center": "113.280637,23.125178",
 "level": "province",
 "districts": [
 {
 "citycode": "0754",
 "adcode": "440500",
 "name": "汕头市",
 "center": "116.708463,23.37102",
 "level": "city",
 "districts": [
 {
 "citycode": "0754",
 "adcode": "440523",
 "name": "南澳县",
 "center": "117.027105,23.419562",
 "level": "district",
 "districts": []
 }
 }
 }
 */

#import <Foundation/Foundation.h>

@interface AddressModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSArray <AddressModel *>*districts;

@property (nonatomic, assign) BOOL isSelect;

+ (instancetype)AddressModelWithDict:(NSDictionary *)dict;

@end
