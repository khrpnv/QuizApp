//
//  String+extension.swift
//  QuizApp
//
//  Created by Илья on 4/16/19.
//  Copyright © 2019 Илья. All rights reserved.
//

import Foundation
import UIKit

extension String {    
    var htmlAttributedStringForQuestion: NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        guard let stringDecoded = try? NSAttributedString(data: Data(utf8), options: options, documentAttributes: nil) else { return nil }
        let resultString = NSAttributedString(string: stringDecoded.string, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25.0)!])
        return resultString
    }
    
    var htmlAttributedStringForAnswer: NSAttributedString? {
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.documentType.rawValue): NSAttributedString.DocumentType.html,
            NSAttributedString.DocumentReadingOptionKey(rawValue: NSAttributedString.DocumentAttributeKey.characterEncoding.rawValue): String.Encoding.utf8.rawValue
        ]
        guard let stringDecoded = try? NSAttributedString(data: Data(utf8), options: options, documentAttributes: nil) else { return nil }
        let resultString = NSAttributedString(string: stringDecoded.string, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 20.0)!])
        return resultString
    }
    
}
