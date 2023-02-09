//
//  TableFactoryCardView.swift
//  Mazaady
//
//  Created by Mina Malak on 09/02/2023.
//

import UIKit

class TableFactoryCardView : BottomActionSheetView {
    
    private let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        lbl.textColor = .black
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var doneButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Done", for: .normal)
        btn.setTitleColor(.darkGray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        btn.addTarget(self, action: #selector(onTouchDone(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var sepratorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.makeRoundedCornersWith(radius: 8.0)
        view.alpha = 1.0
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tbv = UITableView(frame: .zero, style: .plain)
        tbv.translatesAutoresizingMaskIntoConstraints = false
        tbv.backgroundColor = .white
        tbv.isScrollEnabled = true
        tbv.separatorStyle = .singleLine
        tbv.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)
        tbv.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tbv.frame.size.width, height: 1))
        tbv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        return tbv
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.placeholder = "Search"
        return sb
    }()
    
    private let hasDoneButton: Bool
    var doneButtonClicked: (()->())?
    deinit {
        searchBar.delegate = nil
        tableView.delegate = nil
        tableView.dataSource = nil
    }
    
    init(headerText:String, hasDoneButton:Bool = false) {
        self.hasDoneButton = hasDoneButton
        super.init(includeDarkView: true)
        self.setHeader(title: headerText)
    }
    
    override func setupViews() {
        super.setupViews()
        addSubview(headerLabel)
        addSubview(sepratorView)
        if hasDoneButton {
            addSubview(doneButton)
        }
        addSubview(searchBar)
        addSubview(tableView)
    }
    
    override func setupAutolayouts() {
        super.setupAutolayouts()
        headerLabel.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 44, left: 24, bottom: 0, right: 24))
        if hasDoneButton {
            doneButton.centerYAnchor.constraint(equalTo: headerLabel.centerYAnchor).isActive = true
            doneButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24).isActive = true
            doneButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            doneButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        sepratorView.anchor(top: headerLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 24, left: 24, bottom: 0, right: 24),size: CGSize(width: 0, height: 0.3))
        searchBar.anchor(top: sepratorView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0),size: CGSize(width: 0, height: 50))
        tableView.anchor(top: searchBar.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//MARK: - Setters
extension TableFactoryCardView {
    /**
     Add your view to conform setTableDelegate
     
     - Parameter view : Pass the view to conform to tableview delegates and data source
     */
    public func setTableDelegate(view:UIView) {
        tableView.delegate = view as? UITableViewDelegate
        tableView.dataSource = view as? UITableViewDataSource
    }
    
    public func setTableSelection(allowsMultipleSelection:Bool) {
        tableView.allowsMultipleSelection = allowsMultipleSelection
    }
    
    public func alignHeaderLabel(_ alignment:NSTextAlignment) {
        headerLabel.textAlignment = alignment
    }
    
    public func setHeader(title:String) {
        headerLabel.text = title
    }
    
    public func setDoneButton(enabled:Bool) {
        doneButton.isEnabled = enabled
        doneButton.alpha = enabled ? 1 : 0.5
    }
    
    public func setSearchDelegate(view:UIView) {
        searchBar.delegate = view as? UISearchBarDelegate
    }
}

//MARK: - Getters
extension TableFactoryCardView {
    func getTableView() -> UITableView {
        return tableView
    }
}

//MARK: - Actions
extension TableFactoryCardView {
    @objc func onTouchDone(_ sender: UIButton) {
        searchBar.endEditing(true)
        doneButtonClicked?()
    }
}

