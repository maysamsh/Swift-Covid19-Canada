//
//  DeliveryManager.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-02.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation
import CSV

class DeliveryManager {
    static let shared = DeliveryManager()
    private init(){}
    
    private let networkManager = NetworkManager()
    
    func getData(completion: @escaping (Swift.Result<[CSVDecodable], Error>) -> ()) {
        networkManager.getCSVFile { [weak self] (data, error, httpURLResponse) in
            guard let _statusCode = httpURLResponse?.statusCode else {
                completion(.failure(Failure.invalidResponse))
                return
            }
            
            var records = [CSVDecodable]()
            
            if let _data = data {
                do {
                    let reader = try CSVReader(string: _data, hasHeaderRow: true)
                    let decoder = CSVRowDecoder()
                    while reader.next() != nil {
                        let row = try decoder.decode(CSVDecodable.self, from: reader)
                        records.append(row)
                    }
                    completion(.success(records))
                } catch let _error {
                print(_error)
                completion(.failure(Failure.invalidCSVData))
                }
            } else {
                if _statusCode == 404 {
                    self?.getAlternativeAddress { (alternativeResult) in
                        completion(alternativeResult)
                    }
                } else {
                    let _errorMessage = error ?? "Data deleivery service failed."
                    let _error = Failure.customMessage(message: _errorMessage)
                    completion(.failure(_error))
                }
            }
        }
    }
    
    func getDataAlternative(completion: @escaping (Swift.Result<[CSVDecodable], Error>) -> ()) {
        networkManager.getCSVFile { [weak self] (data, error, httpURLResponse) in
            guard let _statusCode = httpURLResponse?.statusCode else {
                completion(.failure(Failure.invalidResponse))
                return
            }
            
            var records = [CSVDecodable]()
            
            if let _data = data {
                do {
                    let reader = try CSVReader(string: _data, hasHeaderRow: true)
                    let decoder = CSVRowDecoder()
                    while reader.next() != nil {
                        let row = try decoder.decode(GCData.self, from: reader)
                        if let _confirmed = Int(row.confirmed), let _deaths = Int(row.deaths), let _total = Int(row.total) {
                            let csvData = CSVDecodable(deaths: _deaths, total: _total, provinceID: row.provinceID, confirmed: _confirmed, today: Int(row.today), probable: Int(row.probable), provinceName: row.provinceName, provinceNameFranch: row.provinceNameFranch, date: row.date, numberTested: row.numberTested, recovered: row.recovered, percentToday: row.percentToday, percentRecovered: row.percentRecovered, rateTested: row.rateTested)
                            records.append(csvData)
                        }
                    }
                    completion(.success(records))
                } catch let _error {
                print(_error)
                completion(.failure(Failure.invalidCSVData))
                }
            } else {
                if _statusCode == 404 {
                    self?.getAlternativeAddress { (alternativeResult) in
                        completion(alternativeResult)
                    }
                } else {
                    let _errorMessage = error ?? "Data deleivery service failed."
                    let _error = Failure.customMessage(message: _errorMessage)
                    completion(.failure(_error))
                }
            }
        }
    }
    
    
    func dataSortedByProvince(with data:[CSVDecodable]) -> [Province: [CSVDecodable]]{
        var sortedData: [Province: [CSVDecodable]] = [:]
        
        for item in data {
            if let _province = Province(rawValue: item.provinceID) {
                if let _ = sortedData[_province] {
                    sortedData[_province]?.append(item)
                } else {
                    sortedData[_province] = []
                }
            }
        }
        
        return sortedData
    }
    
    func getDoublingTime(for data:[CSVDecodable]) -> Int? {
        guard let _lastTwo = data.getLastTwo() else {
            return nil 
        }

        let rate: Double = (Double(_lastTwo[1].confirmed) - Double(_lastTwo[0].confirmed))/Double(_lastTwo[0].confirmed)
        if rate == 0.0 || rate.isNaN {return nil}
        let doublingTime = log(2)/log(1 + rate)
        
        return Int(doublingTime)
    }
    
    func getDeathRate(for data:[CSVDecodable]) -> Double? {
        guard let _last = data.last else {
            return nil
        }
        let rate: Double = (Double(_last.deaths)/Double(_last.confirmed))
        
        return rate
    }
    
    func getLastRecoveredNumber(for data:[CSVDecodable]) -> CSVDecodable? {
        guard data.count > 1 else {return nil}
        for index in stride(from: data.count - 1 , through: 0, by: -1)  {
            if let recovered = data[index].recovered, let _ = Int(recovered) {
                return data[index]
            }
        }
        
        return nil
    }
        
    func getLastTested(for data:[CSVDecodable]) -> CSVDecodable? {
        guard data.count > 1 else {return nil}
        for index in stride(from: data.count - 1 , through: 0, by: -1)  {
            if let recovered = data[index].numberTested, let _ = Int(recovered) {
                return data[index]
            }
        }
        
        return nil
    }
    
    private func getAlternativeAddress(completion: @escaping (Swift.Result<[CSVDecodable], Error>) -> ()) {
        networkManager.getFileContent(from: "https://maysamsh.me/covid19.txt") { [weak self] (data, _, _) in
            if let _data = data {
                self?.networkManager.getFileContent(from: _data) { (csvData, error, httpURLResponse) in
                    guard let _statusCode = httpURLResponse?.statusCode else {
                        completion(.failure(Failure.invalidResponse))
                        return
                    }
                    var records = [CSVDecodable]()
                    if let _csvData = csvData {
                        do {
                            let reader = try CSVReader(string: _csvData, hasHeaderRow: true)
                            let decoder = CSVRowDecoder()
                            while reader.next() != nil {
                                let row = try decoder.decode(CSVDecodable.self, from: reader)
                                records.append(row)
                            }
                            completion(.success(records))
                        } catch let _error {
                            print(_error)
                            completion(.failure(Failure.invalidCSVData))
                        }
                    } else {
                        if _statusCode == 404 {
                            completion(.failure(Failure.invalidDataReponse))
                        } else {
                            let _errorMessage = error ?? "Alternative data deleivery service failed."
                            let _error = Failure.customMessage(message: _errorMessage)
                            completion(.failure(_error))
                        }
                    }
                }
            } else {
                completion(.failure(Failure.invalidDataReponse))
            }
        }
    }
    
    
    func getProvincesName(data: [Province: [CSVDecodable]]) -> [ProvinceUID]{
        var provinces = [ProvinceUID]()
        
        for item in data {
            if let _last = item.value.last {
                let province = ProvinceUID(id: _last.provinceID, englishName: _last.provinceName, franceName: _last.provinceNameFranch, cases: _last.confirmed)
                provinces.append(province)
            }
        }
        
        provinces.sort()
        
        return provinces
    }
}

