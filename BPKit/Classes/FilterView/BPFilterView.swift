//
//  BPFilterView.swift
//  BPKit
//
//  Created by samsha on 2021/7/15.
//

import UIKit

public enum BPFilterType {
    /// 简单列表展示
    case tableView(title: String, modelList: [BPFilterModel])
    /// 列表左侧显示图标
    case tableViewIcon(title: String, modelList: [BPFilterModel])
    /// 简单蜂巢展示
    case collectionView(title: String, modelList: [BPFilterModel])
    /// 区间显示
    case range(title: String, modelList: [BPFilterModel])
    /// 百分比区间显示
    case rangeScale(title: String, modelList: [BPFilterModel])
}

public struct BPFilterModel {
    var id: Int?
    var name: String?
    var iconUrl: String?
    var min: CGFloat?
    var max: CGFloat?
    var isSelected: Bool = false
}

protocol BPFilterViewDelegate: BPTaskFilterWeightCellDelegate {
    /// 筛选方式
    func filter(sourceIdList: Set<Int>, weightIdList: Set<Int>, statusIdList: Set<Int>, categoryIdList: Set<Int>)
    func showFilterView()
    func hideFilterView()
}

extension BPTaskFilterViewDelegate {
    func showFilterView(){}
    func hideFilterView(){}
    func clickWeightAction(model: BPProcurementTaskLevelFlag) {}
    func clickStatusAction(model: BPTaskStatus) {}
}

class BPTaskFilterView: BPView, UITableViewDelegate, UITableViewDataSource, BPTaskFilterWeightCellDelegate {
    
    private let sourceCellID: String   = "kBPTaskFilterSourceCell"
    private let weightCellID: String   = "kBPTaskFilterWeightCell"
    private let categoryCellID: String = "kBPTaskFilterCategoryCell"
    
    // 源数据
    private var typeModelList: [BPFilterType] = []
    
    weak var delegate: BPTaskFilterViewDelegate?
    
    private var shadowView: BPView = BPView()
    private var contentView: BPView = {
        let view = BPView()
        view.size = CGSize(width: AdaptSize(300), height: kScreenHeight)
        return view
    }()
    private var tableView: BPTableView = {
        let tableView = BPTableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = AdaptSize(56)
        tableView.separatorStyle     = .none
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.layer.masksToBounds = true
        return tableView
    }()
    private var bottomView: BPView = BPView()
    private var lineView: BPView = BPView()
    private var resetButton: BPButton = {
        let button = BPButton(.second)
        button.setTitle("重置", for: .normal)
        button.setTitleColor(UIColor.gray0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        return button
    }()
    private var confirmButton: BPButton = {
        let button = BPButton(.second)
        button.setTitle("确定", for: .normal)
        button.setTitleColor(UIColor.white0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(17))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(shadowView)
        self.addSubview(contentView)
        contentView.addSubview(tableView)
        contentView.addSubview(bottomView)
        bottomView.addSubview(lineView)
        bottomView.addSubview(resetButton)
        bottomView.addSubview(confirmButton)
        
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.snp.makeConstraints { (make) in
            make.size.equalTo(contentView.size)
            make.left.equalTo(shadowView.snp.right)
            make.centerY.equalToSuperview()
        }
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.bottom.equalTo(bottomView.snp.top)
        }
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(AdaptSize(70) + kSafeBottomMargin)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(0.6)
        }
        resetButton.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: AdaptSize(130), height: AdaptSize(47)))
            make.top.equalToSuperview().offset(AdaptSize(12))
            make.right.equalToSuperview().multipliedBy(0.5).offset(AdaptSize(-5))
        }
        confirmButton.snp.makeConstraints { (make) in
            make.size.top.equalTo(resetButton)
            make.left.equalTo(resetButton.snp.right).offset(AdaptSize(10))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        let tapShadowGes = UITapGestureRecognizer(target: self, action: #selector(self.hide))
        self.shadowView.addGestureRecognizer(tapShadowGes)
        self.resetButton.addTarget(self, action: #selector(self.resetAction), for: .touchUpInside)
        self.confirmButton.addTarget(self, action: #selector(self.confirmAction), for: .touchUpInside)
    }
    
    override func updateUI() {
        super.updateUI()
        self.shadowView.backgroundColor  = UIColor.black.withAlphaComponent(0.5)
        self.contentView.backgroundColor = UIColor.with(.white0, dark: .black0)
        self.bottomView.backgroundColor  = UIColor.clear
        self.lineView.backgroundColor    = UIColor.gray1
        self.resetButton.backgroundColor = .gray4
    }
    
    // MARK: ==== Event ====
    
    func show(typeModelList: [BPFilterType]) {
        self.typeModelList = typeModelList
        self.tableView.reloadData()
        kWindow.addSubview(self)
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.shadowView.layer.opacity = 1.0
            self.contentView.transform    = CGAffineTransform(translationX: -self.contentView.width, y: 0)
        }
        self.delegate?.showFilterView()
    }
    
    @objc
    func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            guard let self = self else { return }
            self.shadowView.layer.opacity = 0
            self.contentView.transform    = .identity
        } completion: { [weak self] (result) in
            self?.removeFromSuperview()
        }
        self.delegate?.hideFilterView()
    }
    
    @objc
    private func resetAction() {
        self.hide()
        self.delegate?.filter(sourceIdList: [], weightIdList: [], statusIdList: [], categoryIdList: [])
    }
    
    @objc
    private func confirmAction() {
        self.hide()
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.filterTypeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = filterTypeList[section]
        switch type {
        case .source:
            return self.sourceList.count
        case .weight, .status:
            return 1
        case .category:
            return self.categoryModelList.count
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = BPTaskFilterHeaderView()
        header.bindData(type: filterTypeList[section])
        return header
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type = self.filterTypeList[indexPath.section]
        switch type {
        case .source:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: sourceCellID) as? BPTaskFilterSourceCell else {
                return UITableViewCell()
            }
            let model      = self.sourceList[indexPath.row]
            let isSelected = self.selectedSourceIdList.contains(model.id)
            cell.bindData(model: model, isSelected: isSelected)
            return cell
        case .weight:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: weightCellID) as? BPTaskFilterWeightCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.bindWeightDataList(modelList: self.weightModelList, selectedIdlList: self.selectedWeightIdList)
            return cell
        case .status:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: weightCellID) as? BPTaskFilterWeightCell else {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.bindStatusList(modelList: self.taskStatusList, selectedIdlList: self.selectedStatusIdList)
            return cell
        case .category:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellID) as? BPTaskFilterCategoryCell else {
                return UITableViewCell()
            }
            let model      = self.categoryModelList[indexPath.row]
            let isSelected = self.selectedCategoryList.contains(model.id)
            cell.bindData(model: model, isSelected: isSelected)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return AdaptSize(44)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return AdaptSize(30)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.filterTypeList[indexPath.section]
        switch type {
        case .source:
            let model = self.sourceList[indexPath.row]
            if self.selectedSourceIdList.contains(model.id) {
                self.selectedSourceIdList.remove(model.id)
            } else {
                self.selectedSourceIdList.insert(model.id)
            }
        case .weight:
            let model = self.weightModelList[indexPath.row]
            if self.selectedWeightIdList.contains(model.rawValue) {
                self.selectedWeightIdList.remove(model.rawValue)
            } else {
                self.selectedWeightIdList.insert(model.rawValue)
            }
        case .status:
            let model = self.taskStatusList[indexPath.row]
            if self.selectedStatusIdList.contains(model.rawValue) {
                self.selectedStatusIdList.remove(model.rawValue)
            } else {
                self.selectedStatusIdList.insert(model.rawValue)
            }
        case .category:
            let model = self.categoryModelList[indexPath.row]
            if self.selectedCategoryList.contains(model.id) {
                self.selectedCategoryList.remove(model.id)
            } else {
                self.selectedCategoryList.insert(model.id)
            }
        }
        tableView.reloadData()
    }
    
    // MARK: ==== BPTaskFilterWeightCellDelegate ====
    func clickWeightAction(model: BPProcurementTaskLevelFlag) {
        if self.selectedWeightIdList.contains(model.rawValue) {
            self.selectedWeightIdList.remove(model.rawValue)
        } else {
            self.selectedWeightIdList.insert(model.rawValue)
        }
        tableView.reloadData()
    }
    
    func clickStatusAction(model: BPTaskStatus) {
        if self.selectedStatusIdList.contains(model.rawValue) {
            self.selectedStatusIdList.remove(model.rawValue)
        } else {
            self.selectedStatusIdList.insert(model.rawValue)
        }
        tableView.reloadData()
    }
}

