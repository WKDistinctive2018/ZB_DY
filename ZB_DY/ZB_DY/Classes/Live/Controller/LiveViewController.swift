//
//  LiveViewController.swift
//  ZB_DY
//
//  Created by 王凯 on 2019/1/3.
//  Copyright © 2019年 王凯. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices

private let KTitleViewH:CGFloat = 40

class LiveViewController: UIViewController {
    // 数据源
    private var childVcTitleArr:[String]?
    // MARK: - 懒加载 pageTitleView
    private lazy var pageTitleView:PageTitleView = { [weak self] in
        let titleViewFrame = CGRect(x: 0, y: KNavigationVarH+KStatusBarH, width: KScreenW, height: KTitleViewH)
        let titles = ["推荐","游戏","LOL比赛","趣玩","吃鸡大乱斗",]
        childVcTitleArr = titles
        let titleView = PageTitleView.init(frame: titleViewFrame, titles: titles)
        titleView.delegate = self
        return titleView
    }()
    
    // MARK: - 懒加载 pageContentView
    private lazy var pageContentView:PageContentView = { [weak self] in
        let contentH = KScreenH - (KStatusBarH+KNavigationVarH+KTitleViewH+KTabBarH)
        let contentFrame = CGRect(x: 0, y: KStatusBarH+KNavigationVarH+KTitleViewH, width: KScreenW, height: contentH)
        var childVcs = [UIViewController]()
        let recommendVc = RecommendViewController()
        childVcs.append(recommendVc)
        for _ in 0..<(childVcTitleArr!.count - 1){
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)), alpha: 1.0)
            childVcs.append(vc)
        }
        let pageContentView = PageContentView(frame: contentFrame, childVcs: childVcs, parentVc: self!)
        pageContentView.delegate = self
        pageContentView.backgroundColor = UIColor.purple
        return pageContentView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
        
        // 设置UI界面
        setupUI()
    }



}

extension LiveViewController
{
    private func setupUI()
    {
        // 1.设置导航栏
        setupNavigationBar()
        
        // 2.添加titleView
        view.addSubview(pageTitleView)
        
        // 3.添加内容视图
        view.addSubview(pageContentView)
        
        
    }
    
    private func setupNavigationBar()
    {
        // 设置leftBar动图
        let image = UIImage.animatedImageNamed("image_default_eye", duration: 1)
        
        let btn = UIButton()
        btn.setImage(image, for:.normal)
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: btn)
        
        // 设置rightBar
        let size = CGSize.init(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imgName: "cm_nav_history_white", size: size)
        let searchItem = UIBarButtonItem.createItem(imgName: "cm_nav_history_white", size:size)
        let qrcodeItem = UIBarButtonItem.createItem(imgName: "cm_nav_history_white", size:size)
        navigationItem.rightBarButtonItems = [historyItem,searchItem,qrcodeItem]
    }
    
    private func composeGif()
    {
        // 1.获取图片组
        var images = [UIImage]()
        for i in 1 ..< 10{
            let imageName = String.init(format: "image_default_eye%d", arguments: [i])
//            let imageName = "image_default_eye\(i)"
            
            let image = UIImage.init(named:imageName)
            images.append(image!)
        }
        
        // 2.构建在Document目录下的Gif文件
        let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = docs[0] as String
        let gifPath = documentsDirectory+"/image_default_eye.gif"
        print("gifPath == \(gifPath)")
        
        let url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, gifPath as CFString, CFURLPathStyle.cfurlposixPathStyle, false)
        
        let destion = CGImageDestinationCreateWithURL(url!,kUTTypeGIF, images.count, nil)
        
        // 3.使用ImageIO框架把多帧PNG图片编码到GIF图片中
        // 设置每帧之间播放时间
        let cgImagePropertiesDic = [kCGImagePropertyGIFDelayTime as String:0.1]
        let cgImagePropertiesDestDic = [kCGImagePropertyGIFDictionary as String:cgImagePropertiesDic]
        
        for cgImage in images {
            // 依次为gif图片对象添加每一帧元素
            CGImageDestinationAddImage(destion!, cgImage.cgImage!, cgImagePropertiesDestDic as CFDictionary?)
        }
        
        let gifPropertiesDic:NSMutableDictionary = NSMutableDictionary()
        gifPropertiesDic.setValue(kCGImagePropertyColorModelRGB, forKey: kCGImagePropertyColorModel as String)
        gifPropertiesDic.setValue(16, forKey:kCGImagePropertyDepth as String)// 设置图像的颜色深度
        gifPropertiesDic.setValue(0, forKey:kCGImagePropertyGIFLoopCount as String)// 设置Gif执行次数, 0则为无限执行
        gifPropertiesDic.setValue(NSNumber.init(booleanLiteral: true), forKey: kCGImagePropertyGIFHasGlobalColorMap as String)
        let gifDictionaryDestDic = [kCGImagePropertyGIFDictionary as String: gifPropertiesDic]
        CGImageDestinationSetProperties(destion!, gifDictionaryDestDic as CFDictionary?)//为gif图像设置属性
        
        CGImageDestinationFinalize(destion!)// 最后释放 目标对象 destion
        //生成GIF图片成功
    }
    
    // MARK: - ImageIO
    private func showGif(gifPath:String) ->([UIImage], TimeInterval)? {
        let data = try? Data.init(contentsOf: URL.init(fileURLWithPath: gifPath))
        let source = CGImageSourceCreateWithData(data! as CFData, nil)
        let count = CGImageSourceGetCount(source!)
        let options: NSDictionary = [kCGImageSourceShouldCache as String: true, kCGImageSourceTypeIdentifierHint as String: kUTTypeGIF]
        var gifDuration = 0.0
        var images = [UIImage]()
        
        func frameDuration(from gifInfo: NSDictionary) -> Double {
            let gifDefaultFrameDuration = 0.100
            let unclampedDelayTime = gifInfo[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
            let delayTime = gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber
            let duration = unclampedDelayTime ?? delayTime
            guard let frameDuration = duration else { return gifDefaultFrameDuration }
            
            return frameDuration.doubleValue > 0.011 ? frameDuration.doubleValue : gifDefaultFrameDuration
        }
        for i in 0 ..< count {
            guard let imageRef = CGImageSourceCreateImageAtIndex(source!, i, options) else {
                return nil
            }
            if count == 1 {
                //只有一张图片时
                gifDuration = Double.infinity//无穷大
            }else {
                // Animated GIF
                guard let properties = CGImageSourceCopyPropertiesAtIndex(source!, i, nil), let gifinfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary  else {
                    return nil
                }
                gifDuration += frameDuration(from: gifinfo)
            }
            images.append(UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up))
        }
        return (images, gifDuration)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}

extension LiveViewController:PageTitleViewDelegate
{
    func pageTitleView(titleView: PageTitleView, selectIndex index: Int) {
        pageContentView.pageContentViewCurrentView(index: index)
    }
}

extension LiveViewController:PageContentViewDelegate
{
    func PageContentViewChange(contentView: PageContentView, Progress progress: CGFloat, CurrentIndex currentIndex: Int, TargetIndex targetIndex: Int) {
        pageTitleView.PageTitleViewCurrentView(progress: progress, OldIndex: currentIndex, TargetIndex: targetIndex)
    }
    
    
}










