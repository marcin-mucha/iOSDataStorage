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
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var acitivityIndicator: UIActivityIndicatorView!
    
    let serialQueue = DispatchQueue(label: "serial")
    let timer = Timer()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtons()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.storageNotification(notification:)), name: notificationName, object: nil)
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
    
    func configureButtons() {
        [button, deleteButton].forEach({ but in
            but?.layer.borderWidth = 1.0
            but?.layer.cornerRadius = 5.0
            but?.layer.borderColor = UIColor.blue.cgColor
        })
    }
    
    @IBAction func valueDidChange(_ sender: Any) {
        let slider = sender as! UISlider
        slider.value = round(slider.value)
        numberLabel.text = String(Int(slider.value) * 200)
    }
    
    @IBAction func deleteAll(_ sender: Any) {
        self.repository?.deleteAll()
    }
    
    
    @IBAction func generate(_ sender: Any) {
        acitivityIndicator.startAnimating()
        print("** Pobieranie \(slider.value * 200) rekordów rozpoczęte. ***")
        var tempContents = [Content]()
        apiClient.getContent(for: "pinkfloyd", limit: 200) {
            [weak self] contents, error in
            print("*** Pobieranie zakończeone")
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
                safeSelf.repository?.save(contents: tempContents) {
                    DispatchQueue.main.async {
                        self?.acitivityIndicator.stopAnimating()
                        self?.hudMessage()
                    }
                }
            }
        }

    }
    
    func storageNotification(notification: Notification) {
        guard let repository = notification.userInfo?["storage"] as? ContentRepository else {
            return
        }
        self.repository = repository
        
    }
    
    func hudMessage() {
        let hud = HudView.hud(in: (navigationController?.view)!, animated: true)
        hud.text = "Zapisano"
        let delayInSeconds = 0.6
        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
            hud.removeFromSuperview()
        }
    }
    


}

