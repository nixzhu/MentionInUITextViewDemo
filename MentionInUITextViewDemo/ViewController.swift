//
//  ViewController.swift
//  MentionInUITextViewDemo
//
//  Created by NIX on 16/1/13.
//  Copyright © 2016年 nixWork. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mentionDetectableTextView: MentionDetectableTextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        mentionDetectableTextView.textColor = UIColor.blackColor()
        mentionDetectableTextView.font = UIFont.systemFontOfSize(18)

        mentionDetectableTextView.text = "@nixzhu Do you like Apple? www.apple.com"

        mentionDetectableTextView.tapMentionAction = { username in
            print("Hello \(username)!")

            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                let alert = UIAlertController(title: "Hello", message: "How are you? \(username)", preferredStyle: .Alert)

                let cancel = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alert.addAction(cancel)

                self?.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
}

