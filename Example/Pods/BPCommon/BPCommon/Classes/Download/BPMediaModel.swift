//
//  BPImageModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/10/29.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper
import Kingfisher
import Photos
import BPFile

public struct BPMediaModel: Mappable, Equatable {
    
    /// 资源ID
    public var id: String = ""
    /// 资源名称
    public var name: String = ""
    /// 聊天室名称、ID（仅用于IM）
    public var session: String?
    /// 资源类型
    public var type: BPMediaType = .thumbImage
    /// 缩略图本地地址
    public var thumbnailLocalPath: String?
    /// 缩略图网络地址
    public var thumbnailRemotePath: String?
    /// 原图本地地址
    public var originLocalPath: String?
    /// 原图网络地址
    public var originRemotePath: String?
    /// 视频时长
    public var videoTime: TimeInterval = .zero
    /// 图片
    public var image: UIImage?
    
    public init() {}
    
    public init?(map: Map) {}
    
    mutating public func mapping(map: Map) {
        self.id                  <- map["id"]
        self.name                <- map["name"]
        self.session             <- map["session"]
        self.type                <- (map["type"], EnumTransform<BPMediaType>())
        self.thumbnailLocalPath  <- map["thumbnailLocalPath"]
        self.thumbnailRemotePath <- map["thumbnailRemotePath"]
        self.originLocalPath     <- map["originLocalPath"]
        self.originRemotePath    <- map["originRemotePath"]
        self.videoTime           <- map["videoTime"]
        self.image               <- (map["image"], BPImageTransform())
    }
    
    // MARK: ==== Tools ====
    private func queryImageCache(path: String, block: DefaultImageBlock) {
        
    }
    
    public static func == (lhs: BPMediaModel, rhs: BPMediaModel) -> Bool {
        return lhs.id == rhs.id
    }
}

public extension BPMediaModel {
    /// 显示缩略图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    func getThumbImage(progress: ((CGFloat) ->Void)?, completion: DefaultImageBlock?) {
        if let image = self.image {
            completion?(image)
            return
        }
        if let path = self.thumbnailLocalPath, let image = UIImage(named: path) {
            completion?(image)
        } else {
            guard let path = self.thumbnailRemotePath else {
                completion?(nil)
                return
            }
            BPDownloadManager.share.image(name: "ThumbImage", urlStr: path, type: .thumbImage, session: session, progress: progress, completion: completion)
        }
    }
    
    /// 显示原图，如果本地不存在则通过远端下载
    /// - Parameters:
    ///   - progress: 下载远端缩略图的进度
    ///   - completion: 下载、加载图片完成回调
    func getOriginImage(progress: ((CGFloat) ->Void)?, completion: DefaultImageBlock?) {
        if let image = self.image {
            completion?(image)
            return
        }
        if let path = self.originLocalPath, let image = UIImage(named: path) {
            completion?(image)
        } else {
            guard let path = self.originRemotePath else {
                completion?(nil)
                return
            }
            BPDownloadManager.share.image(name: "OriginImage", urlStr: path, type: .originImage, session: session, progress: progress, completion: completion)
        }
    }
    
    // 默认获取原图，如果没有则获取缩略图
    func getImage(progress: ((CGFloat) ->Void)?, completion: DefaultImageBlock?) {
        self.getOriginImage(progress: progress) { (image) in
            if let _image = image {
                completion?(_image)
            } else {
                // 获取缩略图
                self.getThumbImage(progress: progress, completion: completion)
            }
        }
    }
}
