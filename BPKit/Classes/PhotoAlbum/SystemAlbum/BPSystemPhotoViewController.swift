//
//  BPSystemPhotoViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/8.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos

class BPSystemPhotoViewController: BPViewController, BPSystemAlbumListViewDelegate, BPSystemPhotoViewDelegate {

    /// 当前相册对象
    private var albumModel: BPPhotoAlbumModel? {
        willSet {
            self.customNavigationBar?.title = (newValue?.assetCollection?.localizedTitle ?? "") + IconFont.upDownArrow.rawValue
            self.contentView.reload(album: newValue)
        }
    }
    /// 所有相册列表
    private var collectionList: [BPPhotoAlbumModel] = []
    /// 选择后的闭包回调
    var selectedBlock:(([BPMediaModel])->Void)?
    /// 最大选择数量
    var maxSelectCount: Int = 1
    
    /// 相册列表视图
    private var albumListView = BPSystemAlbumListView()
    /// 内容视图
    private let contentView   = BPSystemPhotoView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(contentView)
        self.view.addSubview(albumListView)
        contentView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
        albumListView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }

    override func bindProperty() {
        super.bindProperty()
        self.albumListView.delegate     = self
        self.contentView.delegate       = self
        self.albumListView.isHidden     = true
        self.contentView.maxSelectCount = maxSelectCount
        // 点击相册名可更换其他相册
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.switchAlbumList))
        self.customNavigationBar?.titleLabel.isUserInteractionEnabled = true
        self.customNavigationBar?.titleLabel.addGestureRecognizer(tapAction)
        // 确定选择
        self.customNavigationBar?.rightTitle = "确定"
        self.updateRightButtonStatus()
    }

    override func bindData() {
        super.bindData()
        // 获取相册列表
        self.setAssetCollection { [weak self] in
            guard let self = self, !self.collectionList.isEmpty else {
                return
            }
            // 设置默认显示的相册
            self.albumModel = self.collectionList.first
            self.albumListView.setData(albumList: self.collectionList, current: self.albumModel)
            self.albumListView.tableView.reloadData()
        }
    }
    
    override func rightAction() {
        super.rightAction()
        var mediaModelList = [BPMediaModel]()
        let assetModelList = self.contentView.selectedPhotoList()
        assetModelList.forEach { (asset) in
            if let model =  self.assetTransforMediaModel(asset: asset) {
                mediaModelList.append(model)
            }
        }
        self.selectedBlock?(mediaModelList)
        self.navigationController?.pop()
    }

    // MARK: ==== Event ====
    /// 设置相册列表
    private func setAssetCollection(complete block: DefaultBlock?) {
        BPAuthorizationManager.share.photo { [weak self] (result) in
            guard let self = self, result else { return }
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                // 收藏相册
                let favoritesCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
                // 相机照片
                let assetCollections     = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
                // 全部照片
                let cameraRolls          = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
                var id: Int = 0
                cameraRolls.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    var model = BPPhotoAlbumModel(collection: collection)
                    model.id = id
                    self?.collectionList.append(model)
                }
                favoritesCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    var model = BPPhotoAlbumModel(collection: collection)
                    model.id = id
                    self?.collectionList.append(model)
                }
                assetCollections.enumerateObjects { [weak self] (collection: PHAssetCollection, index: Int, pointer: UnsafeMutablePointer<ObjCBool>) in
                    id += 1
                    var model = BPPhotoAlbumModel(collection: collection)
                    model.id = id
                    self?.collectionList.append(model)
                }
                DispatchQueue.main.async {
                    block?()
                }
            }
        }
    }
    
    @objc private func switchAlbumList() {
        if self.albumListView.isHidden {
            self.albumListView.showView()
        } else {
            self.albumListView.hideView()
        }
    }
    
    /// 更新右上角确定按钮的状态
    private func updateRightButtonStatus() {
        let list = self.contentView.selectedPhotoList()
        if list.isEmpty {
            self.customNavigationBar?.rightButton.setStatus(.disable)
        } else {
            self.customNavigationBar?.rightButton.setStatus(.normal)
        }
    }

    // MARK: ==== Tools ====
    /// 转换得到资源对象
    private func assetTransforMediaModel(asset: PHAsset) -> BPMediaModel? {
        var model: BPMediaModel?
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.resizeMode = .fast
        options.isNetworkAccessAllowed = true
        options.progressHandler = { (progress, error, stop, userInfo:[AnyHashable : Any]?) in
            BPLog("Progress: \(progress)")
        }
        
        let requestId: PHImageRequestID = PHCachingImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .default, options: options) { (image: UIImage?, info:[AnyHashable : Any]?) in
            guard let result = info as? [String: Any], (result[PHImageCancelledKey] == nil), (result[PHImageErrorKey] == nil) else {
                return
            }
            var mediaModel = BPMediaModel()
            mediaModel.image = image
            model = mediaModel
        }
        model?.id = "\(requestId)"
        return model
    }
    
    // MARK: ==== BPSystemPhotoViewDelegate ====
    func clickImage(indexPath: IndexPath, from imageView: UIImageView?) {
        guard let model = self.albumModel else { return }
        BPImageBrowser(type: .system(result: model.assets), current: indexPath.row).show(animationView: imageView)
    }

    // MARK: ==== BPSystemAlbumListViewDelegate ====
    func selectedAlbum(model: BPPhotoAlbumModel?) {
        self.albumModel = model
    }
    func selectedImage() {
        self.updateRightButtonStatus()
    }
    func unselectImage() {
        self.updateRightButtonStatus()
    }
}
