//
//  Host.swift
//  Wifi&Me
//
//  Created by Riad Mahi on 22/11/2022.
//

import Foundation

enum TypeHost {
    case PC
    case MOBILE
}

struct Hosts {
    var hostsList: [Host]
}

struct Host {
    let name: String
    let type: TypeHost
    let isActive: Bool
    let detail: HostDetail
}

struct HostDetail {
    let ip: String
    let iface: String
    let mac: String
}
