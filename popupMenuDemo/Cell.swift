//
//  Cell.swift
//  popupMenuDemo
//
//  Created by poisongas on 8/6/18.
//  Copyright © 2018 poisongas. All rights reserved.
//

import UIKit
import LBTAComponents

class MyCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews(){
        setupLongPressGesture()
        addSubview(imageView1)
        
        imageView1.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    weak var delegate: ZoomProtocol?
    
    let imageView1: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "atm1")
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = UIColor.red
        iv.clipsToBounds = true
        //        iv.anchor(nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        return iv
    }()
    
    func setupLongPressGesture(){
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector( handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer){
        
        if gesture.state == .began {
            print("long press:", Date())
             let pressedLocation = imageView1.superview?.convert(gesture.location(in: self), to: nil)
            
            print(pressedLocation)
            let snapshotImageView = UIImageView(frame: frame)
            let newRect = imageView1.superview?.convert(imageView1.frame, to: nil)
            print("new location", newRect)
            snapshotImageView.frame = newRect!
            snapshotImageView.image = imageView1.image
            delegate?.zoomIn(imageView: snapshotImageView, pressedLocation: pressedLocation!)
            
        }else if gesture.state == .ended {
            print("end long press", Date())
            delegate?.zoomOut()
        }else if gesture.state == .changed {
            delegate?.handleLongPressGestureChange(gesture: gesture)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
