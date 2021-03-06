//
//  JRefreshAutoFooter.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//  Update by uweiyuan on 2021/04/07
//

#if canImport(UIKit)
import UIKit
#endif

open class JRefreshAutoFooter: JRefreshFooter {
    
    ///是否自动刷新(默认为YES)
    public var automaticallyRefresh: Bool = true
    ///当底部控件出现多少时就自动刷新(默认为1.0，也就是底部控件完全出现时，才会自动刷新)
    public var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    ///是否每一次拖拽只发一次请求
    public var onlyRefreshPerDrag: Bool = false
    /// 一个新的拖拽
    var oneNewPan: Bool = false
    
    override open var state: JRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            // 根据状态做事情
            if newState == .Refreshing {
                executeRefreshingCallback()
            } else if newState == .NoMoreData || state == .Idle {
                if oldState == .Refreshing {
                    self.endRefreshingCompletionBlock??()
                }
            }
        }
        get {
            return super.state
        }
    }
    override open var isHidden: Bool {
        set(newHidden) {
            let lastHidden = isHidden
            super.isHidden = newHidden
            
            if !lastHidden && newHidden {
                state = .Idle
                scrollView?.tj_insetBottom -= tj_height
            } else if lastHidden && !newHidden {
                scrollView?.tj_insetBottom += tj_height
                tj_y = scrollView?.tj_contentH ?? 0
            }
        }
        get {
            return super.isHidden
        }
    }
}

extension JRefreshAutoFooter {
    override open func prepare() {
        super.prepare()
    }
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            if isHidden == false {
                scrollView?.tj_insetBottom += tj_height
            }
            // 设置位置
            tj_y = scrollView?.tj_contentH ?? 0
        } else {// 被移除了
            if isHidden == false {
                scrollView?.tj_insetBottom -= tj_height
            }
        }
    }
    
    override open func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        
        // 设置位置
        tj_y = scrollView?.tj_contentH ?? 0
    }
    override open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
       super.scrollViewContentOffsetDidChange(change)
        if state != .Idle || !automaticallyRefresh || tj_y == 0 {
            return
        }
        guard let scrollView = scrollView else { return }
        if scrollView.tj_insetTop + scrollView.tj_contentH > scrollView.tj_height {// 内容超过一个屏幕
            if scrollView.tj_offsetY >= scrollView.tj_contentH - scrollView.tj_height + tj_height * triggerAutomaticallyRefreshPercent + scrollView.tj_insetBottom - tj_height {
                guard let change = change else {return}
                // 防止手松开时连续调用
                let old = change[NSKeyValueChangeKey.oldKey] as? CGPoint
                let new = change[.newKey] as? CGPoint
                if new?.y ?? 0 <= old?.y ?? 0 {return}
                
                // 当底部刷新控件完全出现时，才刷新
                beginRefreshing()
            }
        }
    }
    override open func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change)

        guard let scrollView = scrollView, state == .Idle else {return}
        let panState = scrollView.panGestureRecognizer.state
        switch panState {
        case .ended:// 手松开
            if scrollView.tj_insetTop + scrollView.tj_contentH <= scrollView.tj_height {// 不够一个屏幕
                if scrollView.tj_offsetY >= scrollView.tj_insetTop {// 向上拽
                    beginRefreshing()
                }
            } else {
                if scrollView.tj_offsetY >= scrollView.tj_contentH + scrollView.tj_insetBottom - scrollView.tj_height {
                    beginRefreshing()
                }
            }
        case .began:
            oneNewPan = true
        default:
            break
        }
    }
    override open func beginRefreshing() {
        if !oneNewPan && onlyRefreshPerDrag {
            return
        }
        super.beginRefreshing()
        oneNewPan = false
    }
}
