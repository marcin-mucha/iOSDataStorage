//
//  ViewController.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 25/10/16.
//  Copyright © 2016 Marcin Mucha. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    let apiClient = APIClient()
    var repository: ContentRepository?
    
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    //var managedObjectContext: NSManagedObjectContext!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func configureDataSource(repository: ContentRepository) {
        self.repository = repository
    }
    
    
    
    @IBAction func valueDidChange(_ sender: Any) {
        let slider = sender as! UISlider
        numberLabel.text = String(slider.value)
    }
    
    @IBAction func generate(_ sender: Any) {
        apiClient.getContent(for: "a", limit: 10) {
            contents, error in
            if error != nil {
                print(error)
                return
            }
            guard let contents = contents else {
                print("Content from API is nil")
                return
            }
            print("*** Pobrano dane z API ***")
            DispatchQueue.main.async {
                self.repository?.save(contents: contents)
            }
        }

    }
    


}

