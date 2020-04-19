//
//  ProvincesTableViewController.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-14.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProvincesTableViewController: UITableViewController {

    private var provinces: [ProvinceUID] = []
    private var allData: [Province: [CSVDecodable]] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let deliveryManager = DeliveryManager.shared
        self.tableView.tableFooterView = UIView()

        MBProgressHUD.showAdded(to: self.view, animated: true)
        deliveryManager.getDataAlternative { (result) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            switch result {
            case .failure(let error):
                print("error:\(error)")
            case .success(let data):
                self.allData = deliveryManager.dataSortedByProvince(with: data)
                self.provinces = deliveryManager.getProvincesName(data: self.allData)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = provinces[indexPath.row].englishName
        let confirmed = provinces[indexPath.row].cases.formattedWithSeparator
        cell.detailTextLabel?.text = "\(confirmed) Cases"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Show Details", sender: indexPath)
    }
    
    @IBAction func sortAZ(_ sender: UIBarButtonItem) {
        self.provinces.sort()
        self.tableView.reloadData()
    }
    
    @IBAction func sort19(_ sender: UIBarButtonItem) {
        self.provinces.sort { $1.cases < $0.cases }
        self.tableView.reloadData()
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Details", let viewController = segue.destination as? ProvinceDetailViewController,
            let indexPath = sender as? IndexPath{
            if let provinceID = Province(rawValue: provinces[indexPath.row].id), let provinceData = allData[provinceID] {
                viewController.provinceData = provinceData
            }
        }
    }
    

}
