//
//  Int+Extension.swift
//  Tenant
//
//  Created by samsha on 2021/3/24.
//

import Foundation

public extension Int {
    ///  转换数字到中文
    func transformChina() ->String {
        let formatter = NumberFormatter()
        let local = Locale(identifier: "zh_Hans")
        formatter.locale = local
        formatter.numberStyle = .spellOut
        let result = formatter.string(from: NSNumber(integerLiteral: self))
        return result ?? "\(self)"
    }
    
    /// 转换成String
    func toString() -> String {
        return "\(self)"
    }
}
