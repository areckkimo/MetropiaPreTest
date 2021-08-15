//
//  InfoWindowView.swift
//  metropiaPreTest
//
//  Created by Eric Chen on 2021/8/15.
//

import UIKit

class InfoWindowView: UIView {
    var margin: CGFloat {
        return 16
    }
    var size: CGSize {
        let screenSize = UIScreen.main.bounds
        let _size = CGSize(width: screenSize.width - margin*2, height: 150)
        return _size
    }
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: 80, height: 80))
        return imageView
    }()
    lazy var titleLabel: UILabel = {
        let lable = UILabel()
        lable.text = "到此一遊"
        lable.font = UIFont.systemFont(ofSize: 22)
        lable.textColor = .darkGray
        lable.sizeToFit()
        return lable
    }()
    lazy var timeLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17)
        lable.textColor = .lightGray
        return lable
    }()
    lazy var addressLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 17)
        lable.textColor = .gray
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    func setupView(){
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowOpacity = 0.3
        layer.shadowRadius = 7
        layer.cornerRadius = 12
        
        let infoWindowSize = size
        backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = CGRect(origin: .zero, size: infoWindowSize)
        blurView.layer.cornerRadius = 12
        blurView.clipsToBounds = true
        addSubview(blurView)
        
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyView = UIVisualEffectView(effect: vibrancyEffect)
        vibrancyView.frame = CGRect(origin: .zero, size: infoWindowSize)
        blurView.contentView.addSubview(vibrancyView)
        
        //avatar view
        addSubview(avatarImageView)
        avatarImageViewSetup()
        
        //title label
        addSubview(titleLabel)
        titleLableSetup()
        
        //time label
        addSubview(timeLable)
        timeLableSetup()
        
        //address label
        addSubview(addressLable)
        addressLableSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func avatarImageViewSetup(){
        avatarImageView.backgroundColor = .systemBlue
        let x = (size.width - avatarImageView.frame.width) / 2
        let y = -avatarImageView.frame.height / 2
        avatarImageView.frame.origin = CGPoint(x: x, y: y)
    }
    
    func titleLableSetup(){
        let x = (size.width - titleLabel.frame.width) / 2
        let y = avatarImageView.frame.maxY + 5
        titleLabel.frame.origin = CGPoint(x: x, y: y)
    }
    
    func timeLableSetup(){
        let x = CGFloat(12)
        let y = titleLabel.frame.maxY + 12
        timeLable.frame.origin = CGPoint(x: x, y: y)
    }
    
    func addressLableSetup(){
        let x = CGFloat(12)
        let y = timeLable.frame.maxY + 24
        addressLable.frame.origin = CGPoint(x: x, y: y)
    }
}
