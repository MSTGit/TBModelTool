//
//  ViewController.m
//  Property
//
//  Created by tangbin on 2017/2/6.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#define open 0

#import "ViewController.h"
#import "TBModelTool.h"
#import "MJExtension.h"
#import "NSObject+YYModel.h"

//#import "TBKVCModel.h"
//#import "TBMJKitModel.h"
//#import "TBYYModel.h"

@interface ViewController ()
@property (nonatomic,strong) UIScrollView *scrollView;

@end

@implementation ViewController
+ (void)load {
    [NSObject mj_setupReplacedKeyFromPropertyName:^NSDictionary *{
        return @{
                 @"Id" : @"id"
                 };
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString * jsonPath = [[NSBundle mainBundle]pathForResource:@"json" ofType:@"json"];
    NSData * jsonData = [[NSData alloc]initWithContentsOfFile:jsonPath];
    NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    
    [TBModelTool KVC_createModelClassFileWithResource:jsonDic andModelClassFileName:@"TBKVCModel" andReplacedKeyFromPropertyName:@{@"id":@"Id"}];
    
    [TBModelTool MJ_createModelClassFileWithResource:jsonDic andModelClassFileName:@"TBMJKitModel" andReplacedKeyFromPropertyName:nil];
    
    [TBModelTool YYModel_createModelClassFileWithResource:jsonDic andModelClassFileName:@"TBYYModel" andReplacedKeyFromPropertyName:@{@"amount":@"amountamountamountamount"}];
#if open
        [self testKVCWithDic:jsonDic];
        [self testMJKitWithDic:jsonDic];
        [self testYYKitWithDic:jsonDic];
#endif
    
}

#if open

- (void)testKVCWithDic:(NSDictionary *)dic {
    TBKVCModel *kvcModel = [[TBKVCModel alloc]init];
    [kvcModel setValuesForKeysWithDictionary:dic];
    NSLog(@"%@",kvcModel);
}

- (void)testMJKitWithDic:(NSDictionary *)dic {
    TBMJKitModel *mjModel = [TBMJKitModel mj_objectWithKeyValues:dic];
    NSLog(@"%@",mjModel);
}

- (void)testYYKitWithDic:(NSDictionary *)dic {
    TBYYModel *YYModel = [TBYYModel modelWithDictionary:dic];
    NSLog(@"%@",YYModel);
}

#endif

@end
