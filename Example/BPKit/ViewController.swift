//
//  ViewController.swift
//  BPKit
//
//  Created by TestEngineerFish on 06/10/2021.
//  Copyright (c) 2021 TestEngineerFish. All rights reserved.
//

import UIKit
import BPKit

class ViewController: BPViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = AdaptSize(56)
        tableView.backgroundColor    = UIColor.gray4
        tableView.separatorStyle     = .none
        tableView.refreshHeaderEnable = true
        tableView.refreshFooterEnable = true
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    private var subtitle: BPLabel = {
        let label = BPLabel()
        label.text          = IconFont.back.rawValue
        label.textColor     = UIColor.red
        label.font          = UIFont.iconFont(size: AdaptSize(33))
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "HOME"
        self.createSubviews()
        self.bindProperty()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(subtitle)
        self.view.addSubview(tableView)
        subtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(AdaptSize(50))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(subtitle.snp.bottom)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .randomColor()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }

}
