//
//  BPTableView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/2/22.
//

import Foundation

public protocol BPTableViewIndexViewDelegate: NSObjectProtocol {
    func indexTitle(section: Int) -> String
}

private struct TBAssociatedKeys {
    static var defaultImage: String = "kDefaultImage"
    static var defaultHint: String  = "kDefaultHint"
    static var buttonText: String   = "kButtonText"
    static var buttonAction: String = "kButtonAction"
}

public extension UITableViewDataSource {
    /// 空页面
    /// - Parameters:
    ///   - image: 图片
    ///   - hintText: 文案
    ///   - buttonText: 按钮文案
    ///   - actionBlock: 按钮事件
    func setEmptyViewData(image: UIImage?, hintText: String?, buttonText: String?, actionBlock: (()->Void)?) {
        objc_setAssociatedObject(self, &TBAssociatedKeys.defaultImage, image, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        objc_setAssociatedObject(self, &TBAssociatedKeys.defaultHint, hintText, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &TBAssociatedKeys.buttonText, buttonText, .OBJC_ASSOCIATION_RETAIN)
        objc_setAssociatedObject(self, &TBAssociatedKeys.buttonAction, actionBlock, .OBJC_ASSOCIATION_RETAIN)
    }
    
    /// 空页面
    /// - Parameters:
    ///   - image: 图片
    ///   - hintText: 文案
    ///   - buttonText: 按钮文案
    ///   - actionBlock: 按钮事件
    func getEmptyViewData() -> (UIImage?, String?, String?, (()->Void)?) {
        let image       = objc_getAssociatedObject(self, &TBAssociatedKeys.defaultImage) as? UIImage
        let hintText    = objc_getAssociatedObject(self, &TBAssociatedKeys.defaultHint) as? String
        let buttonText  = objc_getAssociatedObject(self, &TBAssociatedKeys.buttonText) as? String
        let actionBlock = objc_getAssociatedObject(self, &TBAssociatedKeys.buttonAction) as? (()->Void)
        return (image, hintText, buttonText, actionBlock)
    }
}

open class BPTableView: UITableView {

    private var currentSelectedIndex: Int = -1 {
        willSet {
            if currentSelectedIndex != newValue {
                if currentSelectedIndex < indexItemList.count && currentSelectedIndex >= 0 {
                    self.indexItemList[currentSelectedIndex].textColor = indexNormalColor
                }
                if newValue < indexItemList.count && newValue >= 0 {
                    self.indexItemList[newValue].textColor = indexSelectedColor
                }
            }
        }
    }
    private let itemW  = AdaptSize(30)
    private let itemH  = AdaptSize(20)
    private let guideW = AdaptSize(60)
    private let guideH = AdaptSize(60)
    /// 索引默认文字颜色
    private let indexNormalColor   = UIColor.black1
    /// 索引选中颜色
    private let indexSelectedColor = UIColor.blue0
    /// 索引回调代理
    public weak var indexDelegate: BPTableViewIndexViewDelegate?
    
    private var indexView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    private var indexItemList: [UILabel] = []
    private var indexGuideLabel: UILabel = {
        let label = UILabel()
        label.text            = ""
        label.textColor       = UIColor.black0
        label.font            = UIFont.regularFont(ofSize: AdaptSize(18))
        label.textAlignment   = .center
        label.isHidden        = true
        label.backgroundColor = UIColor.gray4
        return label
    }()
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.updateUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        self.updateUI()
    }
    
    /// 更新UI颜色、图片
    open func updateUI() {
        self.backgroundColor = .with(.gray4, dark: .black0)
    }
    
    public override func reloadData() {
        super.reloadData()
        // 添加索引
        if indexDelegate != nil {
            self.createIndexView()
            self.addGestureAction()
            self.currentSelectedIndex = 0
        }
        // 配置空页面
        self.configEmptyView()
    }
    
    /// 配置默认空页面
    private func configEmptyView() {
        var count = 0
        for section in 0..<numberOfSections {
            count += numberOfRows(inSection: section)
        }
        guard count == 0 else {
            self.backgroundView = nil
            return
        }
        let tupleData = self.dataSource?.getEmptyViewData()
        let emptyView = BPTableViewEmptyView()
        emptyView.setData(image: tupleData?.0, hintText: tupleData?.1, buttonText: tupleData?.2, actionBlock: tupleData?.3)
        self.backgroundView = emptyView
    }

    // TODO: ==== IndexView ====
    private func createIndexView() {
        indexView.removeFromSuperview()
        guard let _superView = superview else { return }
        _superView.addSubview(indexView)
        _superView.addSubview(indexGuideLabel)
        var offsetY = CGFloat.zero
        self.indexItemList.removeAll()
        for section in 0..<self.numberOfSections {
            let label = BPLabel()
            label.tag             = section
            label.text            = self.indexDelegate?.indexTitle(section: section)
            label.textColor       = self.indexNormalColor
            label.font            = UIFont.regularFont(ofSize: AdaptSize(12))
            label.textAlignment   = .center
            label.isUserInteractionEnabled = true
            self.indexView.addSubview(label)
            label.snp.makeConstraints { (make) in
                make.right.equalToSuperview()
                make.top.equalToSuperview().offset(offsetY)
                make.size.equalTo(CGSize(width: itemW, height: itemH))
            }
            self.indexItemList.append(label)
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(sender:)))
            label.addGestureRecognizer(tapGes)
            offsetY += itemH
        }
        indexView.snp.makeConstraints { (make) in
            make.right.equalTo(_superView)
            make.height.equalTo(offsetY)
            make.width.equalTo(itemW)
            make.centerY.equalToSuperview()
        }
    }

    /// 显示放大指示视图
    public func showIndexGuideView(section: Int) {
        indexGuideLabel.text     = self.indexDelegate?.indexTitle(section: section)
        indexGuideLabel.isHidden = false
        let offsetY = self.indexView.top + CGFloat(section) * itemH
        indexGuideLabel.frame = CGRect(x: kScreenWidth - itemW - guideW - AdaptSize(15), y: offsetY, width: guideW, height: guideH)
    }

    public func displayIndex(section: Int) {
        self.selectedIndexView(section: section, showGuideView: false, autoScroll: false)
    }

    private func addGestureAction() {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.tapAction(sender:)))
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(panAction(sender:)))
        self.indexView.addGestureRecognizer(tapGes)
        self.indexView.addGestureRecognizer(panGes)
    }

    // MARK: ==== Gesture Action ====
    @objc
    private func tapAction(sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.indexView)
        let section  = Int(ceil(location.y / itemH)) - 1
        self.selectedIndexView(section: section, showGuideView: false, autoScroll: true)
        if sender.state == .ended || sender.state == .cancelled {
            self.indexGuideLabel.isHidden = true
        }
    }

    @objc
    private func panAction(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let location = sender.location(in: self.indexView)
            let section  = Int(ceil(location.y / itemH)) - 1
            self.selectedIndexView(section: section, showGuideView: true, autoScroll: true)
        } else if sender.state == .ended || sender.state == .cancelled {
            self.indexGuideLabel.isHidden = true
        }
    }

    // MARK: ==== Event ====
    private func selectedIndexView(section: Int, showGuideView: Bool, autoScroll: Bool) {
        guard section != self.currentSelectedIndex, section < numberOfSections, section >= 0 else { return }
        self.currentSelectedIndex = section
        // 震动
        shake()
        if showGuideView {
            self.showIndexGuideView(section: section)
        }
        if autoScroll {
            self.scrollToRow(at: IndexPath(row: 0, section: section), at: .top, animated: true)
        }
    }
}
