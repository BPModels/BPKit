//  加载页面
//  BPLoadingView.swift
//  Tenant
//
//  Created by samsha on 2021/2/18.
//

import Foundation
import SDWebImage

open class BPLoadingView: BPView {
    
    static let share = BPLoadingView()
    /// 请求显示计数
    var count: Int = 0

    private var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image       = getImage(name: "loading", type: "gif")
        return imageView
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(AdaptSize(-30))
            make.size.equalTo(CGSize(width: AdaptSize(122), height: AdaptSize(150)))
        }
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = UIColor.hex(0xf8f8f8)
        self.layer.opacity   = 0.0
    }
    
    // MARK: ==== Event ====
    public func show(delay: Double) {
        self.count += 1
        // 延迟显示
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            guard let self = self, self.count > 0 else { return }
            UIView.animate(withDuration: 0.25) {[weak self] in
                guard let self = self else { return }
                self.layer.opacity = 1.0
            }
        }
    }
    
    public func hide() {
        self.count -= 1
        guard self.count <= 0 else { return }
        /// 容错
        self.count = 0
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.layer.opacity = 0.0
        } completion: { [weak self] (finished) in
            guard let self = self else { return }
            if finished {
                self.removeFromSuperview()
            }
        }
    }
    
    
    /// 强制隐藏
    public func hideForce() {
        self.count = 0
        self.hide()
    }
}

