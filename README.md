


# 欢迎使用 TBModelTool 模型生成工具

------

TBModelTool是一个简单的工具,可以帮助大家快速的根据 json 数据生成对应的 Model 文件,支持多层嵌套的 json 解析,极大的简化了通过json创建对应模型对象的步骤,现在你只需要通过以下步骤即可快速创建模型对象;
###使用方法:
首先要指定文件生成的位置:TBModelTool.h的MODEL_FILE_PATH宏定义中指定你的文件生成位置

 - 如果你是通过KVC的方式解析数据模型,你大概只需要在获得json数据的地方,通过这种方式:

   ` [TBModelTool KVC_createModelClassFileWithResource:jsonData andModelClassFileName:@"Your Model Name" andReplacedKeyFromPropertyName:nil];`

 - 如果你是通过MJExtension来解析你的数据模型,你可以在获得json数据的地方,通过这种方式生成你期望的模型:

   ` [TBModelTool MJ_createModelClassFileWithResource:jsonData andModelClassFileName:@"Your Model Name" andReplacedKeyFromPropertyName:nil];`

 - 如果你是通过YYModel来解析力的数据模型,你可以在获得json数据的地方,通过这种方式获得你期望的数据模型:

 `   [TBModelTool YYModel_createModelClassFileWithResource:jsonData andModelClassFileName:@"Your Model Name" andReplacedKeyFromPropertyName:nil];`

##**然后到指定的目录下 导入该文件到项目即可!至此,模型生成就完成了**

 - ⚠️在使用中有需要注意的地方:

1.andReplacedKeyFromPropertyName:
	该参数是自定义某些字段转换为另外一个字段进行解析的情况,如json数据中存在id字段,但是在object-C中,id是关键字,因此可以通过传入`@{@"id":@"Id"}`后,解析出来的模型就会自动将需要替换的字段替换为期望的字段,并在解析的字段中也替换了,因此你不需要任何操作;
	
2.TBModelTool 这个工具生成model文件时,需要再模拟器中运行,因为在真机中获取到的文件目录是真机中的目录,无法获取Mac中的目录;

如果你在使用中遇到任何不满足的需求或者使用不便的地方,欢迎 Issues 或者 Q 我 QQ:2446959228 (*^__^*)
#  如果你觉得这个工具对你有帮助,请帮我点一下右上角的小星星,谢谢对我的支持,我将持续为大家提供更好用的工具。

