//
//  String.swift
//  How Long Left (macOS)
//
//  Created by Ryan Kontos on 12/7/19.
//  Copyright © 2020 Ryan Kontos. All rights reserved.
//

import Foundation
import CommonCrypto
import CryptoKit

extension String {
    
    func contains(text: String) -> Bool {
        if self.range(of:text) != nil {
            return true
        } else {
            return false
        }
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    
    func containsAnyOfThese(Strings: [String]) -> Bool {
        
        var r = false
        
        for text in Strings {
            
            if self.range(of:text) != nil {
                r = true
            }
        }
        
        return r
        
    }
    
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    
    enum TruncationPosition {
        case head
        case middle
        case tail
    }
    
    func truncated(limit: Int, position: TruncationPosition = .middle, leader: String = "...") -> String {
        
        var returnString = self
        
        if limit == 0 {
            return self
        }
        
      
       
        guard self.count > limit else { return self }
        
        
        switch position {
        case .head:
            return leader + self.suffix(limit)
        case .middle:
            let headCharactersCount = Int(ceil(Float(limit - leader.count) / 2.0))
            
            let tailCharactersCount = Int(floor(Float(limit - leader.count) / 2.0))
            
            if tailCharactersCount < 0 {
                return self
            }
            
            returnString = "\(self.prefix(headCharactersCount))\(leader)\(self.suffix(tailCharactersCount))"
        case .tail:
            returnString = self.prefix(limit) + leader
        }
        
        returnString = returnString.replacingOccurrences(of: " \(leader)", with: leader)
        returnString = returnString.replacingOccurrences(of: "\(leader) ", with: leader)
        
        return returnString
        
    }
    
    var hashed: String {
        let data = Data(self.utf8)
        let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
            CC_SHA256(bytes.baseAddress, CC_LONG(data.count), &hash)
            return hash
        }
        return hash.map { String(format: "%02x", $0) }.joined()
    }
    

    var MD5ifPossible: String {
        
        #if os(macOS)
        if #available(macOS 10.15, *) { } else {
            return self
        }
        #else
        
        let computed = Insecure.MD5.hash(data: self.data(using: .utf8)!)
        return computed.map { String(format: "%02hhx", $0) }.joined()
        
        #endif
        
            return self
    }
    
}

