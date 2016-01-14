//
//  MentionDetectableTextView.swift
//  MentionInUITextViewDemo
//
//  Created by NIX on 16/1/13.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit

class MentionDetectableTextView: UITextView {

    var tapMentionAction: ((username: String) -> Void)?

    override func didMoveToSuperview() {
        super.didMoveToSuperview()

        self.delegate = self
    }

    override var text: String! {
        didSet {
            let attributedString = NSMutableAttributedString(string: text)

            let textRange = NSMakeRange(0, (text as NSString).length)

            attributedString.addAttribute(NSForegroundColorAttributeName, value: textColor!, range: textRange)
            attributedString.addAttribute(NSFontAttributeName, value: font!, range: textRange)

            // mention

            let mentionPattern = "@[A-Za-z0-9_]+"
            let mentionExpression = try! NSRegularExpression(pattern: mentionPattern, options: NSRegularExpressionOptions())

            mentionExpression.enumerateMatchesInString(text, options: NSMatchingOptions(), range: textRange, usingBlock: { result, flags, stop in

                if let result = result {
                    let subString = (self.text as NSString).substringWithRange(result.range)

                    let attributes: [String: AnyObject] = [
                        NSLinkAttributeName: subString,
                        "CustomDetectionType": "Mention",
                    ]

                    attributedString.addAttributes(attributes, range: result.range )
                }
            })

            self.attributedText = attributedString
        }
    }
}

extension MentionDetectableTextView: UITextViewDelegate {

    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {

        guard let detectionType = self.attributedText.attribute("CustomDetectionType", atIndex: characterRange.location, effectiveRange: nil) as? String where detectionType == "Mention" else {
            return true
        }

        let text = (self.text as NSString).substringWithRange(characterRange)
        let username = text.substringFromIndex(text.startIndex.advancedBy(1))

        if !username.isEmpty {
            tapMentionAction?(username: username)
        }

        return true
    }
}

