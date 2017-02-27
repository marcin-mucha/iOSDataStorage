//
//  ViewController.swift
//  iOSDataStorage
//
//  Created by Marcin Mucha on 28/01/17.
//  Copyright © 2017 Marcin Mucha. All rights reserved.
//

import UIKit
import Charts
import RealmSwift

class GraphViewController: UIViewController {

    @IBOutlet weak var upperChartView: LineChartView!
    @IBOutlet weak var bottomChartView: LineChartView!
    var persitanceOperations: [PersistanceOperation] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        persitanceOperations = fetchOperationsFromRealm()
        persitanceOperations.sort(by: { $0.recordNumber < $1.recordNumber })
        upperChartView.chartDescription?.text = "Odczyt"
        bottomChartView.chartDescription?.text = "Zapis"
        upperChartView.noDataText = "You need to provide data for the chart."
        upperChartView.xAxis.labelPosition = .bottom
        bottomChartView.xAxis.labelPosition = .bottom
        upperChartView.drawGridBackgroundEnabled = true
        bottomChartView.drawGridBackgroundEnabled = true
        setChart(lineChartView: upperChartView, operationType: .Read)
        setChart(lineChartView: bottomChartView, operationType: .Write)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func done(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    func setChart(lineChartView: LineChartView, operationType: OperationType) {
        let dataSetCD = configureDataSet(operations: persitanceOperations.filter({ $0.storageType == .CoreData && $0.operationType == operationType}), description: "Core Data", color: UIColor.blue)
        let dataSetRealm = configureDataSet(operations: persitanceOperations.filter({ $0.storageType == .Realm && $0.operationType == operationType}), description: "Realm", color: UIColor.red)
        let dataSetCB = configureDataSet(operations: persitanceOperations.filter({ $0.storageType == .Couchbase && $0.operationType == operationType}), description: "Couchbase Lite", color: UIColor.green)
        let dataSets = [dataSetCD, dataSetRealm, dataSetCB].flatMap({ $0 })
        dataSets.forEach { set in
            set.drawValuesEnabled = false
            set.circleRadius = 3.0
            set.circleColors = [UIColor.gray]
        }
        let cartData = LineChartData(dataSets: dataSets)
        lineChartView.data = cartData
    }
    
    func configureDataSet(operations: [PersistanceOperation], description: String, color: UIColor) -> LineChartDataSet? {
        guard operations.count > 0 else {
            return nil
        }
        let dataEntries = operations.map { operation in
            return ChartDataEntry(x: Double(operation.recordNumber), y: Double(operation.duration))
        }
        let dataSet = LineChartDataSet(values: dataEntries, label: description)
        dataSet.colors = [color]
        //dataSet.drawCirclesEnabled = false
        return dataSet
    }
    
    func fetchOperationsFromRealm() -> [PersistanceOperation] {
        let realm = try! Realm()
        return Array(realm.objects(PersistanceOperation.self))
    }

}
