//
//  OperationsViewController.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 26/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import Foundation
import RealmSwift

class OperationsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var operations: [PersistanceOperation] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        operations = loadOperationsFromRealm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        operations = loadOperationsFromRealm()
        tableView.reloadData()
    }
    
    func loadOperationsFromRealm() -> [PersistanceOperation] {
        let realm = try! Realm()
        let ops = Array(realm.objects(PersistanceOperation.self))
        return ops
    }
    
    func configureTableView() {
        let cellNib = UINib(nibName: "OperationsTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "OperationsCell")
    }
}



extension OperationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension OperationsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OperationsCell", for: indexPath) as? OperationsTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(operation: operations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let operation = operations[indexPath.row]
            operations.remove(at: indexPath.row)
            let realm = try! Realm()
            realm.beginWrite()
            realm.delete(operation)
            try! realm.commitWrite()
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
        }
    }
}
