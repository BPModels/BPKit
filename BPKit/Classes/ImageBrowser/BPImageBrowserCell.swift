//
//  BPImageBrowserCell.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2020/11/2.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Photos

protocol BPImageBrowserCellDelegate: NSObjectProtocol {
    func clickAction(imageView: UIImageView)
    func longPressAction(image: UIImage?)
    func scrolling(reduce scale: Float)
    func closeAction(imageView: UIImageView)
}

class BPImageBrowserCell: BPCollectionViewCell, UIScrollViewDelegate, UIGestureRecognizerDelegate {

    /// 手指离开后，超过该值则关闭视图
    private let maxOffsetY: CGFloat = 100
    /// 最大滑动缩放范围
    private let maxScaleY: CGFloat  = AdaptSize(1000)
    /// 最小缩放比例
    private let minScale: CGFloat   = 0.5
    weak var delegate: BPImageBrowserCellDelegate?
    private var panGes: UIPanGestureRecognizer?
    /// 页面是否在滑动中
    private var isScrolling = false

    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 3
        scrollView.minimumZoomScale = 1
        return scrollView
    }()
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    private var progressView = BPProgressView(type: .round, size: CGSize(width: AdaptSize(60), height: AdaptSize(60)), lineWidth: AdaptSize(5))

    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.createSubviews()
        self.bindProperty()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func createSubviews() {
        super.createSubviews()
        self.addSubview(scrollView)
        self.scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(imageView)
        scrollView.addSubview(progressView)
        imageView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(self)
        }
        progressView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.size.equalTo(progressView.size)
        }
        scrollView.contentSize = kWindow.size
    }

    internal override func bindProperty() {
        super.bindProperty()
        self.scrollView.delegate = self
        self.backgroundColor     = .clear
        self.progressView.isHidden = true
        let tapGes       = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(sender:)))
        self.panGes      = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(sender:)))
        self.addGestureRecognizer(tapGes)
        self.addGestureRecognizer(longPressGes)
        self.addGestureRecognizer(panGes!)
        panGes?.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(didEndScroll), name: Notification.Name("kScrollDidEndDecelerating"), object: nil)
    }

    // MARK: ==== Event ====

    func setCustomData(model: BPMediaModel) {
        model.getOriginImage(progress: nil) { [weak self] (image: UIImage?) in
            self?.imageView.image = image
        }
    }
    
    func setSystemData(asset: PHAsset) {
        let medioModel = asset.transforMediaModel { [weak self] (progress) in
            guard let self = self else { return }
            self.progressView.isHidden = false
            self.progressView.setProgress(progress: CGFloat(progress))
            self.progressView.isHidden = progress >= 1
        }
        self.imageView.image = medioModel?.image
    }

    @objc private func didEndScroll() {
        self.isScrolling = false
    }

    /// 点击手势事件
    @objc private func tapAction(sender: UITapGestureRecognizer) {
        self.delegate?.clickAction(imageView: self.imageView)
    }

    /// 长按手势事件
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            self.delegate?.longPressAction(image: self.imageView.image)
        }
    }
    var originPoint = CGPoint.zero
    /// 滑动手势
    @objc private func panAction(sender: UIPanGestureRecognizer) {
        let point = sender.translation(in: self)
        switch sender.state {
        case .began:
            self.originPoint = point
        case .changed:
            guard point.y > 10, !isScrolling else {
                return
            }
            let scale: CGFloat = {
                if point.y > self.maxScaleY {
                    return self.minScale
                } else {
                    let _scale = (self.maxScaleY - point.y) / self.maxScaleY
                    return _scale > self.minScale ? _scale : self.minScale
                }
            }()
            self.delegate?.scrolling(reduce: Float(scale))
            // a:控制x轴缩放；d：控制y轴缩放；
            self.imageView.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: point.x, ty: point.y)
        case .ended:
            if point.y - originPoint.y > self.maxOffsetY {
                self.delegate?.closeAction(imageView: self.imageView)
            } else {
                UIView.animate(withDuration: 0.15) { [weak self] in
                    self?.imageView.transform = .identity
                }
            }
        default:
            return
        }
    }

    // MARK: ==== UIScrollViewDelegate ====
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }

    // MARK: ==== UIGestureRecognizerDelegat ====
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let panGes = gestureRecognizer as? UIPanGestureRecognizer else {
            return false
        }
        let point = panGes.translation(in: self)
        if point.y > 0 {
            return false
        } else {
            if point.x != 0 && point.y == 0 {
                self.isScrolling = true
            }
            return true
        }
    }

}
