//
//  MainViewController.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-01.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import UIKit
import CSV
import Charts
import MBProgressHUD

class MainViewController: UIViewController, ChartViewDelegate {
    
    @IBOutlet weak var bottomCell: BriefCell!
    @IBOutlet weak var topCell: BriefCell!
    @IBOutlet weak var canadaWrapper: UIView!
    @IBOutlet weak var ontorioWrapper: UIView!
    
    let deliveryManager = DeliveryManager.shared
    
    var topChart = [CSVDecodable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadData()
    }
    
    func loadData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        DeliveryManager.shared.getDataAlternative { (result) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            switch result {
            case .failure(let error):
                print("error:\(error)")
            case .success(let data):
                self.showData(for: data)
            }
        }
    }
    
    func configureUI(){
        bottomCell.setTitle(title: "Ontario", for: .left)
        topCell.setTitle(title: "Canada", for: .left)

    }
    
    func showData(for data: [CSVDecodable]){
        let sortedData = deliveryManager.dataSortedByProvince(with: data)
        
        DispatchQueue.main.async {
            if let topCellData = sortedData[.Canada] {
                let numbersToDrop = topCellData.count - 31
                let bottomCellDataTrimmed = Array(topCellData.dropFirst(numbersToDrop))
                if  let lastTwoRows = bottomCellDataTrimmed.getLastTwo(),
                    let deathrate = self.deliveryManager.getDeathRate(for: lastTwoRows),
                    let doublingTime = self.deliveryManager.getDoublingTime(for: lastTwoRows)
                {
                    var bottomLabelText = ""
                    if let _lastTest =  self.deliveryManager.getLastTested(for: bottomCellDataTrimmed), let lastTest = Int(_lastTest.numberTested) {
                        bottomLabelText = "\(lastTest.formattedWithSeparator) tests have been done as of \(StringFormatter.getDayMonth(from: lastTwoRows[1].date))"
                    }
                    
                    self.topCell.setTitle(title: StringFormatter.getDayMonth(from: lastTwoRows[1].date), for: .right)
                    let _recovered = self.deliveryManager.getLastRecoveredNumber(for: topCellData)
                    let _left = CellInfoStrct(title: "Cases", subTitle: "")
                    let _center = CellInfoStrct(title: "Deaths", subTitle: "")
                    let _right = CellInfoStrct(title: "Recovered", subTitle: "")
                    
                    let briefCellDat = BriefCellStruct(leftCell: _left, centerCell: _center, rightCell: _right, bottomRightTitle: "", bottomLeftTitle: "", bottomLabel: bottomLabelText, deathRate: deathrate, doublingTime: doublingTime, recovered: _recovered, chartData: bottomCellDataTrimmed)
                    self.topCell.setup(data: bottomCellDataTrimmed, cellData: briefCellDat)
                    
                }
            }
            
            if let bottomCellData = sortedData[.Ontario] {
                let numbersToDrop = bottomCellData.count - 31
                let topCellDataTrimmed = Array(bottomCellData.dropFirst(numbersToDrop))
                if  let lastTwoRows = topCellDataTrimmed.getLastTwo(),
                    let deathrate = self.deliveryManager.getDeathRate(for: lastTwoRows),
                    let doublingTime = self.deliveryManager.getDoublingTime(for: lastTwoRows)
                {
                    var bottomLabelText = ""
                    if let _lastTest =  self.deliveryManager.getLastTested(for: topCellDataTrimmed), let lastTest = Int(_lastTest.numberTested) {
                        bottomLabelText = "\(lastTest.formattedWithSeparator) tests have been done as of \(StringFormatter.getDayMonth(from: lastTwoRows[1].date))"
                    }
                    
                    self.bottomCell.setTitle(title: StringFormatter.getDayMonth(from: lastTwoRows[1].date), for: .right)
                    let _recovered = self.deliveryManager.getLastRecoveredNumber(for: topCellDataTrimmed)
                    let _left = CellInfoStrct(title: "Cases", subTitle: "")
                    let _center = CellInfoStrct(title: "Deaths", subTitle: "")
                    let _right = CellInfoStrct(title: "Recovered", subTitle: "")
                    
                    let briefCellDat = BriefCellStruct(leftCell: _left, centerCell: _center, rightCell: _right, bottomRightTitle: "", bottomLeftTitle: "", bottomLabel: bottomLabelText, deathRate: deathrate, doublingTime: doublingTime, recovered: _recovered, chartData: topCellDataTrimmed)
                    self.bottomCell.setup(data: topCellDataTrimmed, cellData: briefCellDat)
                    
                }
            }
            
        }
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        loadData()
    }
    

    // Mark: - Move to extension file
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
