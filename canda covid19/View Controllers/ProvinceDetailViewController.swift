//
//  ProvinceDetailViewController.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-15.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import UIKit

class ProvinceDetailViewController: UIViewController {
    
    enum TimePeriod: Int {
        case all
        case thirtyDays
        case fourteenDays
    }
    
    @IBOutlet weak var topCell: BriefCell!
    
    var provinceData: [CSVDecodable]?
    private var _provinceData = [CSVDecodable]()
    
    private let deliveryManager = DeliveryManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    func loadData() {
        if let cellData = self.provinceData {
            _provinceData = cellData
            setup(cellData: cellData)
        }
    }
    
    func setup(cellData: [CSVDecodable]) {
        if let firstRow = cellData.first {
            topCell.setTitle(title: firstRow.provinceName, for: .left)
        }
        
        let lastTwoRows = cellData.getLastTwo()!
        print(self.deliveryManager.getDeathRate(for: lastTwoRows))
        print(self.deliveryManager.getDoublingTime(for: lastTwoRows))
        
        if  let lastTwoRows = cellData.getLastTwo(),
            let deathrate = self.deliveryManager.getDeathRate(for: lastTwoRows)
        {
            let doublingTime = self.deliveryManager.getDoublingTime(for: lastTwoRows)
            var bottomLabelText = ""
            if let _lastTest =  self.deliveryManager.getLastTested(for: cellData), let lastTest = Int(_lastTest.numberTested) {
                bottomLabelText = "\(lastTest.formattedWithSeparator) tests have been done as of \(StringFormatter.getDayMonth(from: lastTwoRows[1].date))"
            }
            
            self.topCell.setTitle(title: StringFormatter.getDayMonth(from: lastTwoRows[1].date), for: .right)
            let _recovered = self.deliveryManager.getLastRecoveredNumber(for: cellData)
            let _left = CellInfoStrct(title: "Cases", subTitle: "")
            let _center = CellInfoStrct(title: "Deaths", subTitle: "")
            let _right = CellInfoStrct(title: "Recovered", subTitle: "")
            
            let briefCellDat = BriefCellStruct(leftCell: _left, centerCell: _center, rightCell: _right, bottomRightTitle: "", bottomLeftTitle: "", bottomLabel: bottomLabelText, deathRate: deathrate, doublingTime: doublingTime, recovered: _recovered, chartData: cellData)
            self.topCell.setup(data: cellData, cellData: briefCellDat, showMinimal: false)
            
        }
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func timePeriodChange(_ sender: UISegmentedControl) {
        let timePeriod = TimePeriod(rawValue: sender.selectedSegmentIndex)
        guard self.provinceData != nil else { return }
        guard !self._provinceData.isEmpty else { return }
        
        switch timePeriod {
        case .all:
            setup(cellData: provinceData!)
        case .thirtyDays:
            _provinceData = provinceData!.getLast(number: 30)
        case .fourteenDays:
            _provinceData = provinceData!.getLast(number: 14)
        case .none:
            break
        }
        print(_provinceData.count)
        setup(cellData: _provinceData)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
