//
//  PageCell.swift
//  Audible
//
//  Created by Nour  on 12/8/16.
//  Copyright © 2016 Nour . All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    var ratio = 0.566
    
    var bgColor:UIColor = UIColor.red{
        
        didSet{
        self.backgroundColor = bgColor
        }
    
    }
    
    var page:Page?{
        
        
        didSet{
            guard let page = page else {
                return
            }
            
            
        imageview.image = UIImage(named: "\(page.image)")
        
            
            
           // let color  = UIColor(white: 0.2, alpha: 1)
            
            let attributedtext = NSMutableAttributedString(string: page.title, attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium)
                ,NSForegroundColorAttributeName: UIColor.black])
            
            
            
            attributedtext.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSFontAttributeName:UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName:UIColor.black]))
            
            let paragraph = NSMutableParagraphStyle()
            paragraph.alignment = .center
            
            let length = attributedtext.string.characters.count
            
            attributedtext.addAttributes([NSParagraphStyleAttributeName : paragraph], range: NSRange(location:0,length:length))
            
           textview.attributedText = attributedtext
    
     //   textview.text = page.title + "\n\n" + page.message
            
        }
    
    }
    
    
    
   override init(frame: CGRect) {
        super.init(frame: frame)
        ratio = Double(UIScreen.main.bounds.width / 750)
    
        prepareView()
    }
    
    func injected() {
        prepareView()
        print("I've been injected: \(self)")
    }
    
    let textview:UITextView = {
        
        let tv = UITextView()
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tv.textColor = .black
        tv.backgroundColor = .white
        return tv
        
    }()
    
    let overlay:UIView = {
        let v = UIView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.2)
        return v
    
    }()
    
    let container:UIView = {
    
        let iv = UIView()
      //  iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 0.5
        
        iv.layer.shadowColor = UIColor.black.cgColor
        iv.layer.shadowOpacity = 1
        iv.layer.shadowOffset = CGSize(width: -15, height: 20)
        iv.layer.shadowRadius = 10
        iv.layer.shadowPath = UIBezierPath(rect: iv.bounds).cgPath
        iv.layer.shouldRasterize = true
        return iv
    }()
    
    let lineView:UIView = {
    
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
        
    }()
    
    let imageview:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "page1")
        iv.clipsToBounds = true
        return iv
    }()
    
    
    func   prepareView() {
        addSubview(container)
        container.addSubview(imageview)
       // container.addSubview(overlay)
        container.addSubview(textview)
        container.addSubview(lineView)
        
   
    
       _ = container.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: CGFloat(0 * ratio), leftConstant: CGFloat(0 * ratio), bottomConstant: 0, rightConstant: 0, widthConstant: CGFloat(0 * ratio), heightConstant: CGFloat(0 * ratio))
        
       // overlay.anchorToTop(container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor)
        
        imageview.anchorToTop(container.topAnchor, left: container.leftAnchor, bottom: textview.topAnchor, right: container.rightAnchor)
    
        textview.anchorToTop(nil, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor)
        
        textview.heightAnchor.constraint(equalTo: container.heightAnchor , multiplier: 0.33).isActive = true

       
        lineView.anchorToTop(nil, left: container.leftAnchor, bottom: textview.topAnchor, right: container.rightAnchor)
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
