//
//  AddressPickerView.m
//  addressPicker
//
//  Created by 汪泽天 on 2018/7/26.
//  Copyright © 2018年 霍. All rights reserved.
//

#import "AddressPickerView.h"
#import "AddressTableView.h"
#import "AddressModel.h"

#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

@interface AddressPickerView ()
{
    CALayer *_line;
}
@property (weak, nonatomic) UIView *maskView;
@property (nonatomic, strong) AddressTableView *tableView;

@property (nonatomic, strong) UIButton *provinceBtn;
@property (nonatomic, strong) UIButton *cityBtn;
@property (nonatomic, strong) UIButton *districtBtn;

@property (nonatomic, strong) UIButton *selectBtn;

@property (nonatomic, copy) NSArray *addressArr;

@property (nonatomic, copy) void (^selectBlock)(AddressModel *provinceModel , AddressModel *cityModel , AddressModel *districtModel, NSString *addressStr);

@end

@implementation AddressPickerView

- (void)dealloc {
    
    NSLog(@"AddressPickerView dealloc");
}
+ (void)showPickerViewWithFrame:(CGRect)frame AddressDataArray:(NSArray *)dataArray resultBlock:(selectBlock)block {
    
    AddressPickerView *view = [[AddressPickerView alloc] initWithFrame:frame];
    view.addressArr = dataArray;
    view.selectBlock = block;
    [view addView];
}
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addWindowView];
        [self addCloseButton];
    }
    return self;
}
#pragma mark - add view
- (void)addCloseButton {
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame = CGRectMake(kScreenWidth-22, 5, 13, 13);
    [deleteBtn setImage:[UIImage imageNamed:@"close_24@2x"] forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(hidePickerView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:deleteBtn];
}
- (void)addWindowView {
    
    //在window上加载遮罩视图
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow endEditing:YES];
    UIView *maskView = [[UIView alloc] initWithFrame:keyWindow.bounds];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    _maskView = maskView;
    
    //在遮罩视图上加入单击手势用来响应hidePickerView方法
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskViewSingleTapInvoked:)];
    [maskView addGestureRecognizer:singleTap];
    [keyWindow addSubview:maskView];
    
    //在window上加载self
    [keyWindow addSubview:self];
    
    self.backgroundColor = [UIColor whiteColor];
}
- (void)addView {
    
    NSArray *titles = @[@"请选择",@"",@""];
    for (int i = 0; i<3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*100, 20, 100, 35);
        [btn setTitle:titles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectAddressAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 122+i;
        [self addSubview:btn];
        
        if (i == 0) {
            btn.selected = YES;
            _selectBtn = btn;
            _provinceBtn = btn;
            
            _line = [[CALayer alloc] init];
            _line.frame = CGRectMake(CGRectGetMinX(btn.frame)+25, CGRectGetMaxY(btn.frame), 50, .6);
            _line.backgroundColor = [UIColor orangeColor].CGColor;
            [self.layer addSublayer:_line];
            
        }else if (i == 1) {
            _cityBtn = btn;
        }else{
            _districtBtn = btn;
        }
    }
    _tableView = [[AddressTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_provinceBtn.frame)+2, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)-CGRectGetMaxY(_provinceBtn.frame)-2) style:UITableViewStylePlain];
    _tableView.dataArray = _addressArr;
    __weak typeof(self)weakSelf = self;
    _tableView.tableViewCellDidSelectCellBlock = ^(NSIndexPath *indexPath, AddressModel *addressModel) {
        
        if (weakSelf.selectType == PickerViewSelectTypeProvince) {
            weakSelf.provinceModel = addressModel;
        }else if (weakSelf.selectType == PickerViewSelectTypeCity){
            weakSelf.cityModel = addressModel;
        }else{
            weakSelf.districtModel = addressModel;
            [weakSelf hidePickerView];
        }
    };
    [self addSubview:_tableView];
}
#pragma mark - setter method
- (void)setProvinceModel:(AddressModel *)provinceModel {
    
    if (_provinceModel != provinceModel) {
        
        _provinceModel = provinceModel;
        [_provinceBtn setTitle:provinceModel.name forState:UIControlStateNormal];
        //让city选中
        [self selectAddressAction:_cityBtn];
    }
}
- (void)setCityModel:(AddressModel *)cityModel {
    
    if (_cityModel != cityModel) {
        
        _cityModel = cityModel;
        [_cityBtn setTitle:cityModel.name forState:UIControlStateNormal];
        if ([_cityModel.districts count]) {
            
            //让districtBtn选中
            [self selectAddressAction:_districtBtn];
        }
    }
}
- (void)setDistrictModel:(AddressModel *)districtModel {
    
    if (_districtModel != districtModel) {
        _districtModel = districtModel;
        
        [_districtBtn setTitle:districtModel.name forState:UIControlStateNormal];
    }
}
- (void)setSelectBtn:(UIButton *)selectBtn {
    
    if (_selectBtn != selectBtn) {
        
        _selectBtn = selectBtn;
        if (_selectType == PickerViewSelectTypeProvince) {
            
            //将之后 市区 的选中状态清空
            if (!_provinceModel) return;
            NSArray *province = [_addressArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.name = %@",_provinceModel.name]];
            if (!_cityModel && ![province count]) {
                
                [_cityBtn setTitle:@"" forState:UIControlStateNormal];
                [_districtBtn setTitle:@"" forState:UIControlStateNormal];
                
                _cityModel = nil;
                _districtModel = nil;
            }
        }else if (_selectType == PickerViewSelectTypeCity){
            
            //将之后 区 的选中状态清空
            NSArray *city = !_cityModel ? @[] : [_provinceModel.districts filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self.name = %@",_cityModel.name]];
            if (!_cityModel|| ![city count]) {
                
                [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
                [_districtBtn setTitle:@"" forState:UIControlStateNormal];
                _cityModel = nil;
                _districtModel = nil;
            }
        }else{
            if (!_districtModel) {
                
                [_districtBtn setTitle:@"请选择" forState:UIControlStateNormal];
                _districtModel = nil;
            }
        }
    }
}
#pragma mark - gesture actions
- (void)maskViewSingleTapInvoked:(UITapGestureRecognizer *)recognizer {
    
    //先收起键盘，否者会先调用[PopInputView hidePickerView]，再调用键盘收起方法keyboardWillChangeFrame
    [self endEditing:YES];
    [self hidePickerView];
}
#pragma mark - button click
- (void)selectAddressAction:(UIButton *)btn {
    
    if (_selectBtn == btn) return;
    
    NSUInteger tag = btn.tag-122;
    _selectType = tag;
    
    _selectBtn.selected = NO;
    btn.selected = !btn.selected;
    self.selectBtn = btn;
    
    [UIView animateWithDuration:.3 animations:^{
        CGRect frame = _line.frame;
        frame.origin.x = CGRectGetMinX(btn.frame)+25;
        _line.frame = frame;
    }];
    
    switch (_selectType) {
        case PickerViewSelectTypeProvince:
        {
            //刷新省级列表
            _tableView.selectModel = _provinceModel;
            _tableView.dataArray = _addressArr;
            [_tableView reloadData];
        }
            break;
        case PickerViewSelectTypeCity:
        {
            //刷新市级列表
            _tableView.selectModel = _cityModel;
            _tableView.dataArray = _provinceModel.districts;
            
            [_tableView reloadData];
        }
            break;
        case PickerViewSelectTypeDistrict:
        {
            //刷新区级列表
            _tableView.selectModel = _districtModel;
            _tableView.dataArray = _cityModel.districts;
            [_tableView reloadData];
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - method
///隐藏弹出视图
- (void)hidePickerView {
    if (_provinceModel) {
        NSMutableString *addressM = [NSMutableString stringWithString:_provinceModel.name];
        if (_cityModel) {
            [addressM appendString:_cityModel.name];
            if (_districtModel) {
                [addressM appendString:_districtModel.name];
            }
        }
        !self.selectBlock ?: self.selectBlock(_provinceModel,_cityModel,_districtModel,[addressM copy]);
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        //在动画过程中禁止遮罩视图响应用户手势
        _maskView.userInteractionEnabled = NO;
        _maskView.alpha = 0.01;
        
        CGRect frame = self.frame;
        frame.origin.y = kScreenHeight;
        self.frame = frame;
    } completion:^(BOOL finished) {
        
        [_maskView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self endEditing:YES];
}

@end
