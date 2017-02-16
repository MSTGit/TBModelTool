#import "TBKVCDicttestModel.h"
@implementation TBKVCDicttestModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
- (void)setValue:(id)value forKey:(NSString *)key {
 if ([key isEqualToString:@"id"]) {
[super setValue:value forKey:@"Id"];
}  
  
 else 
{
[super setValue:value forKey:key];
}
}

@end