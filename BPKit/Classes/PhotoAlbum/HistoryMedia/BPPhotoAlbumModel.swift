//
//  BPPhotoAlbumModel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/10.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import ObjectMapper
import Photos

public struct BPPhotoAlbumModel: Mappable, Equatable {
    public var id: Int = 0
    public var assets  = PHFetchResult<PHAsset>()
    public var assetCollection: PHAssetCollection?
    public init(collection: PHAssetCollection) {
        self.assetCollection = collection
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.assets = PHAsset.fetchAssets(in: collection, options: options)
    }

    public init?(map: Map) {}
    public mutating func mapping(map: Map) {}
}
