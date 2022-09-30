//
//  ViewController.swift
//  DiffalbeDataSource
//
//  Created by Dennis Programmer on 30/9/22.
//

import UIKit

class ViewController: UIViewController {
    let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        return tv
    }()
    
    lazy var addButton: UIButton = { [unowned self] in
       let button = UIButton()
        button.setTitle("Add element", for: .normal)
        button.addTarget(self, action: #selector(performAddElement), for: .touchUpInside)
        button.backgroundColor = .green
        return button
    }()
    
    var diffalbeDS: UITableViewDiffableDataSource<Section, CellInfo>!
    var cellInfo: [CellInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.frame = view.frame
        view.addSubview(tableView)
        addButton.frame = CGRect(x: 0, y: 50, width: 100, height: 20)
        addButton.center.x = view.center.x
        view.addSubview(addButton)
        
        tableView.delegate = self
        setDiffalbeDS()
    }
    
    @objc private func performAddElement() {
        let newInfo = CellInfo(text: "New cell: \(cellInfo.count)")
        cellInfo.append(newInfo)
        updateDS()
    }

// MARK: -- DS related
    private func setDiffalbeDS() {
        diffalbeDS = UITableViewDiffableDataSource(tableView: tableView) { [unowned self] tableView, indexPath, itemIdentifier in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            cell.textLabel?.text = self.cellInfo[indexPath.row].text
            return cell
        }
    }
    
    private func updateDS() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, CellInfo>()
        snapshot.appendSections([.first])
        snapshot.appendItems(cellInfo, toSection: .first)
        diffalbeDS.apply(snapshot, animatingDifferences: true) {
            print("TV DiffableDS has been updated")
        }
    }
}

extension ViewController: UITableViewDelegate {
    
}

struct CellInfo: Hashable {
    var text: String
}

enum Section {
    case first
}
