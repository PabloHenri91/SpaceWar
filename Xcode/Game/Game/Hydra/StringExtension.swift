//
//  StringExtension.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 3/21/16.
//  Copyright © 2016 Pablo Henrique Bertaco. All rights reserved.
//


extension String {
    
    static let winEmojis = ["😀","😃","😄","😆","😉","🙂","😋","😜","😝"]
    static let loseEmojis = ["😑","😒","😞","😡","☹️","😖","😱","😓","🤕"]
    
    /// Truncates the string to length number of characters and
    /// appends optional trailing string if longer
    func truncate(length: Int, trailing: String? = nil) -> String {
        if self.characters.count > length {
            
            return self.substringToIndex(self.startIndex.advancedBy(length)) + (trailing ?? "")
            
        } else {
            return self
        }
    }
    
    func translation() -> String {
        return NSLocalizedString(self, comment: self)
    }
    
    static func winEmoji() -> String {
        return winEmojis[Int.random(winEmojis.count)]
    }
    
    static func loseEmoji() -> String {
        return loseEmojis[Int.random(loseEmojis.count)]
    }
}
