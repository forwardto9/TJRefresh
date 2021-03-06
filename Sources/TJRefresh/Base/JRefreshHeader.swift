//
//  JRefreshHeader.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/20.
//  Copyright © 2018年 LEE. All rights reserved.
//  Update by uweiyuan on 2021/04/07
//

#if canImport(UIKit)
import UIKit
#endif

open class JRefreshHeader: JRefreshComponent {
    
    //MARK: - 创建header方法
    public class func headerWithRefreshingBlock(_ refreshingBlock: Block) -> JRefreshHeader {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
    ///这个key用来存储上一次下拉刷新成功的时间
    var lastUpdatedTimeKey: String?
    ///上一次下拉刷新成功的时间
    var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey ?? "") as? Date
    }
    
    ///忽略多少scrollView的contentInset的top
    public var ignoredScrollViewContentInsetTop: CGFloat = 0 {
        didSet {
            self.tj_y = -self.tj_height - ignoredScrollViewContentInsetTop
        }
    }
    
    var insetTDelta: CGFloat?
    
    override open var state: JRefreshState {
        set(newState) {
            // 状态检查
            let oldState = self.state
            if oldState == newState {
                return
            }
            super.state = newState
            
            // 根据状态做事情
            if newState == .Idle {
                if oldState != .Refreshing {return}
                 // 保存刷新时间
                UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey ?? JRefreshHead.lastUpdateTimeKey)
                UserDefaults.standard.synchronize()
                
                // 恢复inset和offset
                UIView.animate(withDuration: JRefreshConst.slowAnimationDuration, animations: {
                    self.scrollView?.tj_insetTop += self.insetTDelta ?? 0
                    // 自动调整透明度
                    if self.automaticallyChangeAlpha ?? false {
                        self.alpha = 0.0
                    }
                }) { (finished) in
                    self.pullingPercent = 0.0
                    self.endRefreshingCompletionBlock??()
                }
            } else if newState == .Refreshing {
                DispatchQueue.main.async { [weak self] in
                    guard let `self` = self, let scrollViewOriginalInset = self.scrollViewOriginalInset, let scrollView = self.scrollView else {return}
                    UIView.animate(withDuration: JRefreshConst.fastAnimationDuration, animations: {
                        let top = scrollViewOriginalInset.top + self.tj_height
                        // 增加滚动区域top
                        scrollView.tj_insetTop = top
                        // 设置滚动位置
                        var offset = scrollView.contentOffset
                        offset.y = -top
                        scrollView.setContentOffset(offset, animated: false)
                    }, completion: { (finished) in
                        self.executeRefreshingCallback()
                    })
                }
            }
        }
        get {
            return super.state
        }
    }
}

//MARK: - 覆盖父类的方法
extension JRefreshHeader {
    override open func prepare() {
        super.prepare()
        // 设置key
        lastUpdatedTimeKey = JRefreshHead.lastUpdateTimeKey
        // 设置高度
        tj_height = JRefreshConst.headerHeight
    }
    override open func placeSubviews() {
        super.placeSubviews()
        // 设置y值(当自己的高度发生改变了，肯定要重新调整Y值，所以放到placeSubviews方法中设置y值)
        tj_y = -tj_height - ignoredScrollViewContentInsetTop
    }
    
    override open func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let scrollView = scrollView, var scrollViewOriginalInset = scrollViewOriginalInset else {return}
        // 在刷新的refreshing状态
        if state == .Refreshing {
            // 暂时保留
            if window == nil {return}
            // sectionheader停留解决
            var insetT = -scrollView.tj_offsetY > scrollViewOriginalInset.top ? -scrollView.tj_offsetY : scrollViewOriginalInset.top
            insetT = insetT > (tj_height + scrollViewOriginalInset.top) ? tj_height + scrollViewOriginalInset.top : insetT
            scrollView.tj_insetTop = insetT
            insetTDelta = scrollViewOriginalInset.top - insetT
            return
        }
        // 跳转到下一个控制器时，contentInset可能会变
        scrollViewOriginalInset = scrollView.tj_inset
        
         // 当前的contentOffset
        let offsetY = scrollView.tj_offsetY
        // 头部控件刚好出现的offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        
        // 如果是向上滚动到看不见头部控件，直接返回
        if offsetY > happenOffsetY {
            return
        }
        // 普通 和 即将刷新 的临界点
        let normal2pullingOffsetY = happenOffsetY - tj_height
        let pullingPercent = (happenOffsetY - offsetY) / tj_height
        // 如果正在拖拽
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .Idle && offsetY < normal2pullingOffsetY {
                // 转为即将刷新状态
                self.state = .Pulling
            } else if self.state == .Pulling && offsetY >= normal2pullingOffsetY {
                // 转为普通状态
                self.state = .Idle
            }
        } else if self.state == .Pulling { // 即将刷新 && 手松开
            //开始刷新
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}
















