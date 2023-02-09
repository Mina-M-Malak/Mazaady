//
//  SelectionView.swift
//  Mazaady
//
//  Created by Mina Malak on 09/02/2023.
//

import UIKit

class SelectionView: TableFactoryCardView {

    private let activityIndicator:UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: .medium)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.color = .black
        av.hidesWhenStopped = true
        av.isHidden = true
        return av
    }()
    
    init() {
        super.init(headerText: "", hasDoneButton: true)
    }
    
    override func setupViews() {
        super.setupViews()
        super.setTableDelegate(view: self)
        getTableView().registerCell(tabelViewCell: SelectionTableViewCell.self)
        performCardViewAnimation(state: true, isDeinit: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UITableViewDataSource
extension SelectionView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(tabelViewCell: SelectionTableViewCell.self, indexPath: indexPath)
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SelectionView: UITableViewDelegate {
    
}
