//
//  SelectionView.swift
//  Mazaady
//
//  Created by Mina Malak on 09/02/2023.
//

import UIKit

class SelectionView: TableFactoryCardView {
    
    override var cardViewHeight:CGFloat {
        guard !options.isEmpty else { return 250}
        let value: CGFloat = CGFloat((options.count * 52) + 90)
        if value > (UIScreen.main.bounds.height * 0.75){
            return UIScreen.main.bounds.height * 0.75
        }
        return value
    }
    
    private var options: [Option] = []
    
    init(options: [Option]) {
        super.init(headerText: "", hasDoneButton: true)
        self.options = options
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
        return options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(tabelViewCell: SelectionTableViewCell.self, indexPath: indexPath)
        cell.setOption(option: options[indexPath.row])
        return cell
    }
}

//MARK: - UITableViewDelegate
extension SelectionView: UITableViewDelegate {
    
}
