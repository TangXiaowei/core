//
//  SimpleAlert.swift
//  core
//
//  Created by Li Shi Wei on 9/27/16.
//  Copyright © 2016 li. All rights reserved.
//

import Foundation

public class Message
{
    public class func alert(title: String, message:String) -> UIAlertController
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "确定", style: .default,
                                     handler: {
                                        action in
                                        print("点击了确定")
        })
        
        alert.addAction(okAction)

        return alert
    }
}
