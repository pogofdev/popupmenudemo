//
//  ViewController.swift
//  popupMenuDemo
//
//  Created by poisongas on 8/6/18.
//  Copyright © 2018 poisongas. All rights reserved.
//

import UIKit

protocol  ZoomProtocol: class{
    func zoomOut()
    func zoomIn(imageView:UIImageView, pressedLocation:CGPoint)
    func handleLongPressGestureChange(gesture: UILongPressGestureRecognizer)
}

class ViewController: UIViewController {
 
    let cellReuseIdentifier = "cellReuseIdentifier"
    let leftAndRightPaddings: CGFloat = 2.0
    let numberOfItemsPerRow: CGFloat = 2.0
    let screenSize: CGRect = UIScreen.main.bounds
    let statusBarHeight = UIApplication.shared.statusBarFrame.height

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = UIColor.white
    }
    
    lazy var mainCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
       let cv = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        
        return cv
    }()
    
    lazy var popupView: UIView = {
       let view = UIView(frame: self.view.frame)
       view.alpha = 0
        view.backgroundColor = UIColor.white
        return view
    }()
    
    lazy var button: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.red
        return view
    }()
    lazy var button1: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.green
        return view
    }()
    lazy var button2: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    func setupViews(){
        // remove navigation controller
        navigationController?.isNavigationBarHidden = true
        registerCells()
        view.addSubview(mainCollectionView)
        
    }
    
    func registerCells(){
        mainCollectionView.register(MyCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as! MyCell
        let imageName = "atm\(indexPath.item + 1)"
        cell.imageView1.image = UIImage(named: imageName)
        cell.delegate = self
        return cell
    }
}

extension ViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = (collectionView.frame.size.width - 5)/numberOfItemsPerRow
        return  CGSize(width: width, height: width)
    }
}

extension ViewController: ZoomProtocol {
    
    func handleLongPressGestureChange(gesture: UILongPressGestureRecognizer){
        let pressedLocation = gesture.location(in: self.button)
        let pressedLocation1 = gesture.location(in: self.button1)
        let pressedLocation2 = gesture.location(in: self.button2)
        print("location change", pressedLocation)
        
        let hitTestView = button.hitTest(pressedLocation, with: nil)
        let hitTestView1 = button1.hitTest(pressedLocation1, with: nil)
        let hitTestView2 = button2.hitTest(pressedLocation2, with: nil)
        
        if hitTestView != nil {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
               hitTestView?.alpha = 0
            }, completion: nil)
            
        }else{
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.button.alpha = 1
            }, completion: nil)
        }
        if hitTestView1 != nil {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                hitTestView1?.alpha = 0
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.button1.alpha = 1
            }, completion: nil)
        }
        if hitTestView2 != nil {
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                hitTestView2?.alpha = 0
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.button2.alpha = 1
            }, completion: nil)
        }
    }
    func zoomOut() {
        print("zoom out:")
      
        // background animation when zoom out
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.popupView.alpha = 0
            self.button.alpha = 0
            self.button1.alpha = 0
            self.button2.alpha = 0
        }, completion: {(completed) in
            self.popupView.removeFromSuperview()
            self.button.removeFromSuperview()
            self.button1.removeFromSuperview()
            self.button2.removeFromSuperview()
        })
    }
    
    
    func zoomIn(imageView: UIImageView, pressedLocation: CGPoint) {
        print("zoom in:", imageView.frame)
        view.addSubview(popupView)
        
        
        
        
        // center the button
        button.frame = CGRect(x: pressedLocation.x - 20/2, y: pressedLocation.y - 20/2, width: 20, height: 20)
        button1.frame = CGRect(x: pressedLocation.x - 20/2, y: pressedLocation.y - 20/2, width: 20, height: 20)
        button2.frame = CGRect(x: pressedLocation.x - 20/2, y: pressedLocation.y - 20/2, width: 20, height: 20)
        view.addSubview(button)
        view.addSubview(button1)
        view.addSubview(button2)
        
        
       

        // handle background effects and animation
        setMask(with: CGRect(x: imageView.frame.minX, y: imageView.frame.minY + 0, width: imageView.frame.width, height: imageView.frame.height), in: popupView)
        // add tranform or alpha
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseOut, animations: {
            self.popupView.alpha = 0.9
        }, completion: {(complete) in
            self.showButtons(touchedPoint: pressedLocation)
        })
    }
    
    // x^2 + y^2 = r^2
    
    // cos(θ) = x / r ==> x = r * cos(θ)
    // sin(θ) = y / r ==> y = r * sin(θ)
    
    // radians = degree * PI / 180
    func getXY(centerOfCircle: CGPoint, radius: Double, touchedPoint: CGPoint)->[CGPoint]{
        
        var x:Double = 0
        var y:Double = 0
        var array:[CGPoint] = []
        var from:Double = 180
        var to:Double = 340
        
        // check if touched point near the sides or corners of the screen
        
        // top left cornor
        if centerOfCircle.x < 50 + 20 && centerOfCircle.y < 50 + 20 {
            var from:Double = 0
            var to:Double = 90
            
            for i in stride(from: from, to: to, by: 30){
                let radians = i * Double.pi / 180
                
                x = radius * cos(radians)
                y = radius * sin(radians)
                array.append(CGPoint(x: x, y: y))
            }
            return array
        }
        
        // left side
        if centerOfCircle.x < 50 + 20 {
            from = 270
            to = 180
            for i in stride(from: from, to: 360, by: 40){
                let radians = i * Double.pi / 180
                
                x = radius * cos(radians)
                y = radius * sin(radians)
                array.append(CGPoint(x: x, y: y))
            }
            for i in stride(from: 0, to: to, by: 40){
                let radians = i * Double.pi / 180
                
                x = radius * cos(radians)
                y = radius * sin(radians)
                array.append(CGPoint(x: x, y: y))
            }
             return array
        }
        // right side
    if centerOfCircle.x + 50 + 20 < screenSize.width {
        var from:Double = 180
        var to:Double = 340
        for i in stride(from: from, to: to, by: 40){
            let radians = i * Double.pi / 180
            
            x = radius * cos(radians)
            y = radius * sin(radians)
            array.append(CGPoint(x: x, y: y))
        }
        return array
    }
        
       
        
        
        for i in stride(from: from, to: to, by: 40){
            let radians = i * Double.pi / 180
            
            x = radius * cos(radians)
            y = radius * sin(radians)
            array.append(CGPoint(x: x, y: y))
        }
       
        return array
    }
    
    func showButtons(touchedPoint: CGPoint) {
        UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
//            self.button.alpha = 0.9
//            self.button1.alpha = 0.9
//            self.button2.alpha = 0.9
        }, completion: {(complete) in
            var newLocation:[CGPoint] = self.getXY(centerOfCircle: CGPoint(x: self.button.frame.minX, y: self.button.frame.minY), radius: 50.0, touchedPoint: touchedPoint)
            var i = 0
            
           
            
//            let newLocation = self.getXY(centerOfCircle: CGPoint(x: self.button.frame.minX, y: self.button.frame.minY), radius: 50.0)
            // move button to circle

           
            UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.button.alpha = 0.9
                self.button1.alpha = 0.9
                self.button2.alpha = 0.9
                 self.button.frame = CGRect(x: self.button.frame.minX + newLocation[0].x, y: self.button.frame.minY + newLocation[0].y, width: 20, height: 20)
                self.button1.frame = CGRect(x: self.button1.frame.minX + newLocation[1].x, y: self.button1.frame.minY + newLocation[1].y, width: 20, height: 20)
                self.button2.frame = CGRect(x: self.button2.frame.minX + newLocation[2].x, y: self.button2.frame.minY + newLocation[2].y, width: 20, height: 20)
            }, completion: nil)
            
//            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
//
//                self.button.frame = CGRect(x: self.button.frame.minX + newLocation.x, y: self.button.frame.minY + newLocation.y, width: 20, height: 20)
//            }, completion: nil)
        })
    }
    
    func setMask(with hole: CGRect, in view: UIView){
        
        // Create a mutable path and add a rectangle that will be h
        let mutablePath = CGMutablePath()
        mutablePath.addRect(view.bounds)
        mutablePath.addRect(hole)
        
        // Create a shape layer and cut out the intersection
        let mask = CAShapeLayer()
        mask.path = mutablePath
        mask.fillRule = kCAFillRuleEvenOdd
        
        // Add the mask to the view
        view.layer.mask = mask
        
    }
    
    
}

