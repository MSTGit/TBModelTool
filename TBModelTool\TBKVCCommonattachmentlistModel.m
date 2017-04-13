#import "TBKVCCommonattachmentlistModel.h"
@implementation TBKVCCommonattachmentlistModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (void)setValue:(id)value forKey:(NSString *)key {
 if ([key isEqualToString:@"id"]) {
[super setValue:value forKey:@"Id"];
}  
      else if ([key isEqualToString:@"_Arr"]) {
 NSMutableArray *objArr = [NSMutableArray array];
 for (NSInteger i = 0; i < [value count]; i++) { 
 TBKVCCommonattachmentlist_ArrModel *_Arr = [[TBKVCCommonattachmentlist_ArrModel alloc] init]; 
 [_Arr setValuesForKeysWithDictionary:value[i]]; 
 [objArr addObject:_Arr]; 
 } 
 __Arr = objArr; 
 }
 else 
{
[super setValue:value forKey:key];
}
}

@end