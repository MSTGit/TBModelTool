#import "TBYYModel.h"
@implementation TBYYModel

+ (NSDictionary *)modelContainerPropertyGenericClass {                              
 return @{
                              @"commonAttachmentList":TBYYCommonattachmentlistModel.class,@"dictTest":TBYYDicttestModel.class,
 };
 }
+ (NSDictionary *)modelCustomPropertyMapper {                                              
return @{@"Id":@"id",@"amountamountamountamount":@"amount",                                              
};
                                               }
@end