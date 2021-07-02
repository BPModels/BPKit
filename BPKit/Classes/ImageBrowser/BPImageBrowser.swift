//
//  BPImageBrowser.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/1.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos
public enum BPImageBrowserType {
    /// 自定义
    case custom(modelList: [BPMediaModel])
    /// 系统相册
    case system(result: PHFetchResult<PHAsset>)
}

public protocol BPImageBrowserDelegate:NSObjectProtocol {
    func reuploadImage(model:[BPMediaModel])
}

public class BPImageBrowser: BPView, UICollectionViewDelegate, UICollectionViewDataSource, BPImageBrowserCellDelegate {

    public weak var delegate:BPImageBrowserDelegate?
    
    private let kBPImageBrowserCellID = "kBPImageBrowserCell"
    private var medioModelList: [BPMediaModel] = []
    private var assetModelList: PHFetchResult<PHAsset>?
    private var type: BPImageBrowserType
    private var currentIndex: Int
    private var startFrame: CGRect?

    var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize           = kWindow.size
        layout.scrollDirection    = .horizontal
        layout.minimumLineSpacing = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator   = false
        collectionView.isPagingEnabled  = true
        collectionView.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleWidth, .flexibleHeight)
        collectionView.backgroundColor  = .clear
        return collectionView
    }()
  

    private var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black
        return view
    }()

    private var albumButton: BPButton = {
        let button = BPButton()
        button.setTitle("全部", for: .normal)
        button.setTitleColor(UIColor.white0, for: .normal)
        button.titleLabel?.font   = UIFont.regularFont(ofSize: AdaptSize(14))
        button.backgroundColor    = UIColor.black0.withAlphaComponent(0.9)
        button.layer.cornerRadius = AdaptSize(5)
        button.isHidden           = true
        return button
    }()

    public init(type: BPImageBrowserType, current index: Int) {
        self.type = type
        self.currentIndex   = index
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(backgroundView)
        self.addSubview(collectionView)
        
        self.addSubview(albumButton)
        backgroundView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
       
        albumButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(40))
            make.right.equalToSuperview().offset(-AdaptSize(20))
            make.size.equalTo(CGSize(width: AdaptSize(40), height: AdaptSize(25)))
        }
    }

    public override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .clear
        self.collectionView.delegate   = self
        self.collectionView.dataSource = self
        self.collectionView.register(BPImageBrowserCell.classForCoder(), forCellWithReuseIdentifier: kBPImageBrowserCellID)
        self.collectionView.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) { [weak self] in
            self?.scrollToCurrentPage()
        }
        self.albumButton.addTarget(self, action: #selector(self.showAlubmVC), for: .touchUpInside)
    }

    // MARK: ==== Animation ====
    private func showAnimation(startView: UIImageView) {
        self.startFrame = startView.convert(startView.bounds, to: kWindow)
        let imageView = UIImageView()
        imageView.frame       = startFrame!
        imageView.image       = startView.image
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView.isHidden = true
        UIView.animate(withDuration: 0.25) {
            imageView.frame = CGRect(origin: .zero, size: kWindow.size)
        } completion: { [weak self] (finished) in
            if (finished) {
                imageView.removeFromSuperview()
                self?.collectionView.isHidden = false
            }
        }
    }

    private func hideAnimation(currentView: UIImageView) {
        guard let startFrame = self.startFrame else {
            self.hide()
            return
        }
        let imageView = UIImageView()
        imageView.frame       = currentView.frame
        imageView.image       = currentView.image
        imageView.contentMode = .scaleAspectFit
        self.addSubview(imageView)
        self.collectionView.isHidden = true
        UIView.animate(withDuration: 0.25) { [weak self] in
            imageView.frame = startFrame
            self?.backgroundView.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if (finished) {
                imageView.removeFromSuperview()
                self.layer.opacity = 0.0
                self.hide()
            }
        }
    }

    // MARK: ==== Event ====

    /// 显示入场动画
    /// - Parameter animationView: 动画参考对象
    public func show(animationView: UIImageView?) {
        UIViewController.currentViewController?.view.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.autoresizingMask = UIView.AutoresizingMask(arrayLiteral: .flexibleHeight, .flexibleWidth)
        guard let imageView = animationView else {
            return
        }
        // 显示进入动画
        self.showAnimation(startView: imageView)
    }

    @objc
    public func hide() {
        self.removeFromSuperview()
    }

    @objc
    private func showAlubmVC() {
        let vc = BPPhotoAlbumViewController()
        vc.modelList = self.medioModelList
        UIViewController.currentNavigationController?.pushViewController(vc, animated: true)
    }


    // MARK: ==== Tools ====
    private func scrollToCurrentPage() {
        let offsetX = kWindow.width * CGFloat(self.currentIndex)
        self.collectionView.contentOffset = CGPoint(x: offsetX, y: 0)
    }

    // MARK: ==== UICollectionViewDelegate && UICollectionViewDataSource ====
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch type {
            case .custom(let modelList):
                return modelList.count
            case .system(let result):
                return result.count
        }
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: kBPImageBrowserCellID, for: indexPath) as? BPImageBrowserCell else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        switch type {
            case .custom(let modelList):
                cell.setCustomData(model: modelList[indexPath.row])
            case .system(let result):
                let asset: PHAsset = result.object(at: indexPath.row)
                cell.setSystemData(asset: asset)
        }
        return cell
    }

    // 滑动结束通知Cell
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        NotificationCenter.default.post(name: Notification.Name("kScrollDidEndDecelerating"), object: nil)
    }

    // MARK: ==== BPImageBrowserCellDelegate ====
    public func clickAction(imageView: UIImageView) {
        if self.startFrame != nil {
            self.hideAnimation(currentView: imageView)
        } else {
            self.hide()
        }
    }

    public func longPressAction(image: UIImage?) {
        BPActionSheet().addItem(title: "保存") {
            guard let image = image else {
                return
            }
            PHPhotoLibrary.shared().performChanges {
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            } completionHandler: { (result, error) in
                if result {
                    kWindow.toast("保存成功")
                } else {
                    kWindow.toast("保存失败")
                    BPLog("保存照片失败：" + ((error as NSError?)?.message ?? ""))
                }
            }
        }.show()
    }

    public func scrolling(reduce scale: Float) {
        self.backgroundView.layer.opacity = scale
    }

    public func closeAction(imageView: UIImageView) {
        if self.startFrame != nil {
            self.hideAnimation(currentView: imageView)
        } else {
            self.hide()
        }
    }
}
