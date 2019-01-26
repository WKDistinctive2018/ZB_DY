//
//  PageTitleView.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/9.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit

protocol PageTitleViewDelegate : class{
    func pageTitleView(titleView:PageTitleView, selectIndex index:Int)
}

// 移动下滑线高度
private let KScrollViewLineH:CGFloat = 2
private let KNolmalColor:(CGFloat,CGFloat,CGFloat) = (0,0,0)
private let KSelectColor:(CGFloat,CGFloat,CGFloat) = (255,165,0)


class PageTitleView: UIView {

    // Mark:定义属性
    // title数组
    private var titles:[String]
    // label数组
    private lazy var labels:[UILabel] = [UILabel]()
    // 当前labelIndex
    private var currentIndex:Int = 0
    // delegate属性
    weak var delegate:PageTitleViewDelegate?
    
    
    private lazy var scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        scrollView.frame = bounds
        return scrollView
    }();
    
    private lazy var scrollViewLine:UIView = {
        let scrollViewLine = UIView()
        scrollViewLine.backgroundColor = UIColor(r: KSelectColor.0, g: KSelectColor.1, b: KSelectColor.2, alpha: 1)
        return scrollViewLine
    }()
    
    init(frame: CGRect,titles:[String]) {
        self.titles = titles
        super.init(frame:frame)
        // 1.设置UI
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageTitleView{
    private func setupUI()
    {
        // 1.添加scrollview
        addSubview(self.scrollView)
        
        // 2.添加title对应的Label
        setupLabels()
        
        // 3.添加底部移动下滑线
        setupScrollViewLine()
    }
    
    private func setupLabels()
    {
        for (index,title) in titles.enumerated() {
            // 1.创建label
            let label = UILabel()
            
            // 2.设置label属性
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = UIColor(r: KNolmalColor.0, g: KNolmalColor.1, b: KNolmalColor.2, alpha: 1)
            label.textAlignment = .center
            
            // 3.设置label位置
            let labelW:CGFloat = KScreenW/CGFloat(titles.count)
            let labelH:CGFloat = bounds.height - KScrollViewLineH
            let labelX:CGFloat = labelW * CGFloat(index)
            let labelY:CGFloat = 0
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            scrollView.addSubview(label)
            labels.append(label)
            
            // 4.添加点击事件
            label.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action:#selector(labelDidClick(tap:)))
            label.addGestureRecognizer(tap)
        }
    }
    
    private func setupScrollViewLine()
    {
        let lineView = UIView()
        
        lineView.backgroundColor = UIColor.gray
        let lineViewW:CGFloat = KScreenW
        let lineViewH:CGFloat = 0.5
        let lineViewX:CGFloat = 0
        let lineViewY:CGFloat = bounds.height - lineViewH
        lineView.frame = CGRect(x: lineViewX, y: lineViewY, width: lineViewW, height: lineViewH)
        scrollView.addSubview(lineView)
        
        guard let firstLabel = labels.first else { return }
        firstLabel.textColor = UIColor(r: KSelectColor.0, g:KSelectColor.1, b: KSelectColor.2, alpha: 1)
        let scrollViewLineW:CGFloat = firstLabel.bounds.size.width
        let scrollViewLineH:CGFloat = KScrollViewLineH
        let scrollViewLineX:CGFloat = firstLabel.bounds.origin.x
        let scrollViewLineY:CGFloat = bounds.height - KScrollViewLineH
        scrollViewLine.frame = CGRect(x: scrollViewLineX, y: scrollViewLineY, width: scrollViewLineW, height: scrollViewLineH)
        addSubview(scrollViewLine)
    }
}

extension PageTitleView
{
    @objc private func labelDidClick(tap:UITapGestureRecognizer)
    {
        // 当前的label和点击的label，被点击的label文字变成橙色，之前的label变灰色
        // 1.获取当前的label
        guard let currentLabel = tap.view as? UILabel else{ return }
        // 2.获取之前的label
        let oldLabel = labels[currentIndex]
        // 3.改变选中的label颜色
        currentLabel.textColor = UIColor(r: KSelectColor.0, g:KSelectColor.1, b: KSelectColor.2, alpha: 1)
        oldLabel.textColor = UIColor(r: KNolmalColor.0, g: KNolmalColor.1, b: KNolmalColor.2, alpha: 1)
        // 4.保存最新的label下标值
        currentIndex = currentLabel.tag
        
        // 5.滑动条
        let scrollViewLineX = currentLabel.bounds.size.width * CGFloat(currentIndex)
        UIView.animate(withDuration: 0.2) {
            self.scrollViewLine.frame.origin.x = scrollViewLineX
        }
        
        // 6.代理方法
        delegate?.pageTitleView(titleView: self, selectIndex: currentIndex)
    }
}

// MARK: - 提供对外接口
extension PageTitleView
{
    func PageTitleViewCurrentView(progress:CGFloat,OldIndex oldIndex:Int,TargetIndex targetIndex:Int)
    {
        // 1.获取对应label
        let oldLabel = labels[oldIndex]
        let currentLabel = labels[targetIndex]
        // 2.保存最新的label下标值
        currentIndex = targetIndex
        // 3.更新滑动条
        let moveTotalX = currentLabel.frame.origin.x - oldLabel.frame.origin.x
        let moveX = moveTotalX * progress
        let labelW = currentLabel.bounds.width
        if progress < 1 {
            if oldIndex < targetIndex{
                scrollViewLine.frame.size = CGSize(width: labelW + (labelW * progress), height: KScrollViewLineH)
            }else{
                scrollViewLine.frame = CGRect(x: oldLabel.frame.origin.x - (labelW * progress), y: bounds.height - KScrollViewLineH, width: labelW + (labelW * progress), height: KScrollViewLineH)
            }
        }else{
            scrollViewLine.frame.size = CGSize(width: labelW, height: KScrollViewLineH)
            scrollViewLine.frame.origin.x = oldLabel.frame.origin.x + moveX
        }
        // 4.标题颜色渐变
        // 4.1 取出变化的范围
        let colorDelte = (KSelectColor.0 - KNolmalColor.0,KSelectColor.1 - KNolmalColor.1,KSelectColor.2 - KNolmalColor.2)
        oldLabel.textColor = UIColor(r: KSelectColor.0 - colorDelte.0*progress, g: KSelectColor.1 - colorDelte.1*progress, b: KSelectColor.2 - colorDelte.2*progress, alpha: 1)
        currentLabel.textColor = UIColor(r: KNolmalColor.0 + colorDelte.0*progress, g: KNolmalColor.1 + colorDelte.1*progress, b: KNolmalColor.2 + colorDelte.2*progress, alpha: 1)
    }
}






