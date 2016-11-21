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
    
    var repository: CoreDataRepository?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("")
        let fetched = repository?.contents
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
