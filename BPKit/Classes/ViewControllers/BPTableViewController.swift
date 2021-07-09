//
//  BPTableViewController.swift
//  BPKit
//
//  Created by samsha on 2021/6/28.
//

import Foundation
import ObjectMapper
import BPDeviceInfo
import BPNetwork

public protocol BPTableViewControllerDelegate: NSObjectProtocol {
    /// 显示的Header（可选）
    func headerView() -> BPView
    /// 显示的Footer（可选）
    func footerView() -> BPView
    /// 请求体 （ --必须实现--）
    var request: BPRequest { get set }
    /// 是否显示搜索（可选）
    var isShowSearch: Bool { get }
    /// 是否显示筛选（可选）
    var isShowFilter: Bool { get }
    /// 是否显示悬浮添加按钮（可选）
    var isShowAddButton: Bool { get }
}

public extension BPTableViewControllerDelegate {
    func headerView() -> BPView { return BPView() }
    func footerView() -> BPView { return BPView() }
    var isShowSearch: Bool { return false }
    var isShowFilter: Bool { return false }
    var isShowAddButton: Bool { return false }
}

open class BPTableViewController<T: Mappable, C:BPTableViewCell>: BPViewController, UITableViewDelegate, UITableViewDataSource, BPRefreshProtocol {
    
    var modelList: [T] = []
    public weak var delegate: BPTableViewControllerDelegate?
    private let cellID = "kBPTableViewControllerCell"
    
    public var tableView: BPTableView = {
        let tableView = BPTableView()
        tableView.estimatedRowHeight  = AdaptSize(56)
        tableView.separatorStyle      = .none
        tableView.backgroundColor     = .yellow
        tableView.refreshHeaderEnable = true
        tableView.refreshFooterEnable = true
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    private var addButton: BPButton = {
        let button = BPButton()
        if let path = sourceBundle?.path(forResource: "bp_add_icon", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            if let data = try? Data(contentsOf: url) {
                let iconImage = UIImage.sd_image(withGIFData: data)
                button.setImage(iconImage, for: .normal)
            }
        }
        return button
    }()
    
    private var topView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.white0
        return view
    }()
    
    public var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder     = "搜索"
        bar.searchBarStyle  = .minimal
        bar.backgroundColor = .white0
        return bar
    }()
    
    private var filterButton: BPButton = {
        let button = BPButton()
        button.setTitle("筛选", for: .normal)
        button.setTitleColor(UIColor.blue0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        return button
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.configTopView()
        self.configTableView()
        if self.delegate?.isShowAddButton ?? false {
            self.configAddButton()
        }
        self.request(nil)
    }
    
    /// 配置TableView
    private func configTableView() {
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            if self.delegate?.isShowSearch ?? false {
                make.top.equalTo(topView.snp.bottom)
            } else {
                make.top.equalToSuperview().offset(kNavHeight)
            }
        }
        self.tableView.backgroundColor = .gray4
        self.tableView.delegate        = self
        self.tableView.dataSource      = self
        self.tableView.refreshDelegate = self
        self.tableView.register(C.classForCoder(), forCellReuseIdentifier: cellID)
    }
    
    /// 配置添加按钮
    private func configAddButton() {
        self.view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.width.height.equalTo(AdaptSize(55))
            make.right.equalToSuperview().offset(AdaptSize(-12.5))
            make.bottom.equalToSuperview().offset(AdaptSize(-77) - kSafeBottomMargin)
        }
        addButton.addTarget(self, action: #selector(addAction), for: .touchUpInside)
    }
    
    /// 配置搜索栏
    private func configTopView() {
        let isShowSearch = self.delegate?.isShowSearch ?? false
        let isShowFilter = self.delegate?.isShowFilter ?? false
        if isShowSearch || isShowFilter {
            self.view.addSubview(topView)
            topView.snp.makeConstraints { make in
                make.left.right.equalToSuperview()
                make.top.equalToSuperview().offset(kNavHeight)
                make.height.equalTo(AdaptSize(66))
            }
            // 添加筛选
            if isShowFilter {
                topView.addSubview(filterButton)
                filterButton.snp.makeConstraints { make in
                    make.width.equalTo(AdaptSize(73))
                    make.right.top.bottom.equalToSuperview()
                }
            }
            // 添加搜索
            if isShowSearch {
                topView.addSubview(searchBar)
                searchBar.snp.makeConstraints { make in
                    make.left.equalToSuperview().offset(AdaptSize(10))
                    make.centerY.equalToSuperview()
                    make.height.equalTo(AdaptSize(36))
                    if isShowFilter {
                        make.right.equalTo(filterButton.snp.left)
                    } else {
                        make.right.equalToSuperview().offset(AdaptSize(-10))
                    }
                }
            }
        }
    }
    
    // MARK: ==== Request ====
    public func request(_ block: DefaultBlock?) {
        guard let request = self.delegate?.request else { return }
        BPNetworkService.default.request(BPStructDataArrayResponse<T>.self, request: request) { (response) in
            guard let modelList = response.dataArray else { return }
            if self.tableView.page > 1 {
                self.modelList += modelList
            } else {
                self.modelList = modelList
            }
            self.tableView.reloadData()
            block?()
        } fail: { (error) in
            block?()
            kWindow.toast((error as NSError).message)
        }
    }
    
    // MARK: ==== Event ====
    /// 添加按钮点击事件
    @objc
    open func addAction() {
        print("replace me")
        self.tableView.reloadData()
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource  ====
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.modelList.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? BPTableViewCell else { return UITableViewCell() }
        let _model = self.modelList[indexPath.row]
        cell.bindData(model: _model)
        cell.backgroundColor = .randomColor()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.delegate?.headerView()
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.delegate?.footerView()
    }
    
    // MARK: ==== BPRefreshProtocol ====
    public func loadingHeader(scrollView: UIScrollView, completion block: DefaultBlock?) {
        self.request(block)
    }
    
    public func loadingFooter(scrollView: UIScrollView, completion block: DefaultBlock?) {
        self.request(block)
    }
}
