//
//  JRefreshFooter.swift
//  JRefreshExanple
//
//  Created by Lee on 2018/8/22.
//  Copyright © 2018年 LEE. All rights reserved.
//  Update by uweiyuan on 2021/04/07
//

#if canImport(UIKit)
import UIKit
#endif

open class JRefreshFooter: JRefreshComponent {
    ///忽略多少scrollView的contentInset的bottom
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0
    //MARK: - 创建footer方法
    public class func footerWithRefreshingBlock(_ refreshingBlock: Block) -> JRefreshFooter {
        
        let cmp = self.init()
        cmp.refreshingBlock = refreshingBlock
        return cmp
    }
}

extension JRefreshFooter {
    override open func prepare() {
        super.prepare()
        // 设置自己的高度
        tj_height = JRefreshConst.footerHeight
    }
}
//MARK: - 公共方法
extension JRefreshFooter {
    public func endRefreshingWithNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .NoMoreData
        }
    }
    public func resetNoMoreData() {
        DispatchQueue.main.async {[weak self] in
            self?.state = .Idle
        }
    }
}









