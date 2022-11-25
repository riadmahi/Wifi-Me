//
//  Network.swift
//  Wifi&Me
//
//  Created by Riad Mahi on 21/11/2022.
//

import Foundation

enum TypeBox {
    case FTTH
    case ADSL
    case GPRS
}

struct Network {
    let productID: String
    let serialNumber: String
    let macAdresse: String
    let netMode: String
    let uptime: String
    let versionMainfirmware: String
    let versionBootloader: String
    let versionDsldriver: String
    let currentDate: String
    let refclient: String
    let idur: String
    let alimvoltage: String
    let temperature: String
    let typeBox: TypeBox
    let boxImageName: String
    let netInfra: String
}
