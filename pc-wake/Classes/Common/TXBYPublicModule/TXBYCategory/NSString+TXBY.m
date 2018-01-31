//
//  NSString+TXBY.m
//  TXBYCategory
//
//  Created by mac on 16/1/20.
//  Copyright © 2016年 tianxiabuyi. All rights reserved.
//

#import "NSString+TXBY.h"
#import "NSData+TXBY.h"
#import "NSDate+TXBY.h"
#import "NSArray+TXBY.h"
#import <UIKit/UIKit.h>
#import "TXBYKitConst.h"

@implementation NSString (TXBY)

- (NSString *)md5String {
    return [[self dataValue] md5String];
}

- (NSString *)base64EncodedString {
    return [[self dataValue] base64EncodedString];
}

+ (NSString *)stringWithBase64EncodedString:(NSString *)base64EncodedString {
    NSData *data = [NSData dataWithBase64EncodedString:base64EncodedString];
    return [data utf8String];
}

+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *returnStr = [NSPropertyListSerialization propertyListFromData:tempData mutabilityOption:NSPropertyListImmutable format:NULL errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSString *)stringByURLEncode {
    if ([self respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        static NSString * const kAFCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
        static NSString * const kAFCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
        
        NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
        [allowedCharacterSet removeCharactersInString:[kAFCharactersGeneralDelimitersToEncode stringByAppendingString:kAFCharactersSubDelimitersToEncode]];
        static NSUInteger const batchSize = 50;
        
        NSUInteger index = 0;
        NSMutableString *escaped = @"".mutableCopy;
        
        while (index < self.length) {
            NSUInteger length = MIN(self.length - index, batchSize);
            NSRange range = NSMakeRange(index, length);
            // To avoid breaking up character sequences such as 👴🏻👮🏽
            range = [self rangeOfComposedCharacterSequencesForRange:range];
            NSString *substring = [self substringWithRange:range];
            NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
            [escaped appendString:encoded];
            
            index += range.length;
        }
        return escaped;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *encoded = (__bridge_transfer NSString *)
        CFURLCreateStringByAddingPercentEscapes(
                                                kCFAllocatorDefault,
                                                (__bridge CFStringRef)self,
                                                NULL,
                                                CFSTR("!#$&'()*+,/:;=?@[]"),
                                                cfEncoding);
        return encoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByURLDecode {
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CFStringEncoding en = CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding);
        NSString *decoded = [self stringByReplacingOccurrencesOfString:@"+"
                                                            withString:@" "];
        decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(
                                                                NULL,
                                                                (__bridge CFStringRef)decoded,
                                                                CFSTR(""),
                                                                en);
        return decoded;
#pragma clang diagnostic pop
    }
}

- (NSString *)stringByEscapingHTML {
    NSUInteger len = self.length;
    if (!len) return self;
    
    unichar *buf = malloc(sizeof(unichar) * len);
    if (!buf) return nil;
    [self getCharacters:buf range:NSMakeRange(0, len)];
    
    NSMutableString *result = [NSMutableString string];
    for (int i = 0; i < len; i++) {
        unichar c = buf[i];
        NSString *esc = nil;
        switch (c) {
            case 34: esc = @"&quot;"; break;
            case 38: esc = @"&amp;"; break;
            case 39: esc = @"&apos;"; break;
            case 60: esc = @"&lt;"; break;
            case 62: esc = @"&gt;"; break;
            default: break;
        }
        if (esc) {
            [result appendString:esc];
        } else {
            CFStringAppendCharacters((CFMutableStringRef)result, &c, 1);
        }
    }
    free(buf);
    return result;
}

- (NSString *)encrypt {
    return [self encryptWithKey:nil];
}

- (NSString *)encryptWithKey:(NSString *)key {
    return [[[self dataValue] encryptWithKey:key] base64EncodedString];
}

- (NSString *)decrypt {
    return [self decryptWithKey:nil];
}

- (NSString *)decryptWithKey:(NSString *)key {
    return [[[self dataValue] decryptWithKey:key] utf8String];
}

- (NSData *)dataValue {
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)trim {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    return [self stringByTrimmingCharactersInSet:set];
}

- (BOOL)containsString:(NSString *)string {
    if (!string) return NO;
    return [self rangeOfString:string].location != NSNotFound;
}
/**
 *  根据文字字体和最大尺寸计算文字宽高
 */
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    // 获得系统版本
    if (iOS7) {
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        return [self boundingRectWithSize:maxSize options:options attributes:attrs context:nil].size;
    } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font constrainedToSize:maxSize];
#pragma clang diagnostic pop
        
    }
}

- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)size {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self sizeWithFont:font constrainedToSize:size];
#pragma clang diagnostic pop
}

- (CGSize)sizeWithFont:(UIFont *)font {
    return [self sizeWithFont:font maxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
}

/**
 *  多少分钟前
 */
- (NSString *)minutesAgo {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdDate = [fmt dateFromString:self];
    
    // 判断发送时间 和 现在时间 的差距
    if (createdDate.isToday) { // 今天
        if (createdDate.deltaWithNow.hour >= 1) {
            fmt.dateFormat = @"HH:mm";
            return [fmt stringFromDate:createdDate];
        } else if (createdDate.deltaWithNow.minute >= 1) {
            return [NSString stringWithFormat:@"%ld分钟前", (long)createdDate.deltaWithNow.minute];
        } else {
            return @"刚刚";
        }
    } else if (createdDate.isYesterday) { // 昨天
        fmt.dateFormat = @"昨天 HH:mm";
        return [fmt stringFromDate:createdDate];
    } else if (createdDate.isThisYear) { // 今年(至少是前天)
        fmt.dateFormat = @"MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    } else {// 非今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createdDate];
    }
}

/**
 *  用户名验证
 */
- (NSString *)validateUserName
{
    NSString *userName = @"[a-zA-Z]";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userName];
    if (![regextestmobile evaluateWithObject:[self substringToIndex:1]])
    {
        return @"用户名必须以字母开头";
    }
    
    if ([self hasChinese])
    {
        return @"用户名不能包含中文";
    }
    
    if ([self hasSpase])
    {
        return @"用户名不能包含空格";
    }
    
    userName = @"^[a-zA-Z0-9_]+$";
    regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", userName];
    if (![regextestmobile evaluateWithObject:self])
    {
        return @"用户名不能包含特殊字符";
    }
    
    if (self.length < 4)
    {
        return @"用户名不应少于4个字符";
    }
    
    if (self.length > 20)
    {
        return @"用户名不应多于20个字符";
    }
    
    return nil;
}

/**
 *  判断字符串中是否有中文
 */
- (BOOL)hasChinese
{
    for(int i = 0; i < [self length]; i++)
    {
        int a = [self characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

/**
 *  判断字符串是否为中文
 */
- (BOOL)isChineseString
{
    for(int i = 0; i < [self length]; i++)
    {
        int a = [self characterAtIndex:i];
        if( a < 0x4e00 || a > 0x9fff)
        {
            return NO;
        }
    }
    return YES;
}


- (BOOL)validateMobile {
    NSString * MOBILE = @"^1[34587][0-9]{9}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

/**
 *  判断字符串中是否有空格
 */
- (BOOL)hasSpase
{
    for(int i = 0; i < [self length]; i++)
    {
        int a = [self characterAtIndex:i];
        if( a == 32)
        {
            return YES;
        }
    }
    return NO;
}

/**
 *  判断字符串是否由字母组成
 */
- (BOOL)validateEnglish {
    NSString * english = @"^[a-zA-Z]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", english];
    return [regextestmobile evaluateWithObject:self];
}

- (BOOL)validatePassport {
    NSString *passport = @"^1[45][0-9]{7}|G[0-9]{8}|P[0-9]{7}|S[0-9]{7,8}|D[0-9]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passport];
    return [predicate evaluateWithObject:self];
}

/**
 *  判断字符串是否由字母和数字混合组成
 */
- (BOOL)validateNumberMixEnglish {
    NSString *number = @"^[A-Za-z0-9]+$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    return [regextestmobile evaluateWithObject:self];
}

/**
 *  是否纯数字
 */
- (BOOL)validateNumber {
    NSString *number = @"^[0-9]*$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", number];
    if ([regextestmobile evaluateWithObject:self] == YES) {
        return YES;
    }
    return NO;
}

- (BOOL)areaCode:(NSString *)code {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:@"北京" forKey:@"11"];
    [dic setObject:@"天津" forKey:@"12"];
    [dic setObject:@"河北" forKey:@"13"];
    [dic setObject:@"山西" forKey:@"14"];
    [dic setObject:@"内蒙古" forKey:@"15"];
    [dic setObject:@"辽宁" forKey:@"21"];
    [dic setObject:@"吉林" forKey:@"22"];
    [dic setObject:@"黑龙江" forKey:@"23"];
    [dic setObject:@"上海" forKey:@"31"];
    [dic setObject:@"江苏" forKey:@"32"];
    [dic setObject:@"浙江" forKey:@"33"];
    [dic setObject:@"安徽" forKey:@"34"];
    [dic setObject:@"福建" forKey:@"35"];
    [dic setObject:@"江西" forKey:@"36"];
    [dic setObject:@"山东" forKey:@"37"];
    [dic setObject:@"河南" forKey:@"41"];
    [dic setObject:@"湖北" forKey:@"42"];
    [dic setObject:@"湖南" forKey:@"43"];
    [dic setObject:@"广东" forKey:@"44"];
    [dic setObject:@"广西" forKey:@"45"];
    [dic setObject:@"海南" forKey:@"46"];
    [dic setObject:@"重庆" forKey:@"50"];
    [dic setObject:@"四川" forKey:@"51"];
    [dic setObject:@"贵州" forKey:@"52"];
    [dic setObject:@"云南" forKey:@"53"];
    [dic setObject:@"西藏" forKey:@"54"];
    [dic setObject:@"陕西" forKey:@"61"];
    [dic setObject:@"甘肃" forKey:@"62"];
    [dic setObject:@"青海" forKey:@"63"];
    [dic setObject:@"宁夏" forKey:@"64"];
    [dic setObject:@"新疆" forKey:@"65"];
    [dic setObject:@"台湾" forKey:@"71"];
    [dic setObject:@"香港" forKey:@"81"];
    [dic setObject:@"澳门" forKey:@"82"];
    [dic setObject:@"国外" forKey:@"91"];
    
    if ([dic objectForKey:code] == nil) {
        return NO;
    }
    
    return YES;
}

-(BOOL) validateIdentityCard {
    //判断位数
    if ([self length] != 15 && [self length] != 18) {
        return NO;
    }
    NSString *carid = self;
    
    long lSumQT =0;
    
    //加权因子
    int R[] ={7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2 };
    
    //校验码
    unsigned char sChecker[11]={'1','0','X', '9', '8', '7', '6', '5', '4', '3', '2'};
    
    
    //将15位身份证号转换成18位
    NSMutableString *mString = [NSMutableString stringWithString:self];
    
    if ([self length] == 15) {
        [mString insertString:@"19" atIndex:6];
        long p = 0;
        
        const char *pid = [mString UTF8String];
        
        for (int i=0; i<=16; i++) {
            p += (pid[i]-48) * R[i];
        }
        
        int o = p%11;
        NSString *string_content = [NSString stringWithFormat:@"%c",sChecker[o]];
        [mString insertString:string_content atIndex:[mString length]];
        carid = mString;
    }
    
    //判断地区码
    NSString * sProvince = [carid substringToIndex:2];
    
    if (![self areaCode:sProvince]) {
        return NO;
    }
    
    //判断年月日是否有效
    //年份
    int strYear = [[carid substringWithRange:NSMakeRange(6,4)] intValue];
    //月份
    int strMonth = [[carid substringWithRange:NSMakeRange(10,2)] intValue];
    //日
    int strDay = [[carid substringWithRange:NSMakeRange(12,2)] intValue];
    
    NSTimeZone *localZone = [NSTimeZone localTimeZone];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeZone:localZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date=[dateFormatter dateFromString:[NSString stringWithFormat:@"%d-%d-%d 12:01:01",strYear,strMonth,strDay]];
    if (date == nil) {
        return NO;
    }
    const char *PaperId  = [carid UTF8String];
    
    //检验长度
    if( 18 != strlen(PaperId)) return -1;
    
    //校验数字
    for (int i=0; i<18; i++) {
        if ( !isdigit(PaperId[i]) && !(('X' == PaperId[i] || 'x' == PaperId[i]) && 17 == i) ) {
            return NO;
        }
    }
    
    //验证最末的校验码
    for (int i=0; i<=16; i++) {
        lSumQT += (PaperId[i]-48) * R[i];
    }
    
    if (sChecker[lSumQT%11] != PaperId[17] ) {
        return NO;
    }
    return YES;
}

/**
 *  根据身份证号判断男女，男为@“0” 女为@“1”
 */
- (NSString *)sexAccordingToIdCard {
    // 校验身份证
    if (![self validateIdentityCard]) {
        return nil;
    };
    // 性别码
    NSString *sexStr;
    if (self.length == 15) {
        sexStr = [self substringWithRange:NSMakeRange(14, 1)];
    } else {
        sexStr = [self substringWithRange:NSMakeRange(16, 1)];
    }
    NSInteger sex = [sexStr integerValue];
    return (sex % 2) ?  @"0" : @"1";
}

/**
 *  根据身份证号返回出生年月日
 */
- (NSString *)birthdayAccordingToIdCard {
    // 校验身份证
    if (![self validateIdentityCard]) {
        return nil;
    }
    // 出生日期码
    NSString *birthdayStr;
    // 出生年
    NSString *year;
    // 出生月
    NSString *month;
    // 出生日
    NSString *day;
    if (self.length == 15) {
        birthdayStr = [self substringWithRange:NSMakeRange(6, 6)];
        year = [birthdayStr substringWithRange:NSMakeRange(0, 2)];
        month = [birthdayStr substringWithRange:NSMakeRange(2, 2)];
        day = [birthdayStr substringWithRange:NSMakeRange(4, 2)];
    } else {
        birthdayStr = [self substringWithRange:NSMakeRange(6, 8)];
        year = [birthdayStr substringWithRange:NSMakeRange(0, 4)];
        month = [birthdayStr substringWithRange:NSMakeRange(4, 2)];
        day = [birthdayStr substringWithRange:NSMakeRange(6, 2)];
    }
    // 如果出生年是2位，则在前面加上19
    if (year.length == 2) {
        year = [NSString stringWithFormat:@"19%@",year];
    }
    return [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
}

#pragma mark - 城市名称区号
- (NSString *)cityName {
    NSArray *cityArray = [NSArray arrayWithName:@"city" bundleName:@"TXBYCategory"];
    
    for (NSDictionary *dict in cityArray) {
        NSArray *cities = dict[@"cities"];
        for (NSDictionary *d in cities) {
            NSString *city = d[@"city"];
            NSString *code = d[@"code"];
            
            if ([code isEqualToString:self]) {
                if ([city isEqualToString:dict[@"province"]]) {
                    return dict[@"province"];
                }
                return [NSString stringWithFormat:@"%@ %@",dict[@"province"],city];
            }
        }
    }
    
    return @"未知";
}

- (NSString *)cityCode {
    // 省份
    NSString *province;
    // 城市
    NSString *city;
    // 区号
    NSString *code;
    NSRange rang = [self rangeOfString:@" "];
    if (rang.location != NSNotFound) {
        province = [self substringToIndex:rang.location];
        city = [self substringFromIndex:rang.location + 1];
    } else {
        province = self;
        city = self;
    }
    
    // 城市与区号数据源
    NSArray *cityArray = [NSArray arrayWithName:@"city" bundleName:@"TXBYCategory"];
    // 遍历出对应的code
    for (NSDictionary *provinceDict in cityArray) {
        if ([provinceDict[@"province"] isEqualToString:province]) {
            NSArray *cities = provinceDict[@"cities"];
            for (NSDictionary *cityDict in cities) {
                if ([cityDict[@"city"] isEqualToString:city]) {
                    code = cityDict[@"code"];
                    break;
                }
            }
        }
    }
    return code;
}

#pragma mark - path
/**
 *  plist文件在mainBundle中的路径
 */
+ (NSString *)pathForResource:(NSString *)resource
{
    if ([resource hasSuffix:@".plist"])
    {
        return [[NSBundle mainBundle] pathForResource:resource ofType:nil];
    }
    return [[NSBundle mainBundle] pathForResource:resource ofType:@"plist"];
}

+ (NSString *)bundlePathWithName:(NSString *)name {
    if (!name) {
        return [[NSBundle mainBundle] resourcePath];
    }
    
    if (![name hasSuffix:@".bundle"]) {
        name = [name stringByAppendingString:@".bundle"];
    }
    return [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:name];
}

+ (NSString *)mainBundlePath {
    return [self bundlePathWithName:nil];
}

+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    return responseJSON;
}

/**
 *  年龄验证
 */
- (BOOL)validateAge {
    NSString * MOBILE = @"^(?:[1-9][0-9]?|1[01][0-9]|120)$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:self];
}

/**
 *  四舍五入
 */
+ (NSString *)notRounding:(float)number afterPoint:(NSInteger)position {
    NSDecimalNumberHandler *roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundPlain scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    return [NSString stringWithFormat:@"%@",roundedOunces];
}

- (BOOL)isValidatIP {
    
    NSString  *urlRegEx =@"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\." 
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:self];
    
}

@end
