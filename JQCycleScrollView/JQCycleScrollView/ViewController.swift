//
//  ViewController.swift
//  JQCycleScrollView
//
//  Created by Evan on 2017/7/4.
//  Copyright © 2017年 ChenJianqiang. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let cycleScrollView = JQCycleScrollView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 240))
        cycleScrollView.delegate = self
        self.view.addSubview(cycleScrollView)

        let descs = ["韩国防部回应停止部署萨德:遵照最高统帅指导方针",
                     "勒索病毒攻击再次爆发 国内校园网大面积感染",
                     "Win10秋季更新重磅功能：跟安卓与iOS无缝连接",
                     "《琅琊榜2》为何没有胡歌？胡歌：我看过剧本，离开是种保护",
                     "阿米尔汗在印度的影响力，我国的哪位影视明星能与之齐名呢？"]
        let imageSources = [JQImageSource(type: .imageName, source: "localImg6"),
                            JQImageSource(type: .imageName, source: "localImg7"),
                            JQImageSource(type: .imageName, source: "localImg8"),
                            JQImageSource(type: .imageName, source: "localImg9"),
                            JQImageSource(type: .imageName, source: "localImg10")]

        cycleScrollView.imageSources = imageSources
    }
}

extension ViewController: JQCycleScrollViewDelegate {
    func cycleScrollView(_ cycleScrollView: JQCycleScrollView, didSelectItemAt index: Int) {
        print("didSelectItemAt -> \(index)")
    }

    func cycleScrollView(_ cycleScrollView: JQCycleScrollView, didScrollTo index: Int) {
        print("didScrollTo -> \(index)")
    }
}

