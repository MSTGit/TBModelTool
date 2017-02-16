#import "TBKVCModel.h"
@implementation TBKVCModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (void)setValue:(id)value forKey:(NSString *)key {
 if ([key isEqualToString:@"id"]) {
[super setValue:value forKey:@"Id"];
}  
      else if ([key isEqualToString:@"commonAttachmentList"]) {
 NSMutableArray *objArr = [NSMutableArray array];
 for (NSInteger i = 0; i < [value count]; i++) { 
 TBKVCCommonattachmentlistModel *commonAttachmentList = [[TBKVCCommonattachmentlistModel alloc] init]; 
 [commonAttachmentList setValuesForKeysWithDictionary:value[i]]; 
 [objArr addObject:commonAttachmentList]; 
 } 
 _commonAttachmentList = objArr; 
 }else if ([key isEqualToString:@"dictTest"]) { 
 TBKVCDicttestModel *dictTest = [[TBKVCDicttestModel alloc] init]; 
 [dictTest setValuesForKeysWithDictionary:value]; 
_dictTest = dictTest; 
}
 else 
{
[super setValue:value forKey:key];
}
}

@end