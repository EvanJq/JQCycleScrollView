//
//  JQCycleCell.swift
//  JQCycleScrollView
//
//  Created by Evan on 2017/7/4.
//  Copyright © 2017年 ChenJianqiang. All rights reserved.
//

import UIKit
import Kingfisher

class JQCycleCell: UICollectionViewCell {

    var imageView: UIImageView!

    var placeholderImage: UIImage?
    var imageSource = JQImageSource() {
        didSet {
            switch imageSource.type {
            case .imageName:
                imageView.image = UIImage(named: imageSource.source)
            case .url:
                imageView.kf.setImage(with: URL(string: imageSource.source), placeholder: placeholderImage)
            }
        }
    }
//=======================================================
// MARK: 构造方法
//=======================================================
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.white
        setupImageView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//=======================================================
// MARK: - 视图创建于布局
//=======================================================
extension JQCycleCell {
    func setupImageView() {
        imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        self.contentView.addSubview(imageView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = self.bounds
    }
}
