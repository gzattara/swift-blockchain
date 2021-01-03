//
//  File.swift
//  
//
//  Created by Gonzalo Raul Zattara on 15/10/2020.
//

import Foundation
import Crypto

struct Block {
    let timestamp: Double
    let hash: String
    let lastHash: String
    let data: Data
    let nonce: Int
    let difficulty: Int

    // returns the first block for the blockchain
    static func genesis() -> Block {
        return Constants.instance.genesisBlock
    }

    static func mine(lastBlock: Block, data: Data) -> Block {
        var hash: String = ""
        var timestamp: Double = 0.0

        var nonce = lastBlock.nonce
        var hashIsValid = false

        while !hashIsValid {
            timestamp = Date().timeIntervalSince1970
            nonce += 1

            var difficulty = lastBlock.difficulty

//            if lastBlock

            hash = Block.generateHash(timestamp: timestamp, lastHash: lastBlock.hash, data: data, nonce: nonce, difficulty: lastBlock.difficulty)
            let firstIndex = String.Index(utf16Offset: 0, in: hash)
            let lastIndex = String.Index(utf16Offset: lastBlock.difficulty - 1, in: hash)
            if String(hash[firstIndex...lastIndex]) == String.init(repeating: "0", count: lastBlock.difficulty) {
                hashIsValid = true
            }
        }
        return Block(timestamp: timestamp, hash: hash, lastHash: lastBlock.hash, data: data, nonce: nonce, difficulty: lastBlock.difficulty)
    }

    static func generateHash(timestamp: Double, lastHash: String, data: Data, nonce: Int, difficulty: Int) -> String {
        let timestampData = withUnsafeBytes(of: timestamp) { Data($0) }
        var nonceVar = nonce
        let nonceData = Data(bytes: &nonceVar, count: MemoryLayout.size(ofValue: nonce))
        var difficultyVar = difficulty
        let difficultyData = Data(bytes: &difficultyVar, count: MemoryLayout.size(ofValue: difficulty))

        let inputData = Data(timestampData) + Data(lastHash.utf8) + data + nonceData + difficultyData
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }

    func adjustDifficulty(block: Block, timestamp: Double) -> Int {
        if Date.init(timeIntervalSince1970: TimeInterval(block.timestamp)).timeIntervalSince1970 + TimeInterval(Constants.instance.mineRate) > timestamp {
            return block.difficulty + 1
        } else {
            return block.difficulty - 1
        }
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
