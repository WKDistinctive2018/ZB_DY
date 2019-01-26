//
//  RecommendViewController.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/25.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit

private let KCellMargin:CGFloat = 10
private let KNormalCellWidth:CGFloat = (KScreenW - 3*KCellMargin)/2
private let KNormalCellHeight:CGFloat = KNormalCellWidth*2/3
private let KHeadViewWidth:CGFloat = KScreenW
private let KHeadViewHeight:CGFloat = KNormalCellHeight/2

private let KNormalCellID = "KNormalCellID"
private let KHeadViewID = "KheadViewID"


class RecommendViewController: UIViewController {
    
    private lazy var collection:UICollectionView = {[weak self] in
        // 1.创建cell的layout
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: KNormalCellWidth, height: KNormalCellHeight)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = KCellMargin
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(0, KCellMargin, 0, KCellMargin)
        layout.headerReferenceSize = CGSize(width: KHeadViewWidth, height: KHeadViewHeight)
        
        
        // 2.创建cell的View
        let frame = self?.view.bounds
        let collectionView = UICollectionView(frame: frame!, collectionViewLayout: layout)
        collectionView.bounces = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: KNormalCellID)
        collectionView.register(CollectionHeaderView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: KHeadViewID)
        collectionView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        collectionView.backgroundColor = UIColor(r: 243, g: 244, b: 246, alpha: 1)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // 1.设置UI
        setUI()
    }

    private func setUI()
    {
        view.backgroundColor = UIColor(r: 243, g: 244, b: 246, alpha: 1)
        // 1.懒加载collection
        view.addSubview(collection)
    }
    
}

extension RecommendViewController:UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        }else if section == 1{
            return 8
        }else{
            return 4
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KNormalCellID, for: indexPath)
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: KHeadViewID, for: indexPath) as! CollectionHeaderView
        
        if indexPath.section == 0 {
            headView.headviewConfig(ImgName: "recommend_hot", Title: "猜你喜欢", BtnImgName: "btn_cell_accurate", BtnTitle: "点我猜更准")
        }else{
            headView.headviewConfig(ImgName: "recommend_classify", Title: "推荐分类")
        }
        headView.backgroundColor = UIColor.clear
        return headView
    }
    
}















