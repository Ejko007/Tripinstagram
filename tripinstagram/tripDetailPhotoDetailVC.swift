//
//  tripDetailPhotoDetailVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

final class tripDetailPhotoDetailVC: UIViewController {
    
    @IBOutlet fileprivate weak var largeImageView: UIImageView!
    @IBOutlet fileprivate weak var largeTextView: UILabel!
    @IBOutlet fileprivate weak var scrollView: UIScrollView!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // size of screen
        // let width = UIScreen.main.bounds.width
        //let width = view.frame.width
        //let height = UIScreen.main.bounds.height
        //let height = view.frame.height

        // allow constraints
        addConstraints4ScrollView()
        addConstraints4LargeImage()
        addConstraints4largeTextView()
        
 

    }
    
    // constraints for large text view
    func addConstraints4largeTextView() {
        let imageSize = largeImageView.frame.size.height
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        largeTextView.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal
            , toItem: largeTextView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 10)
        let leadingConstraint = NSLayoutConstraint(item: largeTextView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal
            , toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 10)
        let topConstraint = NSLayoutConstraint(item: largeTextView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal
            , toItem: largeImageView, attribute: NSLayoutAttribute.top, multiplier: 1, constant: imageSize - navBarHeight! - 15)

        NSLayoutConstraint.activate([trailingConstraint, leadingConstraint, topConstraint])
        
        
    }
    
    // constraints for large image view
    func addConstraints4LargeImage () {
        let navBarHeight = self.navigationController?.navigationBar.frame.height
        largeImageView.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal
            , toItem: largeImageView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: largeImageView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal
            , toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: largeImageView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal
            , toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: navBarHeight! + 20)
        let widthConstraint = NSLayoutConstraint(item: largeImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal
            , toItem: self.view, attribute: NSLayoutAttribute.width, multiplier: 1, constant: 0)
        let ratioConstraint = NSLayoutConstraint(item: largeImageView, attribute: NSLayoutAttribute.width, relatedBy: NSLayoutRelation.equal
            , toItem: largeImageView, attribute: NSLayoutAttribute.height, multiplier: 3 / 2, constant: 0)
        NSLayoutConstraint.activate([trailingConstraint, leadingConstraint, topConstraint, ratioConstraint, widthConstraint])
    }
    
    // constraints for scroll view
    func addConstraints4ScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let trailingConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal
            , toItem: scrollView, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
        let leadingConstraint = NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal
            , toItem: self.view, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
        let topConstraint = NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal
            , toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal
            , toItem: scrollView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
        NSLayoutConstraint.activate([trailingConstraint, leadingConstraint, topConstraint, bottomConstraint])
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
//        guard let vc = segue.destination as? tripDetailPhotoDetailOnlyVC else { return }
//        vc.image = largeImageView.image
    }
    
    private var randomImage: UIImage {
        let num: Int = Int(arc4random() % 10)
        return UIImage(named: "image\(num)")!
    }
}


// MARK: - ZoomTransitionSourceDelegate

extension tripDetailPhotoDetailVC: ZoomTransitionSourceDelegate {
    
    func transitionSourceImageView() -> UIImageView {
        return largeImageView
    }
    
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {
        return largeImageView.convert(largeImageView.bounds, to: view)
    }
    
    func transitionSourceWillBegin() {
        largeImageView.isHidden = true
    }
    
    func transitionSourceDidEnd() {
        largeImageView.isHidden = false
    }
    
    func transitionSourceDidCancel() {
        largeImageView.isHidden = false
    }
    
}


// MARK: - ZoomTransitionDestinationDelegate

extension tripDetailPhotoDetailVC: ZoomTransitionDestinationDelegate {
    
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect {
        if forward {
            let x: CGFloat = 0.0
            let y = topLayoutGuide.length
            let width = view.frame.width
            let height = width * 2.0 / 3.0
            return CGRect(x: x, y: y, width: width, height: height)
        } else {
            return largeImageView.convert(largeImageView.bounds, to: view)
        }
    }
    
    func transitionDestinationWillBegin() {
        largeImageView.isHidden = true
    }
    
    func transitionDestinationDidEnd(transitioningImageView imageView: UIImageView) {
        largeImageView.isHidden = false
        largeImageView.image = imageView.image
    }
    
    func transitionDestinationDidCancel() {
        largeImageView.isHidden = false
    }
}



