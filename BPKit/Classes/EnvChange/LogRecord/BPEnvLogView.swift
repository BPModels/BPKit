//
//  BPEnvLogView.swift
//  BPKit
//  查看网络日志
//  Created by samsha on 2021/7/6.
//

import Foundation
import BPNetwork
import BPDeviceInfo
import ObjectMapper

@objc
public class BPEnvLogView:
    BPView,
    UITableViewDelegate,
    UITableViewDataSource,
    UIGestureRecognizerDelegate,
    BPEnvLogToolsBarDeleagate {
    
    private let headerID = "kBPEnvLogHeader"
    private let cellID   = "kBPEnvLogHeader"
    private var modelList: [BPEnvLogModel] = []
    private let minWidth  = AdaptSize(50)
    private let minHeight = AdaptSize(150)
    private let maxWidth  = kScreenWidth - AdaptSize(30)
    private let maxHeight = kScreenHeight - AdaptSize(45) - kSafeBottomMargin
    private let minX      = AdaptSize(15)
    private let minY      = AdaptSize(15)
    private var moveLastPoint: CGPoint = .zero
    private var moveGes: UIPanGestureRecognizer?
    private var adjustGes: UIPanGestureRecognizer?
    
    private let toolsBar: BPEnvLogToolsBar = BPEnvLogToolsBar()
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight  = AdaptSize(56)
        tableView.sectionHeaderHeight = AdaptSize(40)
        tableView.backgroundColor     = UIColor.clear
        tableView.separatorStyle      = .none
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    private var adjustImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        if let path = sourceBundle?.path(forResource: "log_adjust_icon", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                if let iconImage = UIImage.sd_image(withGIFData: data) {
                    imageView.setInsets(with: iconImage, edge: UIEdgeInsets(top: AdaptSize(30), left: AdaptSize(35), bottom: AdaptSize(10), right: AdaptSize(5)))
                }
            }
        }
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: AdaptSize(15), y: AdaptSize(30), width: maxWidth, height: maxHeight))
        self.createSubviews()
        self.bindProperty()
        NotificationCenter.default.addObserver(self, selector: #selector(addLog(sender:)), name: Notification.Name("kBPSendRequestLog"), object: nil)
        moveGes   = UIPanGestureRecognizer(target: self, action: #selector(moveAction(sender:)))
        moveGes?.delegate = self
        self.tableView.addGestureRecognizer(moveGes!)
        adjustGes = UIPanGestureRecognizer(target: self, action: #selector(adjustAction(sender:)))
        self.adjustImageView.addGestureRecognizer(adjustGes!)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func createSubviews() {
        super.createSubviews()
        self.layer.cornerRadius  = AdaptSize(10)
        self.layer.masksToBounds = true
        self.layer.setDefaultShadow()
        self.backgroundColor = UIColor.white0.withAlphaComponent(0.75)
        
        self.addSubview(toolsBar)
        self.addSubview(tableView)
        self.addSubview(adjustImageView)
        toolsBar.snp.makeConstraints { make in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(AdaptSize(50))
        }
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(toolsBar.snp.bottom)
            make.bottom.equalTo(adjustImageView.snp.top)
        }
        adjustImageView.snp.makeConstraints { make in
            make.right.bottom.equalToSuperview()
            make.width.equalTo(AdaptSize(60))
            make.height.equalTo(AdaptSize(50))
        }
    }
    
    public override func bindProperty() {
        super.bindProperty()
        toolsBar.delegate    = self
        tableView.delegate   = self
        tableView.dataSource = self
        tableView.register(BPEnvLogHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: headerID)
        tableView.register(BPEnvLogCell.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    /// 请求日志
    /// - Parameter sender: 通知对象
    @objc
    private func addLog(sender: Notification) {
        guard let request  = sender.userInfo?["request"] as? BPRequest,
              let response = sender.userInfo?["response"] as? BPBaseResopnse
        else {
            return
        }
        var model = BPEnvLogModel()
        model.request  = request
        model.response = response
        self.modelList.append(model)
        self.tableView.reloadData()
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: modelList.count - 1), at: .bottom, animated: true)
    }
    
    /// 移动
    @objc
    private func moveAction(sender: UIPanGestureRecognizer) {
        guard sender.numberOfTouches > 1 else { return }
        if sender.state == .changed {
            // 移动
            let point   = sender.location(in: kWindow)
            let offsetX = moveLastPoint.x - point.x
            let offsetY = moveLastPoint.y - point.y
            let newX    = self.origin.x - offsetX
            let newY    = self.origin.y - offsetY
            guard newX > minX
                    && newY > minY
                    && newX + width < kScreenWidth
                    && newY + height < kScreenHeight else {
                return
            }
            self.origin = CGPoint(x: newX, y: newY)
            self.moveLastPoint = sender.location(in: kWindow)
        } else if sender.state == .began {
            self.moveLastPoint = sender.location(in: kWindow)
        }
    }
    
    /// 调整大小
    @objc
    private func adjustAction(sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            // 放大缩小
            let point     = sender.location(in: kWindow)
            var newWidth  = point.x - self.origin.x
            var newHeight = point.y - self.origin.y
            
            newWidth  = newWidth > minWidth ? newWidth : minWidth
            newHeight = newHeight > minHeight ? newHeight : minHeight
            newWidth  = newWidth < maxWidth ? newWidth : maxWidth
            newHeight = newHeight < maxHeight ? newHeight : maxHeight
            self.width    = newWidth
            self.height   = newHeight
        }
    }
    
    private struct AssociatedKeys {
        static var logView: String = "kLogView"
    }
    
    @objc
    public static func show() {
        var logView = objc_getAssociatedObject(kWindow, &AssociatedKeys.logView) as? BPEnvLogView
        if logView == nil {
            logView = BPEnvLogView(frame: .zero)
            kWindow.addSubview(logView!)
            objc_setAssociatedObject(kWindow, &AssociatedKeys.logView, logView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        logView?.isHidden = false
    }
    
    @objc
    public static func hide() {
        guard let logView = objc_getAssociatedObject(kWindow, &AssociatedKeys.logView) as? BPEnvLogView else {
            return
        }
        logView.isHidden = true
    }
    
    // MARK: ==== UIGestureRecognizerDelegate ====
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == moveGes {
            return gestureRecognizer.numberOfTouches > 1
        } else {
            return true
        }
    }
    
    // MARK: ==== BPEnvLogToolsBarDeleagate ====
    func clearAction() {
        self.modelList.removeAll()
        self.tableView.reloadData()
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    public func numberOfSections(in tableView: UITableView) -> Int {
        return modelList.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as? BPEnvLogHeader else {
            return nil
        }
        let model = self.modelList[section]
        headerView.setData(model: model)
        return headerView
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? BPEnvLogCell else {
            return UITableViewCell()
        }
        let model = self.modelList[indexPath.row]
        cell.setData(model: model)
        return cell
    }
}

