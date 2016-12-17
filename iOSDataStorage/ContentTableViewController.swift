//
//  ContentTableViewController.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 21/11/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import Foundation
import UIKit

class ContentTableViewController: UIViewController {
    
    var repository: ContentRepository?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetched = repository?.contents
        tableView.reloadData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let cellNib = UINib(nibName: "ContentTableViewCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "ContentCell")
    }

}

extension ContentTableViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
}

extension ContentTableViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let repository = repository {
            print("\(repository.contents.count) rekordów.")
            return repository.contents.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContentCell", for: indexPath) as! ContentTableViewCell
        guard let content = repository?.contents[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configure(with: content)
        return cell
    }
}
