//
//  URLReaderAPI.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-01.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

public enum URLReaderAPI {
    case url(String)
}

struct URLReaderAPIResponse {
    let data: String
}

extension URLReaderAPI: EndPointType {
    var environmentBaseURL : String {
        return ""
    }
    
    var baseURL: URL {
        switch self {
        case .url(let url):
            return URL(string: url)!
        }
    }
    
    var path: String {
        return ""
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        switch self {
        case .url:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}


