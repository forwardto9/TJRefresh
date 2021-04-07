//
//  UIViewExtension.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 LEE. All rights reserved.
//  Update by uweiyuan on 2021/04/07
//

#if canImport(UIKit)
import UIKit
#endif

extension UIView {
    var tj_x: CGFloat {
        set(newX) {
            var frame = self.frame
            frame.origin.x = newX
            self.frame = frame
        }
        get {
            return self.frame.origin.x
        }
    }
    var tj_y: CGFloat {
        set(newY) {
            var frame = self.frame
            frame.origin.y = newY
            self.frame = frame
        }
        get {
            return self.frame.origin.y
        }
    }
    var tj_width: CGFloat {
        set(newWidth) {
            var frame = self.frame
            frame.size.width = newWidth
            self.frame = frame
        }
        get {
            return self.frame.size.width
        }
    }
    var tj_height: CGFloat {
        set(newHeight) {
            var frame = self.frame
            frame.size.height = newHeight
            self.frame = frame
        }
        get {
            return self.frame.size.height
        }
    }
    var tj_size: CGSize {
        set(newSize) {
            var frame = self.frame
            frame.size = newSize
            self.frame = frame
        }
        get {
            return self.frame.size
        }
    }
    var tj_origin: CGPoint {
        set(newOrigin) {
            var frame = self.frame
            frame.origin = newOrigin
            self.frame = frame
        }
        get {
            return self.frame.origin
        }
    }
}
