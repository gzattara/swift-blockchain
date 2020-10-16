//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 15/10/2020.
//

import Foundation
import Crypto

struct Block {
    let timestamp: String
    let hash: String
    let lastHash: String
    let data: Data

    // returns the first block for the blockchain
    static func genesis() -> Block {
        return Block(timestamp: String(Date().timeIntervalSince1970), hash: "----", lastHash: "", data: Data())
    }

    static func mine(lastBlock: Block, data: Data) -> Block {
        let timestamp = String(Date().timeIntervalSince1970)
        return Block(timestamp: timestamp, hash: Block.generateHash(timestamp: timestamp, lastHash: lastBlock.hash, data: data), lastHash: lastBlock.hash, data: Data())
    }

    static func generateHash(timestamp: String, lastHash: String, data: Data) -> String {
        let inputData = Data(timestamp.utf8) + Data(lastHash.utf8) + data
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}