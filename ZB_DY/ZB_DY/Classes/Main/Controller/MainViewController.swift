//
//  MainViewController.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/8.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit

class MainViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
}


extension MainViewController
{
    struct itemVc
    {
        let vcName:String
        let title:String
        let imgName:String
    }
    
    private func setupUI()
    {
        let liveItem = itemVc.init(vcName: "LiveViewController", title: "直播", imgName: "tabLive")
        let yuleItem = itemVc.init(vcName: "YuleViewController", title: "娱乐", imgName: "tabYule")
        let followItem = itemVc.init(vcName: "FollowViewController", title: "关注", imgName: "tabFocus")
        let yubaItem = itemVc.init(vcName: "YubaViewController", title: "鱼吧", imgName: "tabYuba")
        let discoveryItem = itemVc.init(vcName: "DiscoveryViewController", title: "发现", imgName: "tabDiscovery")
        let vcs:[itemVc] = [liveItem,yuleItem,followItem,yubaItem,discoveryItem]
        setTabbarItems(vcs: vcs)
    }
    
    private func setTabbarItems(vcs:[itemVc])
    {
        for item in vcs {
            let namespace = Bundle.main.infoDictionary!["CFBundleExecutable"] as! String
            let itemCla:AnyClass? = NSClassFromString(namespace + "." + item.vcName)
            let itemClass = itemCla as! UIViewController.Type
            let itemVc = itemClass.init()
            
            itemVc.title = item.title
            itemVc.tabBarItem.image = UIImage.init(named: item.imgName)?.withRenderingMode(.alwaysOriginal)
            itemVc.tabBarItem.selectedImage = UIImage.init(named: item.imgName + "HL")?.withRenderingMode(.alwaysOriginal)
            let nav = UINavigationController.init(rootViewController: itemVc)
            addChildViewController(nav)
        }
    }
    
}







