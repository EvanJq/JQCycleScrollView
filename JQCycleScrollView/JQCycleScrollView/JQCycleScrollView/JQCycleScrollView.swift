//
//  JQCycleScrollView.swift
//  JQCycleScrollView
//
//  Created by Evan on 2017/7/4.
//  Copyright © 2017年 ChenJianqiang. All rights reserved.
//

import UIKit

@objc protocol JQCycleScrollViewDelegate: NSObjectProtocol {
    @objc optional func cycleScrollView(_ cycleScrollView: JQCycleScrollView, didSelectItemAt index: Int)

    @objc optional func cycleScrollView(_ cycleScrollView: JQCycleScrollView, didScrollTo index: Int)
}

class JQCycleScrollView: UIView {
    var imageSources = [JQImageSource]() {
        willSet {
            removeTimer()
        }

        didSet {
            self.pageControl.numberOfPages = imageSources.count

            if imageSources.count >= 2 {
                var tempSources = [JQImageSource]()
                tempSources.append(imageSources.last!)
                tempSources.append(contentsOf: imageSources)
                tempSources.append(imageSources.first!)
                imageSources = tempSources
                self.collectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: false)
            } else {
                self.collectionView.reloadData()
            }
            addTimer()
        }
    }

    var currentPage: Int {
        let index = Int((collectionView.contentOffset.x / collectionView.frame.size.width) + 0.5) - 1
        let currentPage = (index + pageCount) % pageCount
        return currentPage

    }

    var pageCount: Int {
        return self.imageSources.count - 2
    }

    var delegate: JQCycleScrollViewDelegate?

    var autoScrolTimeInterval = 1.0
    var autoScrollable = true {
        didSet {
            removeTimer()
            if autoScrollable == true {
                addTimer()
            }
        }
    }

    var showPageControl = true {
        didSet {
            self.pageControl.isHidden = !showPageControl
        }
    }

    var currentPageIndicatorTintColor = UIColor.blue
    var pageIndicatorTintColor = UIColor.lightGray
    fileprivate var pageControl: UIPageControl!

    fileprivate var flowLayout:UICollectionViewFlowLayout!
    fileprivate var collectionView:UICollectionView!
    fileprivate var cellIdentifier = "JQCycleCell"
    fileprivate var timer: Timer?


    override init(frame: CGRect) {
        super.init(frame: frame)

        initialize()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }

    fileprivate func initialize() {
        setupUI()
    }

    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)

        if let _ = newSuperview {
            timer?.invalidate()
            timer = nil
        }
    }

    fileprivate func scrollToNextPage() {
        scrollToPage(currentPage+1)
    }

    fileprivate func scrollToPage(_ page: Int, animated: Bool = true) {
        let scrollPage = (page+1) % imageSources.count

        self.collectionView.scrollToItem(at: IndexPath(row: scrollPage, section: 0), at: .centeredHorizontally, animated: animated)
    }
}

// MARK: - 定时器相关
extension JQCycleScrollView {
    fileprivate func addTimer() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }

        timer = Timer(timeInterval: autoScrolTimeInterval, target: self, selector: #selector(autoScrollAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: .commonModes)
    }

    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
    }

    func autoScrollAction() {
        if self.imageSources.count < 2 {
            removeTimer()
            return
        }

        scrollToNextPage()
    }
}

extension JQCycleScrollView {
    func setupUI() {
        setupCollectionView()
        setupPageControl()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        collectionView.contentInset = .zero

        let pageW = bounds.width
        let pageH: CGFloat = 20
        let pageX = bounds.origin.x
        let pageY = bounds.height -  pageH - 8
        self.pageControl.frame = CGRect(x: pageX, y: pageY, width: pageW, height: pageH)
    }

    fileprivate func setupCollectionView() {
        flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = frame.size
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = .horizontal

        collectionView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        collectionView.register(JQCycleCell.classForCoder(), forCellWithReuseIdentifier: cellIdentifier)
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        addSubview(collectionView)
    }

    func setupPageControl() {
        pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = pageIndicatorTintColor
        pageControl.contentHorizontalAlignment = .center
        pageControl.hidesForSinglePage = true
        self.addSubview(pageControl)
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension JQCycleScrollView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageSources.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! JQCycleCell
        cell.imageSource = imageSources[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cycleScrollView?(self, didSelectItemAt: indexPath.row)
    }
}

extension JQCycleScrollView {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScrollable {
            addTimer()
        }
    }

    // 自动滚动结束会调用
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.delegate?.cycleScrollView?(self, didScrollTo: currentPage)
    }

    // 手动滚动结束会调用
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.delegate?.cycleScrollView?(self, didScrollTo: currentPage)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if pageCount > 0 {
            if scrollView.contentOffset.x == 0 || scrollView.contentOffset.x >= scrollView.frame.size.width * CGFloat(pageCount + 1) {
                self.scrollToPage(currentPage, animated: false)
            }
        }
        self.pageControl.currentPage = currentPage
    }
}
