//
//  UIBarButtonItem_Extension.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/9.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit

extension UIBarButtonItem
{
    class func createItem(imgName:String,size:CGSize) -> UIBarButtonItem
    {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imgName), for: .normal)
        btn.setImage(UIImage.init(named: imgName + "_HL"), for: .highlighted)
        btn.frame = CGRect.init(origin: CGPoint.zero, size: size)
        return UIBarButtonItem.init(customView: btn)
    }
    
    convenience init(imgName:String,size:CGSize = CGSize.zero)
    {
        let btn = UIButton()
        btn.setImage(UIImage.init(named: imgName), for: .normal)
        if UIImage.init(named: imgName + "_HL") != nil {
            btn.setImage(UIImage.init(named: imgName + "_HL"), for: .highlighted)
        }
        if size == CGSize.zero
        {
            btn.sizeToFit()
        }else{
            btn.frame = CGRect.init(origin: CGPoint.zero, size: size)
        }
        self.init(customView: btn)
    }
}
