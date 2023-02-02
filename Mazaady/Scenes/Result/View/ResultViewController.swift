//
//  ResultViewController.swift
//  Mazaady
//
//  Created by Mina Malak on 02/02/2023.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var resultTableView: UITableView!
    
    var results: [ResultModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerCells()
    }
    
    private func registerCells() {
        resultTableView.registerCell(tabelViewCell: ResultTableViewCell.self)
    }
}

//MARK: - UITableViewDataSource
extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(tabelViewCell: ResultTableViewCell.self, indexPath: indexPath)
        cell.setProperty(data: results[indexPath.row])
        return cell
    }
}
