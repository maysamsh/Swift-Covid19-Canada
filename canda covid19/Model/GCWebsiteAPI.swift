//
//  CSVFile.swift
//  canda covid19
//
//  Created by Maysam Shahsavari on 2020-04-01.
//  Copyright © 2020 Maysam Shahsavari. All rights reserved.
//

import Foundation

public enum GCWebsiteAPI: String {
    case Covid19Cases = "covid19.csv"
}

enum Province: Int {
    case Ontario = 35
    case BritishColumbia = 59
    case Alberta = 48
    case Saskatchewan = 47
    case Manitoba = 46
    case Quebec = 24
    case NewfoundlandAndLabrador = 10
    case NewBrunswick = 13
    case NovaScotia = 12
    case PrinceEdwardIsland = 11
    case Yukon = 60
    case NorthwestTerritories = 61
    case Nunavut = 62
    case RepatriatedTravellers = 99
    case Canada = 1
}

struct ProvincialData {
    let province: Province
    let data: [CSVDecodable]
}

struct GCWebsiteResponse {
    let data: String
}


struct GCData: Decodable {
    let provinceID: Int
    let provinceName, provinceNameFranch, date: String
    let numberTested, recovered, percentToday, percentRecovered, confirmed, rateTested, probable, deaths, total, today: String?
    
    private enum CodingKeys : String, CodingKey {
        case provinceID = "pruid"
        case confirmed = "numconf"
        case probable = "numprob"
        case deaths = "numdeaths"
        case total = "numtotal"
        case today = "numtoday"
        case recovered = "numrecover"
        case rateTested = "ratetested"
        case percentRecovered = "percentrecover"
        case percentToday = "percentoday"
        case provinceName = "prname"
        case provinceNameFranch = "prnameFR"
        case date = "date"
        case numberTested = "numtested"
    }
}

struct CSVDecodable: Decodable {
    let deaths, total, provinceID, confirmed: Int
    let today, probable: Int?
    let provinceName, provinceNameFranch, date: String
    let numberTested, recovered, percentToday, percentRecovered, rateTested: String?
}

extension GCWebsiteAPI: EndPointType {
    var environmentBaseURL : String {
        switch NetworkManager.environment {
        case .production: return "https://health-infobase.canada.ca/src/data/covidLive/"
        case .qa: return "https://health-infobase.canada.ca/src/data/covidLive/"
        case .staging: return "https://health-infobase.canada.ca/src/data/covidLive/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .Covid19Cases:
            return "\(GCWebsiteAPI.Covid19Cases.rawValue)"
        }
    }
    
    var httpMethod: HTTPMethod {
        .get
    }
    
    var task: HTTPTask {
        switch self {
        case .Covid19Cases:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
}
