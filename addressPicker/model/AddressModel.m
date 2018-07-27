//
//  AddressModel.m
//  addressPicker
//
//  Created by 汪泽天 on 2018/7/26.
//  Copyright © 2018年 霍. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+ (instancetype)AddressModelWithDict:(NSDictionary *)dict {
    //省
    AddressModel *model = [[AddressModel alloc] init];
    model.name = dict[@"name"];
    model.level = dict[@"level"];
    //市
    NSMutableArray *cityArrM = [NSMutableArray array];
    for (NSDictionary *cityDic in dict[@"districts"]) {
        AddressModel *cityModel = [AddressModel AddressModelWithDict:cityDic];
//        cityModel.name = cityDic[@"name"];
//        cityModel.level = cityDic[@"level"];
        [cityArrM addObject:cityModel];
        //区
        NSMutableArray *districtArrM = [NSMutableArray array];
        for (NSDictionary *districtDic in cityDic[@"districts"]) {
            AddressModel *districtsModel = [AddressModel AddressModelWithDict:districtDic];
            [districtArrM addObject:districtsModel];
        }
        cityModel.districts = [districtArrM copy];
    }
    model.districts = [cityArrM copy];
    
    return model;
}

@end
