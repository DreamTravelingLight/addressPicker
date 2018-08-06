//
//  AddressTableView.m
//  addressPicker
//
//  Created by 汪泽天 on 2018/7/26.
//  Copyright © 2018年 霍. All rights reserved.
//

#import "AddressTableView.h"
#import "AddressModel.h"

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface AddressTableView () <UITableViewDelegate, UITableViewDataSource>
{
    
}
@end

@implementation AddressTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    self = [super initWithFrame:frame style:style];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        self.rowHeight = 40;
        self.allowsSelection = YES;
        self.tableFooterView = [UIView new];
    }
    return self;
}

#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ident = @"AddressTableViewCellIdent";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    AddressModel *model = _dataArray[indexPath.row];
    cell.textLabel.text = model.name;
    
    cell.accessoryType = [model isEqual:_selectModel] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddressModel *model = _dataArray[indexPath.row];
    !self.tableViewCellDidSelectCellBlock ?: self.tableViewCellDidSelectCellBlock(indexPath,model);
}

@end
