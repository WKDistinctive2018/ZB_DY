//
//  UIColor_RGB.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/10.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit

extension UIColor
{
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, alpha: CGFloat) {
        self.init(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: alpha)
    }
}

