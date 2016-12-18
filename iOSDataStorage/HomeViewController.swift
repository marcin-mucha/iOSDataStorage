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
    //var managedObjectContext: NSManagedObjectContext!
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
//    
//    @IBAction func valueChanged(sender: UISlider) {
//        let sliderValue = round(sender.value)
//        sender.setValue(sliderValue, animated: true)
//        delegate?.didChange(Int(sliderValue))
//    }
    
    @IBAction func valueDidChange(_ sender: Any) {
        let slider = sender as! UISlider
        slider.value = round(slider.value)
        numberLabel.text = String(slider.value * 200)
    }
    
    @IBAction func generate(_ sender: Any) {
        print("** Pobieranie \(slider.value * 200) rekordów rozpoczęte. ***")
        var tempContents = [Content]()
        for _ in 1...Int(slider.value) {
            apiClient.getContent(for: "rihanaa", limit: 200) {
                [weak self] contents, error in
                if error != nil {
                    print(error.debugDescription)
                    return
                }
                guard let contents = contents else {
                    print("Content from API is nil")
                    return
                }
                self?.serialQueue.sync {
                    tempContents.append(contentsOf: contents)
                }
            }
        }
        print("*** Zapis rozpoczęty \(tempContents.count) rekordów ***")
        let start = DispatchTime.now()
        DispatchQueue.main.async {
            self.repository?.save(contents: tempContents)
        }
        let end = DispatchTime.now()
        let diff = end.uptimeNanoseconds - start.uptimeNanoseconds
        print("*** Zapis zakończony: \(diff)***")


    }
    


}

