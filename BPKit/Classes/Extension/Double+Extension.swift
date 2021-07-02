//
//  Double+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/6.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

public extension Double {

    /// 获取小时、分钟和秒钟的字符串
    func hourMinuteSecondStr(space mark: String = ":") -> String {
        let h = self.hour()
        let m = self.minute() % 60
        let s = self.second() % 60
        return String(format: "%02d%@%02d%@%02d", h, mark, m, mark, s)
    }

    /// 获取分钟和秒钟的字符串
    func minuteSecondStr(space mark: String = ":") -> String {
        let m = self.minute()
        let s = self.second() % 60
        return String(format: "%02d%@%02d", m, mark, s)
    }

    /// 转换成秒
    func second() -> Int {
        /// 四舍五入
        return Int(self.rounded())
    }

    /// 转换成分钟
    func minute() -> Int {
        return second() / 60
    }

    /// 转换成小时
    func hour() -> Int {
        return minute() / 60
    }
}

public extension BinaryFloatingPoint where Self: CustomStringConvertible{
    /// 数字类型文本
    ///
    /// 可自定义有效小数位
    /// example:
    ///    var num: Float = 8.0
    ///    num.ec_description()     //"8"
    ///
    ///    num = 8.100
    ///    num.ec_description()     //"8.1"
    ///
    ///    num = 8.888
    ///    num.ec_description()     //"8.888"
    ///    num.ec_description(significand: 2)   //"8.89"
    ///
    /// - parameter significand: 小数的有效位数

    func ec_description(significand:Int? = nil) -> String{
        let number = Int(self)
        if Self(number) == self { return number.description }
        guard let significand = significand else { return self.description }
        return String(format: "%.\(significand)f", self as! CVarArg)
    }
    
}
