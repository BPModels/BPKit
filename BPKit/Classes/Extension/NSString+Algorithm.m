//
//  NSString+Algorithm.m
//  Tenant
//
//  Created by samsha on 2021/3/29.
//

#import "NSString+Algorithm.h"

@implementation NSString (Algorithm)

- (NSString *)converChina

{
    if (!self || ([self doubleValue] == [@"0.00" doubleValue]))
    {
        return @"零元整";
    }

    //首先转化成标准格式        “200.23”
    NSString *doubleStr = nil;
    doubleStr = [NSString stringWithFormat:@"%.2f",[self doubleValue]];
    NSMutableString *tempStr= nil;
    tempStr = [[NSMutableString alloc] initWithString:doubleStr];
    //位
    NSArray *carryArr1=@[@"元", @"拾", @"佰", @"仟", @"万", @"拾", @"佰", @"仟", @"亿", @"拾", @"佰", @"仟", @"兆", @"拾", @"佰", @"仟" ,@"京",@"十京",@"百京",@"千京垓",@"十垓",@"百垓",@"千垓秭",@"十秭",@"百秭",@"千秭穰",@"十穰",@"百穰",@"千穰"];
    NSArray *carryArr2=@[@"分",@"角"];
    //数字
    NSArray *numArr=@[@"零", @"壹", @"贰", @"叁", @"肆", @"伍", @"陆", @"柒", @"捌", @"玖"];

    NSArray *temarr = [tempStr componentsSeparatedByString:@"."];
    //小数点前的数值字符串
    NSString *firstStr=[NSString stringWithFormat:@"%@",temarr[0]];
    //小数点后的数值字符串
    NSString *secondStr=[NSString stringWithFormat:@"%@",temarr[1]];

    //是否拼接了“零”，做标记
    bool zero=NO;
    //拼接数据的可变字符串
    NSMutableString *endStr= [[NSMutableString alloc] init];

    /**
     *  首先遍历firstStr，从最高位往个位遍历    高位----->个位
     */

    for(int i=(int)firstStr.length;i>0;i--)
    {
        //取最高位数
        NSInteger MyData=[[firstStr substringWithRange:NSMakeRange(firstStr.length-i, 1)]
                          integerValue];

        if ([numArr[MyData] isEqualToString:@"零"])
        {

            if ([carryArr1[i-1] isEqualToString:@"万"]||[carryArr1[i-1] isEqualToString:@"亿"]||[carryArr1[i-1] isEqualToString:@"元"]||[carryArr1[i-1] isEqualToString:@"兆"])
            {
                //去除有“零万”
                if (zero)
                {
                    endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:(endStr.length-1)]];
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }
                else
                {
                    [endStr appendString:carryArr1[i-1]];
                    zero=NO;
                }

                //去除有“亿万”、"兆万"的情况
                if ([carryArr1[i-1] isEqualToString:@"万"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"亿"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }

                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }

                }
                //去除“兆亿”
                if ([carryArr1[i-1] isEqualToString:@"亿"]) {
                    if ([[endStr substringWithRange:NSMakeRange(endStr.length-2, 1)] isEqualToString:@"兆"]) {
                        endStr =[NSMutableString stringWithFormat:@"%@",[endStr substringToIndex:endStr.length-1]];
                    }
                }


            }else{
                if (!zero) {
                    [endStr appendString:numArr[MyData]];
                    zero=YES;
                }

            }

        }else{
            //拼接数字
            [endStr appendString:numArr[MyData]];
            //拼接位
            [endStr appendString:carryArr1[i-1]];
            //不为“零”
            zero=NO;
        }
    }

    /**
     *  再遍历secondStr    角位----->分位
     */

    if ([secondStr isEqualToString:@"00"]) {
        [endStr appendString:@"整"];
    }else{
       //如果最后一位位0就把它去掉
        if (secondStr.length > 1 && [secondStr hasSuffix:@"0"])
        {
            secondStr = [secondStr substringToIndex:secondStr.length - 1];
        }

        for(int i=(int)secondStr.length;i>0;i--)
        {
            //取最高位数
            NSInteger MyData=[[secondStr substringWithRange:NSMakeRange(secondStr.length-i, 1)] integerValue];

            [endStr appendString:numArr[MyData]];
            [endStr appendString:carryArr2[i-1]];
        }
    }

    //add song
    if ([endStr hasPrefix:@"元"])
    {
        return  (NSString *)[endStr substringFromIndex:1];
    }

    return endStr;
}
@end
