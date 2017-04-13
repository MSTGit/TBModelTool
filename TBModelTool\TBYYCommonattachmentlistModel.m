#import "TBYYCommonattachmentlistModel.h"
@implementation TBYYCommonattachmentlistModel

+ (NSDictionary *)modelContainerPropertyGenericClass {                              
 return @{
                              @"_Arr":TBYYCommonattachmentlist_ArrModel.class,
 };
 }
+ (NSDictionary *)modelCustomPropertyMapper {                                              
return @{@"Id":@"id",@"amountamountamountamount":@"amount",                                              
};
                                               }
@end