//
//  TBModelTool.m
//  Property
//
//  Created by tangbin on 2017/2/6.
//  Copyright © 2017年 tangbin. All rights reserved.
//

#import "TBModelTool.h"
typedef NS_ENUM(NSInteger, ModelToolType) {
     ModelToolTypeKVC, //KVC
    ModelToolTypeMJKit, //MJExtension
    ModelToolTypeYYModel //YYModel
};

@interface TBModelTool (){
    NSMutableDictionary *_replacedKey;
    ModelToolType _toolType;
    BOOL _addRemarkCode;
}
@end
@implementation TBModelTool
static TBModelTool *sInstance;
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sInstance == nil) {
            sInstance = [super allocWithZone:zone];
        }
    });
    return sInstance;
}
+ (void)initial {
    [self sharedInstance];
}
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
+ (TBModelTool *)sharedInstance {
    if (sInstance == nil) {
        sInstance = [[TBModelTool alloc] init];
        sInstance->_replacedKey = [NSMutableDictionary dictionary];
    }
    return sInstance;
}

//用于MJExtension 框架 解析生成 model
+ (void)MJ_createModelClassFileWithResource:(id)resource andModelClassFileName:(NSString *)fileName andReplacedKeyFromPropertyName:(NSDictionary *)replacedKeyFromPropertyName{
    [self sharedInstance];
    sInstance->_toolType = ModelToolTypeMJKit;
    [self createModelClassFileWithResource:resource andModelClassFileName:fileName andReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
    return;
}

//用于KVC解析生成 model
+ (void)KVC_createModelClassFileWithResource:(id)resource andModelClassFileName:(NSString *)fileName andReplacedKeyFromPropertyName:(NSDictionary *)replacedKeyFromPropertyName{
    [self sharedInstance];
    sInstance->_toolType = ModelToolTypeKVC;

    [self createModelClassFileWithResource:resource andModelClassFileName:fileName andReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
    return;
}

//用于 YYKit 框架解析生成 model
+ (void)YYModel_createModelClassFileWithResource:(id)resource andModelClassFileName:(NSString *)fileName andReplacedKeyFromPropertyName:(NSDictionary *)replacedKeyFromPropertyName {
    [self sharedInstance];
    sInstance->_toolType = ModelToolTypeYYModel;
    [self createModelClassFileWithResource:resource andModelClassFileName:fileName andReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
    return;
}


//生成属性代码 => 根据字典中所有key
+ (void)createModelClassFileWithResource:(id)resource andModelClassFileName:(NSString *)fileName andReplacedKeyFromPropertyName:(NSDictionary *)replacedKeyFromPropertyName{
    
    NSAssert(fileName != nil && resource != nil, @"源数据或者文件名不能为空！");
    [self setupReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
    if ([self fileIsExistWithFileName:fileName]) {
        return;
    }
    NSMutableString *codes = [NSMutableString string];
    NSMutableString *importString = [NSMutableString string];
    NSMutableString *AnalysisCodeString = [NSMutableString string];
    NSMutableArray *propertyToModelDicStringArr = [NSMutableArray array];
    
    if (sInstance->_toolType == ModelToolTypeMJKit) {
        
    } else if (sInstance->_toolType == ModelToolTypeKVC) {
        AnalysisCodeString = [NSMutableString stringWithString:@"- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}\n- (void)setValue:(id)value forKey:(NSString *)key {\n if ([key isEqualToString:@\"id\"]) {\n[super setValue:value forKey:@\"Id\"];\n}  \n  "];
    } else if (sInstance -> _toolType == ModelToolTypeYYModel) {
        AnalysisCodeString = [NSMutableString stringWithString:
                                 @"+ (NSDictionary *)modelContainerPropertyGenericClass {\
                                 \n return @{\n\
                                 "];
    }
    //遍历字典
    [resource enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *code;
        NSString *theKey = sInstance->_replacedKey[key];
        if (theKey) {
            key = theKey;
        }
        if (sInstance->_addRemarkCode) {
            NSString *remarkCode = @"/**\n <\#Description\#>\n*/";
            [codes appendString:remarkCode];
        }
        if ([obj isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;", key];
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;", key];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;", key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;", key];
             NSString *currentModelName = [NSString stringWithFormat:@"%@%@Model",[fileName stringByReplacingOccurrencesOfString:@"Model" withString:@""],[key capitalizedString]];
            for (id currentObj in obj) {
                if ([currentObj isKindOfClass:[NSDictionary class]]) {
                    [self createModelClassFileWithResource:currentObj andModelClassFileName:currentModelName andReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
                }
            }
            [importString appendString:[NSString stringWithFormat:@"#import \"%@.h\" \n",currentModelName]];
            if (sInstance->_toolType == ModelToolTypeMJKit) {
                [propertyToModelDicStringArr addObject:[NSString stringWithFormat:@"@\"%@\":@\"%@\"",key,currentModelName]];
            } else if (sInstance->_toolType == ModelToolTypeKVC) {
                NSString *arrayPropertyAnalysisCodeString = [NSString stringWithFormat:@"    else if ([key isEqualToString:@\"%@\"]) {\n NSMutableArray *objArr = [NSMutableArray array];\n for (NSInteger i = 0; i < [value count]; i++) { \n %@ *%@ = [[%@ alloc] init]; \n [%@ setValuesForKeysWithDictionary:value[i]]; \n [objArr addObject:%@]; \n } \n _%@ = objArr; \n }",key,currentModelName,key,currentModelName,key,key,key];
                [AnalysisCodeString appendString:arrayPropertyAnalysisCodeString];
            } else if (sInstance->_toolType == ModelToolTypeYYModel) {
                NSString *arrayPropertyAnalysisCodeString = [NSString stringWithFormat:@"@\"%@\":%@.class,",key,currentModelName];
                [AnalysisCodeString appendString:arrayPropertyAnalysisCodeString];
            }

        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            NSString *currentModelName = [NSString stringWithFormat:@"%@%@Model",[fileName stringByReplacingOccurrencesOfString:@"Model" withString:@""],[key capitalizedString]];
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",currentModelName, key];
            
            [self createModelClassFileWithResource:obj andModelClassFileName:currentModelName andReplacedKeyFromPropertyName:replacedKeyFromPropertyName];
            [importString appendString:[NSString stringWithFormat:@"#import \"%@.h\" \n",currentModelName]];

            if (sInstance->_toolType == ModelToolTypeMJKit) {
            } else if (sInstance->_toolType == ModelToolTypeKVC) {
                NSString *dictionaryPropertyAnalysisCodeString = [NSString stringWithFormat:@"else if ([key isEqualToString:@\"%@\"]) { \n %@ *%@ = [[%@ alloc] init]; \n [%@ setValuesForKeysWithDictionary:value]; \n_%@ = %@; \n}",key,currentModelName,key,currentModelName,key,key,key];
                [AnalysisCodeString appendString:dictionaryPropertyAnalysisCodeString];
            } else if (sInstance->_toolType == ModelToolTypeYYModel) {
                NSString *arrayPropertyAnalysisCodeString = [NSString stringWithFormat:@"@\"%@\":%@.class,",key,currentModelName];
                [AnalysisCodeString appendString:arrayPropertyAnalysisCodeString];
            }
        }
        [codes appendFormat:@"\n%@\n", code];
    }];
    if (sInstance->_toolType == ModelToolTypeMJKit) {
        if (propertyToModelDicStringArr.count > 0) {
            [AnalysisCodeString appendString:[NSString stringWithFormat:@"+ (NSDictionary *)mj_objectClassInArray { \nreturn @{%@};\n}",[propertyToModelDicStringArr componentsJoinedByString:@","]]];
        }
    } else if (sInstance->_toolType == ModelToolTypeKVC) {
        [AnalysisCodeString appendString: @"\n else \n{\n[super setValue:value forKey:key];\n}\n}\n"];
    } else if (sInstance->_toolType == ModelToolTypeYYModel) {
        [AnalysisCodeString appendString: @"\n };\n }\n"];
        if (sInstance->_replacedKey) {
            NSDictionary *dic = sInstance->_replacedKey;
            NSMutableString *appendString = [NSMutableString string];
            for (int i = 0; i < dic.allKeys.count; i++) {
                [appendString appendFormat:@"@\"%@\":@\"%@\",",dic.allValues[i],dic.allKeys[i]];
            }
            [AnalysisCodeString appendString:[NSString stringWithFormat:@"+ (NSDictionary *)modelCustomPropertyMapper {\
                                                 \nreturn @{%@\
                                                 \n};\n \
                                                 }",appendString]];
        }
    }

    [self create_hFileWithImportString:importString andFileName:fileName andPropertyCodes:codes];
    [self create_mFileWithMethodString:AnalysisCodeString andFileName:fileName];
}

#pragma mark - privite Method
+ (NSDictionary *)getReplacedKeyFromPropertyName {
    return sInstance->_replacedKey;
}

+ (void)setupReplacedKeyFromPropertyName:(NSDictionary *)replacedKeyFromPropertyName{
    NSMutableDictionary *replacedKey = sInstance->_replacedKey;
    [replacedKey addEntriesFromDictionary:replacedKeyFromPropertyName];
    sInstance->_replacedKey = replacedKey;
}
+ (void)create_hFileWithImportString:(NSString *)importString andFileName:(NSString *)fileName andPropertyCodes:(NSString *)propertyCodes {
    NSString *headerString = [NSString stringWithFormat:@"#import <Foundation/Foundation.h>\n%@@interface %@ : NSObject \n",importString,fileName];
    NSString *hCodes = [NSString stringWithFormat:@"%@%@ \n@end",headerString,propertyCodes];
    [hCodes writeToFile:[NSString stringWithFormat:@"%@%@.h",MODEL_FILE_PATH,fileName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (void)create_mFileWithMethodString:(NSString *)MethodString andFileName:(NSString *)fileName {
    NSString *mCodes = [NSString stringWithFormat:@"#import \"%@.h\"\n@implementation %@\n\n%@\n@end",fileName,fileName,MethodString];
    [mCodes writeToFile:[NSString stringWithFormat:@"%@%@.m",MODEL_FILE_PATH,fileName] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

+ (BOOL)fileIsExistWithFileName:(NSString *)fileName {
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *hFileName = [NSString stringWithFormat:@"%@%@.h",MODEL_FILE_PATH,fileName];
    if ([manager fileExistsAtPath:hFileName]) {
        NSLog(@"%@.h 文件已经存在,请删除文件后再试!",fileName);
        return YES;
    }
    NSString *mFileName = [NSString stringWithFormat:@"%@%@.m",MODEL_FILE_PATH,fileName];
    if ([manager fileExistsAtPath:mFileName]) {
        NSLog(@"%@.m 文件已经存在,请删除文件后再试!",fileName);
        return YES;
    }
    return NO;
}

+ (void)addRemarkCode {
    [self sharedInstance];
    sInstance->_addRemarkCode = 1;
}
+ (void)removeRemarkCode {
    [self sharedInstance];
    sInstance->_addRemarkCode = 0;
}

@end
