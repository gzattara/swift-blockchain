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

        var nonce = 0
        var difficulty = lastBlock.difficulty
        var hashIsValid = false

        while !hashIsValid {
            timestamp = Date().timeIntervalSince1970
            nonce += 1

            difficulty = adjustDifficulty(block: lastBlock, timestamp: timestamp)

            hash = Block.generateHash(timestamp: timestamp, lastHash: lastBlock.hash, data: data, nonce: nonce, difficulty: difficulty)
            let firstIndex = String.Index(utf16Offset: 0, in: hash)
            let lastIndex = String.Index(utf16Offset: difficulty - 1, in: hash)
            if String(hash[firstIndex...lastIndex]) == String.init(repeating: "0", count: difficulty) {
                hashIsValid = true
            }
        }
        return Block(timestamp: timestamp, hash: hash, lastHash: lastBlock.hash, data: data, nonce: nonce, difficulty: difficulty)
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

    static func adjustDifficulty(block: Block, timestamp: Double) -> Int {
        if Date.init(timeIntervalSince1970: TimeInterval(block.timestamp)).timeIntervalSince1970 + TimeInterval(Constants.instance.mineRate) > timestamp {
            return checkDifficultyLowerValue(difficulty: block.difficulty + 1)
        } else {
            return checkDifficultyLowerValue(difficulty: block.difficulty - 1)
        }
    }

    static private func checkDifficultyLowerValue(difficulty: Int) -> Int {
        if difficulty < 1 {
            return 1
        }
        return difficulty
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
