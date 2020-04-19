//
//  NetworkManager+CSVFiles.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-01.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

extension NetworkManager {
    func getCSVFile(completion: @escaping (_ data: String?,_ error: String?, _ httpURLResponse: HTTPURLResponse?) -> ()) {
        csvRouter.request(.Covid19Cases) { data, response, error in
            let _response  = response as? HTTPURLResponse
            
            if error != nil {
                completion(nil, "Please check your network connection.", _response)
            }
            
            if let response = response as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case .success:
                    guard let responseData = data else {
                        completion(nil, NetworkResponse.noData.rawValue, _response)
                        return
                    }
                    print(responseData)
                    let stringData = String(data: responseData, encoding: .utf8)
                    completion(stringData, nil, _response)
                case .failure(let networkFailureError):
                    completion(nil, networkFailureError, _response)
                }
            }
        }
    }
}
