//
//  BPLogGlobal.swift
//  BPLog
//
//  Created by samsha on 2021/6/9.
//

import Foundation
/// 记录普通操作日志
public func BPLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    BPOCLog.shared()?.eventLog(message)
}

/// 记录网络请求日志
public func BPRequestLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    BPOCLog.shared().request(message)
}
/// Socket请求日志
public func BPSocketLog(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    var message = ""
    items.forEach { (item) in
        if let itemStr = item as? String {
            message += " " + itemStr
        } else {
            message += " \(item)"
        }
    }
    BPOCLog.shared().socketLog(message)
}
