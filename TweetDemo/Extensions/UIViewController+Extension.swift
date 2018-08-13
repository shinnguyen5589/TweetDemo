//
//  UIViewController+Extension.swift
//  TweetDemo
//
//  Created by Dung Nguyen Hoang on 8/13/18.
//  Copyright © 2018 Fossil. All rights reserved.
//

extension UIViewController {
    // Display alert to user
    func displayAlert(title: String?, message: String?, okHandler: (() -> ())? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            okHandler?()
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
