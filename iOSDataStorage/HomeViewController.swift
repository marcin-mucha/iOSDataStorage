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
    @IBOutlet weak var storageNameLabel: UILabel!

    let serialQueue = DispatchQueue(label: "serial")
    let timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        storageNameLabel.text = repository?.dataStorageName ?? ""
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
        slider.value = round(slider.value)
        numberLabel.text = String(Int(slider.value) * 200)
    }
    
    @IBAction func generate(_ sender: Any) {
        print("** Pobieranie \(slider.value * 200) rekordów rozpoczęte. ***")
        var tempContents = [Content]()
        apiClient.getContent(for: "pinkfloyd", limit: 200) {
            [weak self] contents, error in
            guard let safeSelf = self else { return }
            if error != nil {
                print(error.debugDescription)
                return
            }
            guard let contents = contents else {
                print("Content from API is nil")
                return
            }
            for _ in 1...Int(safeSelf.slider.value) {
                tempContents.append(contentsOf: contents)
            }
            DispatchQueue.main.sync {
                safeSelf.repository?.save(contents: tempContents)
            }
            
        }

    }
    


}

