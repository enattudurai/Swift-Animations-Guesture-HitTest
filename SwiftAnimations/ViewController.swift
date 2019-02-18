//
//  ViewController.swift
//  SwiftAnimations
//
//  Created by Naattudurai Eswaramurthy on 15/02/19.
//  Copyright © 2019 Naattudurai Eswaramurthy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let backgrdImageView : UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "fbImage"))
        
        return imageView
    }()
    
    let containerView : UIView = {
        let imagesContainerView  = UIView()
        imagesContainerView.backgroundColor = .white
        
        let padding : CGFloat = 6
        let viewHeight : CGFloat = 36
        
        let images = [#imageLiteral(resourceName: "sad"),#imageLiteral(resourceName: "cool"),#imageLiteral(resourceName: "happy"),#imageLiteral(resourceName: "orange"), #imageLiteral(resourceName: "cry")]
        
        let arragedSubviews = images.map({ (image) -> UIView in
            
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = viewHeight / 2
            imageView.isUserInteractionEnabled = true
            return imageView
        })
        
        let stackView = UIStackView(arrangedSubviews: arragedSubviews)
        stackView.distribution = .fillEqually

        let numberOfViews = CGFloat(arragedSubviews.count)
        
        let viewWidth : CGFloat = numberOfViews * viewHeight + (numberOfViews + 1) * padding
        
        
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.spacing = padding
        stackView.isLayoutMarginsRelativeArrangement = true
        
        imagesContainerView.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight + 2 * padding)
        imagesContainerView.layer.cornerRadius = imagesContainerView.frame.height / 2
        imagesContainerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        imagesContainerView.layer.shadowRadius = 8
        imagesContainerView.layer.shadowOpacity = 0.5
        imagesContainerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        imagesContainerView.addSubview(stackView)
        stackView.frame = imagesContainerView.frame
        
        return imagesContainerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.view.addSubview(backgrdImageView)
        backgrdImageView.frame = view.frame
        //backgrdImageView.contentMode = .scaleAspectFill
        
        addLongPressGesture()
    }
    
    override var prefersStatusBarHidden: Bool { return true}
    
    fileprivate func addLongPressGesture()
    {
        self.view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
        
    }
    
    fileprivate func handleGestureLongPressBegan(_ gesture: UILongPressGestureRecognizer) {
        self.view.addSubview(containerView)
        let pressedPosition = gesture.location(in: self.view)
        let positionX = (self.view.frame.width - self.containerView.frame.width) / 2
        containerView.transform = CGAffineTransform(translationX: positionX, y: pressedPosition.y - self.containerView.frame.height)
        
        //Add Animations
        containerView.alpha = 0
        containerView.transform = CGAffineTransform(translationX: positionX, y: pressedPosition.y)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.containerView.alpha = 1
            self.containerView.transform = CGAffineTransform(translationX: positionX, y: pressedPosition.y - self.containerView.frame.height)
        }, completion: nil)
    }
    
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer)
    {
        
        if (gesture.state == .began)
        {
            handleGestureLongPressBegan(gesture)
            
        }
        else if (gesture.state == .ended)
        {
            handleGesturesLongPressedEnded(gesture: gesture)
            
        }
        else if (gesture.state == .changed)
        {
            handleGesturesLongPressedChanged(gesture: gesture)
        }
        
    }
    
    fileprivate func handleGesturesLongPressedEnded(gesture: UILongPressGestureRecognizer)
    {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let stackView = self.containerView.subviews.first
            stackView?.subviews.forEach({ (imageView) in
                imageView.transform = .identity
            })
            
            self.containerView.transform = self.containerView.transform.translatedBy(x: 0, y: 50)
            self.containerView.alpha = 0
            
        }, completion: { (_) in
            self.containerView.removeFromSuperview()
        })
        
    }
    
    fileprivate func handleGesturesLongPressedChanged(gesture: UILongPressGestureRecognizer)
    {
        let pressedPosition = gesture.location(in: self.containerView)
        let fixedYposition = CGPoint(x: pressedPosition.x, y: self.containerView.frame.height/2)
        
        let hitView = containerView.hitTest(fixedYposition, with: nil)

        if hitView is UIImageView
        {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.containerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitView?.transform = CGAffineTransform.init(translationX: 0, y: -50)
            }, completion: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

