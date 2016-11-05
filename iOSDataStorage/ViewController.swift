//
//  ViewController.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 25/10/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let apiClient = APIClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        apiClient.getContent(for: "rihanna", limit: 30) {
            contents, error in
            if error != nil {
                print(error)
                return
            }
            for c in contents! {
                print(c.trackName)
            }
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

