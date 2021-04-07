//
//  UILabelExtension.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/21.
//  Copyright © 2018年 LEE. All rights reserved.
//  Update by uweiyuan on 2021/04/07
//

#if canImport(UIKit)
import UIKit
#endif

public extension UILabel {
    class func J_lable() -> UILabel {
        let label = self.init()
        label.font = JRefreshLabelFont
        label.textColor = JRefreshLabelTextColor
        label.autoresizingMask = .flexibleWidth
        label.textAlignment = .center
        label.backgroundColor = UIColor.clear
        return label
    }
    
    func textWidth() -> CGFloat {
        var stringWidth: CGFloat = 0.0
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
        //NSAttributedStringKey.font
        #if swift(>=4.0)
        let key = NSAttributedString.Key.font
        #else
        let key = NSFontAttributeName
        #endif
        if text?.count ?? 0 > 0 {
            stringWidth = (text as NSString?)?.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [key : self.font!], context: nil).width ?? 0
        }
        return stringWidth
    }
}
