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
    let nonce: String
    let difficulty: Int

    // returns the first block for the blockchain
    static func genesis() -> Block {
        return Block(timestamp: "dumy-timestamp", hash: "----", lastHash: "", data: Data(), nonce: "0", difficulty: 1)
    }

    static func mine(lastBlock: Block, data: Data) -> Block {
        let timestamp = String(Date().timeIntervalSince1970)
        return Block(timestamp: timestamp, hash: Block.generateHash(timestamp: timestamp, lastHash: lastBlock.hash, data: data, nonce: "", difficulty: 1), lastHash: lastBlock.hash, data: data, nonce: "", difficulty: 1)
    }

    static func generateHash(timestamp: String, lastHash: String, data: Data, nonce: String, difficulty: Int) -> String {
//        let String.init(repeating: nonce[nonce.index(after: nonce.startIndex)], count: difficulty)
        let inputData = Data(nonce .utf8) + Data(timestamp.utf8) + Data(lastHash.utf8) + data
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}

extension Block: Equatable {
    static func ==(lhs: Block, rhs: Block) -> Bool {
        if lhs.hash == rhs.hash, lhs.lastHash == rhs.lastHash, lhs.timestamp == rhs.timestamp, lhs.data == rhs.data, lhs.nonce == rhs.nonce, lhs.difficulty == rhs.difficulty {
            return true
        }
        return false
    }
}
