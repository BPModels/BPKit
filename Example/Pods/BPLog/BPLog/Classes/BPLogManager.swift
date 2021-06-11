//
//  BPLogManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/1/16.
//  Copyright © 2020 沙庭宇. All rights reserved.
//


import Foundation
import CocoaLumberjack
import ZipArchive

public protocol BPLogDelegate: NSObjectProtocol {
    /// 打包时，添加到普通操作日志末尾的内容
    func addNormalLogAfter()
    /// 打包时，添加到网络请求日志末尾的内容
    func addRequestLogAfter()
}

/// 日志管理
public class BPLogManager {
    public static let share = BPLogManager()
    
    public var delegate: BPLogDelegate?
    
    /// 普通操作日志路径
    public var requestLogPath: String {
        let path = BPOCLog.shared()?.loggerFoRequest.logFileManager.logsDirectory
        return path ?? ""
    }
    /// 网络请求日志路径
    public var normalLogPath: String {
        let path = BPOCLog.shared()?.loggerForEvent.logFileManager.logsDirectory
        return path ?? ""
    }
    /// 获取全部日志
    public func getAllLogZip() -> Data? {
        self.delegate?.addNormalLogAfter()
        self.delegate?.addRequestLogAfter()
        let fileData = self.zipLogFile()
        return fileData
    }
    
    /// 删除全部日志
    public func deleteAllLog() {
        let requestLogger = BPOCLog.shared()?.loggerFoRequest
        let eventLogger   = BPOCLog.shared()?.loggerForEvent

        let requestLogFileList = requestLogger?.logFileManager.sortedLogFilePaths ?? []
        let eventLogFileList   = eventLogger?.logFileManager.sortedLogFilePaths ?? []

        requestLogFileList.forEach { (path) in
            if ((try? FileManager.default.removeItem(atPath: path)) != nil) {
                BPLog("删除Request日志成功")
            } else {
                BPLog("删除Request日志失败")
            }
        }
        eventLogFileList.forEach { (path) in
            if ((try? FileManager.default.removeItem(atPath: path)) != nil) {
                BPLog("删除Even日志成功")
            } else {
                BPLog("删除Event日志失败")
            }
        }
    }
    
    /// 删除全部日志压缩包
    public func deleteAllZip() {
        let fileLogger    = DDFileLogger()
        let requestLogger = BPOCLog.shared()?.loggerFoRequest
        let eventLogger   = BPOCLog.shared()?.loggerForEvent

        let logDirectory     = fileLogger.logFileManager.logsDirectory
        let requestDirectory = requestLogger?.logFileManager.logsDirectory ?? ""
        let eventDirectory   = eventLogger?.logFileManager.logsDirectory ?? ""

        let requestZipPath   = requestDirectory + "/Request.zip"
        let eventZipPath     = eventDirectory + "/Event.zip"
        let logZipPath       = logDirectory + "/Log.zip"


        if ((try? FileManager.default.removeItem(atPath: requestZipPath)) != nil) {
            BPLog("删除Request Zip包成功")
        } else {
            BPLog("删除Reqeust Zip包失败")
        }

        if ((try? FileManager.default.removeItem(atPath: eventZipPath)) != nil) {
            BPLog("删除Event Zip包成功")
        } else {
            BPLog("删除Evnet Zip包失败")
        }

        if ((try? FileManager.default.removeItem(atPath: logZipPath)) != nil) {
            BPLog("删除Log Zip包成功")
        } else {
            BPLog("删除Log Zip包失败")
        }
    }
    
    // MARK: ==== Tool ====

    ///  压缩日志文件
    private func zipLogFile() -> Data? {
        let fileLogger    = DDFileLogger()
        let requestLogger = BPOCLog.shared()?.loggerFoRequest
        let eventLogger   = BPOCLog.shared()?.loggerForEvent

        let logZiper         = ZipArchive()
        let requestZiper     = ZipArchive()
        let eventZiper       = ZipArchive()

        let logDirectoryPath = fileLogger.logFileManager.logsDirectory
        let logZipPath       = logDirectoryPath + "/Log.zip"

        let requestLogList   = requestLogger?.logFileManager.sortedLogFileNames
        let requestDirectory = requestLogger?.logFileManager.logsDirectory ?? ""
        let requestZipPath   = requestDirectory + "/Request.zip"
        let eventLogList     = eventLogger?.logFileManager.sortedLogFileNames
        let eventDirectory   = eventLogger?.logFileManager.logsDirectory ?? ""
        let eventZipPath     = eventDirectory + "/Event.zip"

        BPLog("++++++++++++++++")
        BPLog(logDirectoryPath)
        if requestZiper.createZipFile2(requestZipPath) {
            requestLogList?.forEach({ (name) in
                requestZiper.addFile(toZip: requestDirectory + "/" + name, newname: name)
            })
            BPLog("创建Request Zip成功")
        } else {
            BPLog("创建Request Zip失败")
        }
        requestZiper.closeZipFile2()

        if eventZiper.createZipFile2(eventZipPath) {
            eventLogList?.forEach({ (name) in
                eventZiper.addFile(toZip: eventDirectory + "/" + name, newname: name)
            })
            BPLog("创建Event Zip成功")
        } else {
            BPLog("创建Evnet Zip失败")
        }
        eventZiper.closeZipFile2()

        guard let requestZipData = try? Data(contentsOf: URL(fileURLWithPath: requestZipPath)), let eventZipData = try? Data(contentsOf: URL(fileURLWithPath: eventZipPath)) else {
            return nil
        }
        if logZiper.createZipFile2(logZipPath) {
            logZiper.addData(toZip: requestZipData, fileAttributes: [:], newname: "Request.zip")
            logZiper.addData(toZip: eventZipData, fileAttributes: [:], newname: "Event.zip")
            BPLog("创建Log Zip成功")
        } else {
            BPLog("创建Log Zip失败")
        }
        logZiper.closeZipFile2()
        guard let logZipData = try? Data(contentsOf: URL(fileURLWithPath: logZipPath))else {
            return nil
        }
        return logZipData
    }
}
