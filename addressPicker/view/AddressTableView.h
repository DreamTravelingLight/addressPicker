//
//  AddressTableView.h
//  addressPicker
//
//  Created by 汪泽天 on 2018/7/26.
//  Copyright © 2018年 霍. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressModel;

@interface AddressTableView : UITableView

@property (nonatomic, copy) NSArray <AddressModel *>*dataArray;

@property (nonatomic, copy) void (^tableViewCellDidSelectCellBlock)(NSIndexPath *indexPath, AddressModel *addressModel);

//@property (nonatomic, strong) AddressModel *provinceModel;
//@property (nonatomic, strong) AddressModel *cityModel;
//@property (nonatomic, strong) AddressModel *districtModel;
@property (nonatomic, strong) AddressModel *selectModel;

@end
