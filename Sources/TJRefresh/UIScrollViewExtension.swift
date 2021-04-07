//
//  UIScrollViewExtension.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 LEE. All rights reserved.
//  Update by uweiyuan on 2021/04/07
//

#if canImport(UIKit)
import UIKit
#endif


extension UIScrollView {

    var tj_inset: UIEdgeInsets {
        get {
            if #available(iOS 11.0, *) {
                return self.adjustedContentInset
            } else {
                return self.contentInset
            }
        }
    }
    
    var tj_insetTop: CGFloat {
        set(newTop) {
            var inset = self.contentInset
            inset.top = newTop
            if #available(iOS 11.0, *) {
                inset.top -= (self.adjustedContentInset.top - self.contentInset.top)
            }
            self.contentInset = inset
        }
        get {
            return tj_inset.top
        }
    }
    
    var tj_insetRight: CGFloat {
        set(newRight) {
            var inset = self.contentInset
            inset.right = newRight
            if #available(iOS 11.0, *) {
                inset.right -= (self.adjustedContentInset.right - self.contentInset.right)
            }
            self.contentInset = inset
        }
        get {
            return tj_inset.right
        }
    }
    
    var tj_insetBottom: CGFloat {
        set(newBottom) {
            var inset = self.contentInset
            inset.bottom = newBottom
            if #available(iOS 11.0, *) {
                inset.bottom -= (self.adjustedContentInset.bottom - self.contentInset.bottom)
            }
            self.contentInset = inset
        }
        get {
            return tj_inset.bottom
        }
    }
    
    var tj_insetLeft: CGFloat {
        set(newLeft) {
            var inset = self.contentInset
            inset.left = newLeft
            if #available(iOS 11.0, *) {
                inset.left -= (self.adjustedContentInset.left - self.contentInset.left)
            }
            self.contentInset = inset
        }
        get {
            return tj_inset.left
        }
    }
    
    var tj_offsetX: CGFloat {
        set(newOffsetX) {
            var offset = self.contentOffset
            offset.x = newOffsetX
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.x
        }
    }
    
    var tj_offsetY: CGFloat {
        set(newOffsetY) {
            var offset = self.contentOffset
            offset.y = newOffsetY
            self.contentOffset = offset
        }
        get {
            return self.contentOffset.y
        }
    }
    
    var tj_contentW: CGFloat {
        set(newContentW) {
            var size = self.contentSize
            size.width = newContentW
            self.contentSize = size
        }
        get {
            return self.contentSize.width
        }
    }
    var tj_contentH: CGFloat {
        set(newContentH) {
            var size = self.contentSize
            size.height = newContentH
            self.contentSize = size
        }
        get {
            return self.contentSize.height
        }
    }
}







