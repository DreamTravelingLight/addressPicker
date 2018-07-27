//
//  ViewController.m
//  addressPicker
//
//  Created by 汪泽天 on 2018/7/26.
//  Copyright © 2018年 霍. All rights reserved.
//
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

#import "ViewController.h"
#import "AddressModel.h"
#import "AddressPickerView.h"

@interface ViewController ()

{
    NSArray *_dataArray;
    UILabel *_textLab;
}
@property (nonatomic, strong) AddressPickerView *addressView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 100, 40);
    [btn setTitle:@"显示" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    [self requestAddressData];
}
- (void)addPickerView {
    
    [AddressPickerView showPickerViewWithFrame:CGRectMake(0, kScreenHeight-300, kScreenWidth, 300) AddressDataArray:_dataArray resultBlock:^(AddressModel *provinceModel, AddressModel *cityModel, AddressModel *districtModel) {
        NSLog(@"--province : %@ -- city : %@  district : %@",provinceModel.name,cityModel.name,districtModel.name);
    }];
}
#pragma mark - request data
- (void)requestAddressData {
    
    /**
     6230cd50458b49637e3376cb67a2b108
     https://restapi.amap.com/v3/config/district
     subdistrict  返回的层级数  3级4级以上都可以
     */
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://restapi.amap.com/v3/config/district?key=6230cd50458b49637e3376cb67a2b108&subdistrict=3"]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSDictionary *totalDic = [dict[@"districts"] firstObject];
            NSMutableArray *arrM = [NSMutableArray array];
            for (NSDictionary *dict in totalDic[@"districts"]) {
                AddressModel *model = [AddressModel AddressModelWithDict:dict];
                [arrM addObject:model];
            }
            _dataArray = [arrM copy];
//            [self addPickerView];
            NSLog(@"----success---");
        }
    }];
    [dataTask resume];
}

- (void)buttonClick{
    
    [self addPickerView];
}

@end
