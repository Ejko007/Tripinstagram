//
//  tripDetailsPhotoCollectionVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 Pavol Polacek. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

final class tripDetailsPhotoCollectionVC: UICollectionViewController {
    
    fileprivate var selectedImageView: UIImageView?
    
    @IBOutlet var collView: UICollectionView!
    
    
    // size of screen
    let width = UIScreen.main.bounds.width
    let height = UIScreen.main.bounds.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        // color of title at the top in navigation controller
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        
        // color of buttons in navigation controller
        self.navigationController?.navigationBar.tintColor = .white
        
        // color of background of navigation controller
        self.navigationController?.navigationBar.barTintColor = UIColor(colorLiteralRed: 18.0 / 255.0, green: 86.0 / 255.0, blue: 136.0 / 255.0, alpha: 1)
        
        // unable translucent
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.title = photogallery_str.uppercased()
        
        // Create left navigation item - back button
        let backBtn = UIBarButtonItem(image: UIImage(named: "back.png"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        backBtn.tintColor = .white
        
        clearsSelectionOnViewWillAppear = false
    }
    
    // go back function
    func back(sender: UIBarButtonItem) {
        //push back
        self.dismiss(animated: true, completion: nil)
    }

}

// MARK: - UICollectionViewDataSource

extension tripDetailsPhotoCollectionVC {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: tripDetailPhotoViewCell.self), for: indexPath) as! tripDetailPhotoViewCell
        cell.imageView.image = UIImage(named: "image\(indexPath.item)")
        return cell
    }
}


// MARK: - UICollectionViewDelegate

extension tripDetailsPhotoCollectionVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! tripDetailPhotoViewCell
        selectedImageView = cell.imageView
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension tripDetailsPhotoCollectionVC {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 8.0
        let length = (collectionView.frame.width - space * 3.0) / 2.0
        return CGSize(width: length, height: length)
    }
}


// MARK: - ZoomTransitionSourceDelegate

extension tripDetailsPhotoCollectionVC: ZoomTransitionSourceDelegate {
    
    func transitionSourceImageView() -> UIImageView {
        return selectedImageView ?? UIImageView()
    }
    
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect {
        guard let selectedImageView = selectedImageView else { return CGRect.zero }
        return selectedImageView.convert(selectedImageView.bounds, to: view)
    }
    
    func transitionSourceWillBegin() {
        selectedImageView?.isHidden = true
    }
    
    func transitionSourceDidEnd() {
        selectedImageView?.isHidden = false
    }
    
    func transitionSourceDidCancel() {
        selectedImageView?.isHidden = false
    }
}
