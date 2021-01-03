//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 30/12/2020.
//

import Foundation

class Constants {
    static let instance = Constants()

    private init() {}

    let genesisBlock = Block(timestamp: Date().timeIntervalSince1970, hash: "----", lastHash: "", data: Data(), nonce: 0, difficulty: 3)

    let mineRate: Double = 10000
}
