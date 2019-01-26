//
//  CollectionHeaderView.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/25.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    
    private let margin:CGFloat = 10
    
    private lazy var imgView:UIImageView = {
        // 1.图标
        let imgView = UIImageView()
        let imgViewW:CGFloat = 22
        let imgViewH:CGFloat = imgViewW
        let imgViewX:CGFloat = margin
        let imgViewY:CGFloat = (bounds.size.height - imgViewH)/2
        imgView.frame = CGRect(x: imgViewX, y: imgViewY, width: imgViewW, height: imgViewH)
        return imgView
    }()
    
    private lazy var titleLabel:UILabel = {
        // 2.标题
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.black
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        let titleLabelW:CGFloat = 100
        let titleLabelH:CGFloat = 30
        let titleLabelX:CGFloat = 10+22+5
        let titleLabelY:CGFloat = (bounds.size.height - titleLabelH)/2
        titleLabel.frame = CGRect(x: titleLabelX, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        return titleLabel
    }()
    
    private lazy var rightBtn:UIButton = {
        // 3.右边按钮
        let rightBtn = UIButton(type:.custom)
        rightBtn.backgroundColor = UIColor.clear
        rightBtn.titleLabel?.textColor = UIColor.orange
        let rightBtnW:CGFloat = 100
        let rightBtnH:CGFloat = 20
        let rightBtnX:CGFloat = KScreenW - 2*margin - rightBtnW
        let rightBtnY:CGFloat = (bounds.size.height - rightBtnH)/2
        rightBtn.frame = CGRect(x: rightBtnX, y: rightBtnY, width: rightBtnW, height: rightBtnH)
        return rightBtn
    }()
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CollectionHeaderView
{
    func setupUI()
    {

        addSubview(imgView)
        
        
        addSubview(titleLabel)
        
        
        addSubview(rightBtn)

    }
}

extension CollectionHeaderView
{
    func headviewConfig(ImgName imgName:String,Title title:String, BtnImgName btnImgName:String,BtnTitle btnTitle:String) {
        imgView.image = UIImage.init(named: imgName)
        titleLabel.text = title
        rightBtn.isHidden = false
        rightBtn.setImage(UIImage.init(named: btnImgName), for: .normal)
        rightBtn.setTitle(btnTitle, for: .normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        rightBtn.setTitleColor(UIColor.orange, for: .normal)
    }
    
    func headviewConfig(ImgName imgName:String,Title title:String){
        imgView.image = UIImage.init(named: imgName)
        titleLabel.text = title
        rightBtn.isHidden = true
    }
}












