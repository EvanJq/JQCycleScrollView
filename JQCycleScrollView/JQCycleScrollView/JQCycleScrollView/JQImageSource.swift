//
//  JQImageSource.swift
//  JQCycleScrollView
//
//  Created by Evan on 2017/7/4.
//  Copyright © 2017年 ChenJianqiang. All rights reserved.
//

import UIKit

enum JQSourceType {
    case imageName
    case url
}

struct JQImageSource {
    /// 资源类型
    var type: JQSourceType = .imageName
    var source: String = ""

    init() {
        
    }

    init(type: JQSourceType = .imageName, source: String) {
        self.type = type
        self.source = source
    }
}
