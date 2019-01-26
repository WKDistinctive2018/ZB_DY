//
//  PageContentView.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/10.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate:class {
    func PageContentViewChange(contentView:PageContentView, Progress progress:CGFloat,CurrentIndex currentIndex:Int,TargetIndex targetIndex:Int)
}

private let collectionCellID = "ID"

class PageContentView: UIView
{
    // MARK: - 定义属性
    private var childVcs:[UIViewController]
    private weak var parentVc:UIViewController?
    private var startOffsetX:CGFloat = 0
    weak var delegate:PageContentViewDelegate?
    // 用来记录滑动切换cell还是点击切换cell
    private var isForbidScrollDelegate:Bool = false
    
    private lazy var collectionView:UICollectionView = { [weak self] in
        // 1.创建cell的layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        // 2.创建collectionView
        let collectionView = UICollectionView(frame:.zero,collectionViewLayout:layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: collectionCellID)
        
        return collectionView
    }()
    
    init(frame: CGRect,childVcs:[UIViewController],parentVc:UIViewController)
    {
        self.childVcs = childVcs
        self.parentVc = parentVc
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - 设置UI界面
extension PageContentView
{
    private func setupUI()
    {
        // 1.将所有的子控制器添加到父控制器中
        for childVc in childVcs {
            parentVc?.addChildViewController(childVc)
        }
        
        // 2.将collectionView添加到对应的cell中
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

// MARK: - 遵守UICollectionViewDataSource
extension PageContentView:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellID, for: indexPath)
        
        for vc in cell.contentView.subviews {
            vc.removeFromSuperview()
        }
        
        let childVc = childVcs[indexPath.item]
        childVc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(childVc.view)
        return cell
    }
}

// MARK: - 遵守UICollectionViewDelegate
extension PageContentView:UICollectionViewDelegate
{
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScrollDelegate = false
        startOffsetX =  scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isForbidScrollDelegate {return}
        // progress sourceIndex targetIndex
        
        // 1.定义需要的变量
        // 进度
        var progress:CGFloat = 0
        // 当前source
        var currentIndex:Int = 0
        // 目标source
        var targetIndex:Int = 0
        // 当前偏移量
        let currentOffsetX = scrollView.contentOffset.x
        
        // 2.判断左滑还是右滑
        if currentOffsetX > startOffsetX {
            //往左滑
            progress = currentOffsetX / collectionView.bounds.size.width - floor(currentOffsetX / collectionView.bounds.size.width)
            currentIndex = Int(currentOffsetX / collectionView.bounds.size.width)
            targetIndex = currentIndex + 1
            if targetIndex >= childVcs.count{
                targetIndex = childVcs.count - 1
            }
            
        }else{
            //往右滑
            progress = 1 - (currentOffsetX / collectionView.bounds.size.width - floor(currentOffsetX / collectionView.bounds.size.width))
            targetIndex = Int(currentOffsetX / collectionView.bounds.size.width)
            currentIndex = targetIndex + 1
            if currentIndex >= childVcs.count{
                currentIndex = childVcs.count - 1
            }
        }
        // 3.滑动结束
        if currentOffsetX - startOffsetX == scrollView.bounds.width
        {
            progress = 1
            targetIndex = currentIndex
        }
        print("progress:\(progress) currentIndex:\(currentIndex) targetIndex:\(targetIndex)")
        delegate?.PageContentViewChange(contentView: self, Progress: progress, CurrentIndex: currentIndex, TargetIndex: targetIndex)
    }
}


// MARK: - 对外提供接口
extension PageContentView
{
    func pageContentViewCurrentView(index:Int) {
        isForbidScrollDelegate = true
        let offx = collectionView.bounds.size.width * CGFloat(index)
        collectionView.setContentOffset(CGPoint.init(x: offx, y: 0), animated: false)
    }
}







