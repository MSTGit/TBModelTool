//
//  TBModelTool.h
//  Property
//
//  Created by tangbin on 2017/2/6.
//  Copyright © 2017年 tangbin. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 指定文件生成的位置
*/
#define MODEL_FILE_PATH @"/Users/ducktobey/Documents/GithubDemo/TBModelTool/TBModelTool/ModelToolFiles"

@interface TBModelTool : NSObject


/**
 在每个属性头部生成注释代码,永久保存
 */
+ (void)addRemarkCode;


/**
 移除属性头部注释代码,永久保存
 */
+ (void)removeRemarkCode;

/**
 通过代码生成模型对应模型  适用 MJExtension 框架解析的模型

 @param resource 需要生成的 json 源数据
 @param fileName 最外层模型的名称,⚠️如果json 数据中包含嵌套模型,默认是父模型名+属性名+ Moldel
 @param replacedKeyFromPropertyName   将属性名换为其他,会永久保存,伴随 APP 生命周期 ---> 如将 id 替换为 ID 则字典为@{@"id":@"ID"}
 */
+ (void)MJ_createModelClassFileWithResource:(_Nonnull id)resource andModelClassFileName:(NSString *_Nonnull)fileName andReplacedKeyFromPropertyName:(NSDictionary * _Nullable )replacedKeyFromPropertyName;

/**
 通过代码生成模型对应模型  适用通过 KVC 解析的模型
 */
+ (void)KVC_createModelClassFileWithResource:(_Nonnull id)resource andModelClassFileName:(NSString *_Nonnull)fileName andReplacedKeyFromPropertyName:(NSDictionary *_Nullable)replacedKeyFromPropertyName;

/**
 通过代码生成模型对应模型  适用通过 YYModel 框架解析的模型
 */
+ (void)YYModel_createModelClassFileWithResource:(_Nonnull id)resource andModelClassFileName:(NSString *_Nonnull)fileName andReplacedKeyFromPropertyName:(NSDictionary *_Nullable)replacedKeyFromPropertyName;


/**
 获取在框架中已经存在的属性替换为其他
 */
+ (NSDictionary *_Nullable)getReplacedKeyFromPropertyName;
@end

NS_ASSUME_NONNULL_END
