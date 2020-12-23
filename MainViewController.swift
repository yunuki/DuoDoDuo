//
//  MainViewController.swift
//  DuoDoDuo
//
//  Created by woogie on 2020/12/04.
//  Copyright © 2020 yunuki. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    lazy var searchView: UIView = {
        let v = UIView()
        v.backgroundColor = .systemGray5
        v.layer.cornerRadius = 10
        return v
    }()

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MatchingListCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var logoImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "logo")
        return img
    }()
    
    var isTapped = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(logoImg)
        logoImg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(100)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(128)
        }
        view.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.top.equalTo(logoImg.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-40)
            make.height.equalTo(40)
        }
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(searchView.snp.bottom).offset(50)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        searchView.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapAction(_ tapGestureRecognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3) {
            if self.isTapped {
                self.searchView.snp.updateConstraints { (make) in
                    make.height.equalTo(40)
                }
            } else {
                self.searchView.snp.updateConstraints { (make) in
                    make.height.equalTo(200)
                }
            }
            self.view.layoutIfNeeded()
        }

        isTapped = !isTapped
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 150)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        let actualPosition = scrollView.panGestureRecognizer.translation(in: scrollView.superview)
        if collectionView.numberOfItems(inSection: 0) < 5 {
            return
        }
        UIView.animate(withDuration: 0.3) {
            if actualPosition.y > 0 { //dragging down
                self.logoImg.snp.remakeConstraints { (make) in
                    make.top.equalToSuperview().offset(100)
                    make.centerX.equalToSuperview()
                    make.width.equalTo(200)
                    make.height.equalTo(128)
                }
                self.searchView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.logoImg.snp.bottom).offset(50)
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().offset(-40)
                    make.height.equalTo(self.isTapped ? 200 : 40)
                }
                self.collectionView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.searchView.snp.bottom).offset(50)
                    make.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                }
                self.view.layoutIfNeeded()
            } else if actualPosition.y <= 0{ //dragging up
                self.logoImg.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.width.equalTo(200)
                    make.height.equalTo(128)
                    make.top.equalTo(self.view.snp.top).offset((self.logoImg.frame.size.height+50+self.searchView.frame.size.height) * -1)
                }
                self.searchView.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.width.equalToSuperview().offset(-40)
                    make.height.equalTo(self.isTapped ? 200 : 40)
                    make.bottom.equalTo(self.view.snp.top)
                }
                self.collectionView.snp.remakeConstraints { (make) in
                    make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
                    make.bottom.equalToSuperview()
                    make.left.equalToSuperview().offset(20)
                    make.right.equalToSuperview().offset(-20)
                }
                self.view.layoutIfNeeded()
            }
        }
    }

}

class MatchingListCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .systemGray6
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
