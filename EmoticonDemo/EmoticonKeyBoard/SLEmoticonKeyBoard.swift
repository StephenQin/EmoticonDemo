//
//  SLEmoticonKeyBoard.swift
//  langligelang
//
//  Created by 秦－政 on 2016/11/2.
//  Copyright © 2016年 pete. All rights reserved.
//

import UIKit
/*
 1. 表情视图-> UICollectionView
 2. 页数指示器-> UIPageControl
 3. toolBar -> UIStackView
 
 */
//  重用标记
private let SLEmoticonCollectionViewCellIdentifier = "SLEmoticonCollectionViewCellIdentifier"
class SLEmoticonKeyBoard: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    fileprivate func setupUI(){
        // 设置默认滚动的 indexPath
        let normalIndexPath = IndexPath(item: 0, section: 1)
        // 等待其他视图加载完毕并绑定数据后才会执行操作 主线程异步
        DispatchQueue.main.async {
            self.emoticonCollectionView.scrollToItem(at: normalIndexPath, at: .left, animated: false)
            self.setPageControlData(indexPath: normalIndexPath)
        }
        backgroundColor = UIColor(patternImage: UIImage(named: "emoticon_keyboard_background")!)
        // 添加控件
        addSubview(toolBar)
        addSubview(emoticonCollectionView)
        addSubview(pageControl)
        
        // 设置约束
        toolBar.snp_makeConstraints { (make) in
            make.left.bottom.right.equalTo(self)
            make.height.equalTo(35)
        }
        pageControl.snp_makeConstraints { (make) in
            make.bottom.equalTo(emoticonCollectionView)
            make.centerX.equalTo(emoticonCollectionView)
            make.height.equalTo(10)
        }
        emoticonCollectionView.snp_makeConstraints { (make) in
//            make.top.left.right.equalTo(self)
            make.top.equalTo(self)
            make.trailing.equalTo(self)
            make.leading.equalTo(self)
            make.bottom.equalTo(toolBar.snp_top)
        }
        toolBar.callBack = { [weak self] (type:SLEmoticonToolBarButtonType) in
            
            let indexPath:IndexPath
            switch type {
            case .recent:
                // 滚动到最近表情
                indexPath = IndexPath(item: 0, section: 0)
            case.normal:
                // 滚动到默认表情
                indexPath = IndexPath(item: 0, section: 1)
            case.emoji:
                // 滚动到emoji表情
                indexPath = IndexPath(item: 0, section: 2)
            case.lxh:
                // 滚动到浪小花表情
                indexPath = IndexPath(item: 0, section: 3)
            }
            // 不需要开启动画
            self?.emoticonCollectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            self?.setPageControlData(indexPath: indexPath)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let flowLayout = emoticonCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        // 设置条目大小
        flowLayout.itemSize = emoticonCollectionView.size
        // 设置水平和垂直间距
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
    }
    // 根据相对应的 indexPath，设置UIPageConrol的数据
    fileprivate func setPageControlData(indexPath:IndexPath) {
        // 统计这组表情的个数
        pageControl.numberOfPages = SLEmoticonTools.shareTool.allEmoticonArray[indexPath.section].count
        // 设置当前的选中页
        pageControl.currentPage = indexPath.item
    }
    // 懒加载控件
    // toolBar
    fileprivate lazy var toolBar: SLEmoticonToolBar = SLEmoticonToolBar()
    // 表情视图
    fileprivate lazy var emoticonCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        // 设置滚动方向
        flowLayout.scrollDirection = .horizontal
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = self.backgroundColor
        // 取消弹簧效果
        view.bounces = false
        // 开启分页
        view.isPagingEnabled = true
        // 隐藏滚动指示器
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        // 注册cell
        view.register(SLEmoticonCollectionViewCell.self, forCellWithReuseIdentifier: SLEmoticonCollectionViewCellIdentifier)
        // 设置数据源代理
        view.dataSource = self
        view.delegate = self
        return view
    }()
    // 分页指示器
    fileprivate lazy var pageControl: UIPageControl = {
        let pageCon = UIPageControl()
        // 隐藏单页显示
        pageCon.hidesForSinglePage = true
        // 页数
        pageCon.numberOfPages = 3
        pageCon.currentPageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_selected")!)
        pageCon.pageIndicatorTintColor = UIColor(patternImage: UIImage(named: "compose_keyboard_dot_normal")!)
        return pageCon
    }()
    
    //  加载最近表情这组数据
    func reloadRecentData() {
        
        let indexPath = IndexPath(item: 0, section: 0)
        //  重新刷新加载最近表情这组数据
        emoticonCollectionView.reloadItems(at: [indexPath])
        
    }
}
// MARK: - 数据源和代理方法
extension SLEmoticonKeyBoard: UICollectionViewDataSource,UICollectionViewDelegate{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return SLEmoticonTools.shareTool.allEmoticonArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SLEmoticonTools.shareTool.allEmoticonArray[section].count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SLEmoticonCollectionViewCellIdentifier, for: indexPath) as!SLEmoticonCollectionViewCell
//        cell.backgroundColor = SLRandomColor()
        cell.emoticonArray = SLEmoticonTools.shareTool.allEmoticonArray[indexPath.section][indexPath.row]
        return cell
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 获取collectionView的内容中心点
        let currentCenterX = scrollView.contentOffset.x + emoticonCollectionView.width * 0.5
        let currentCenterY = scrollView.contentOffset.y + emoticonCollectionView.height * 0.5
        // 中心点
        let currentCenter = CGPoint(x: currentCenterX, y: currentCenterY)
        if let indexPath = emoticonCollectionView.indexPathForItem(at: currentCenter) {
            let section = indexPath.section
            // 根据指定的section 让toolbar选中对应的表情数据按键
            toolBar.selectedButtonWithSection(section: section)
            // 分页指示器滚动
            setPageControlData(indexPath: indexPath)
        }
    }
}


















