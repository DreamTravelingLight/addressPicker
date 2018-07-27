//
//  AddressPickerView.h
//  addressPicker
//
//  Created by 汪泽天 on 2018/7/26.
//  Copyright © 2018年 霍. All rights reserved.
//


#import <UIKit/UIKit.h>

@class AddressModel;

typedef NS_ENUM(NSUInteger, pickerViewSelectType) {
    PickerViewSelectTypeProvince,
    PickerViewSelectTypeCity,
    PickerViewSelectTypeDistrict
};

@interface AddressPickerView : UIView

typedef void (^selectBlock)(AddressModel *provinceModel , AddressModel *cityModel , AddressModel *districtModel);

+ (void)showPickerViewWithFrame:(CGRect)frame AddressDataArray:(NSArray *)dataArray resultBlock:(selectBlock)block;


//访问
@property (nonatomic) pickerViewSelectType selectType;

@property (nonatomic, strong) AddressModel *provinceModel;
@property (nonatomic, strong) AddressModel *cityModel;
@property (nonatomic, strong) AddressModel *districtModel;

@end
