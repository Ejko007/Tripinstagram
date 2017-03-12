//
//  HomeViewController.swift
//  ImageViewer
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 MailOnline. All rights reserved.
//

import UIKit

extension UIImageView: DisplaceableView {}

struct DataItem {
    
    let imageView: UIImageView
    let galleryItem: GalleryItem
}

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    var pageViewController: UIPageViewController?
    
    let arrPageImg = ["0","1","2","3","4","5","6","7","8","9","video"]
    var currentIndex = 0
    var photosCollection = [String]()
    var items: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        // vertical
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-64-[contentview]-0-|",
            options: [],
            metrics: nil, views: ["contentview":contentView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[pageview(200)]-(-37)-[pagecontrol(37)]-15-[photocollectlabel(30)]-(-15)-[collectionview(200)]",
            options: [],
            metrics: nil, views: ["pageview":pageView, "pagecontrol":pageControl, "photocollectlabel":photoCollectionLabel, "collectionview":photoCollectionView]))
       
        // horizontal
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[contentview]-0-|",
            options: [],
            metrics: nil, views: ["contentview":contentView]))

        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[pageview]-0-|",
            options: [],
            metrics: nil, views: ["pageview":pageView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[pagecontrol]-0-|",
            options: [],
            metrics: nil, views: ["pagecontrol":pageControl]))
       
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-15-[photocollectlabel]",
            options: [],
            metrics: nil, views: ["photocollectlabel":photoCollectionLabel]))

        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-0-[photocollview]-0-|",
            options: [],
            metrics: nil, views: ["photocollview":photoCollectionView]))

        self.contentView.bringSubview(toFront: photoCollectionLabel)
        
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(HomeViewController.loadNextController), userInfo: nil, repeats: true)
        
        pageControl.numberOfPages = arrPageImg.count
        
        setPageViewController()
        
        photosCollection = arrPageImg
        
        var img = UIImage()
        var bgImage = UIImageView()
        var imageViews = [UIImageView]()
        var tapGestureRecognizer = UITapGestureRecognizer()
        
        for i in 0...arrPageImg.count - 1 {
            img = UIImage(named: arrPageImg[i])!
            bgImage = UIImageView(image: img)
            bgImage.isUserInteractionEnabled = true
            tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showGalleryImageViewer))
            tapGestureRecognizer.delegate = self
            self.photoCollectionView.addGestureRecognizer(tapGestureRecognizer)
            // bgImage.addGestureRecognizer(tapGestureRecognizer)
            imageViews.append(bgImage)
            
        }
        
        for (index, imageView) in imageViews.enumerated() {
            
            // guard let imageView = imageView else { continue }
            
            var galleryItem: GalleryItem!
            
            switch index {
                
//            case 2:
//                
//                galleryItem = GalleryItem.video(fetchPreviewImageBlock: { $0(UIImage(named: "2")!) }, videoURL: URL (string: "http://video.dailymail.co.uk/video/mol/test/2016/09/21/5739239377694275356/1024x576_MP4_5739239377694275356.mp4")!)
//                
//            case 4:
//                
//                let myFetchImageBlock: FetchImageBlock = { $0(imageView.image!) }
//                
//                let itemViewControllerBlock: ItemViewControllerBlock = { index, itemCount, fetchImageBlock, configuration, isInitialController in
//                    
//                    return AnimatedViewController(index: index, itemCount: itemCount, fetchImageBlock: myFetchImageBlock, configuration: configuration, isInitialController: isInitialController)
//                }
//                
//                galleryItem = GalleryItem.custom(fetchImageBlock: myFetchImageBlock, itemViewControllerBlock: itemViewControllerBlock)
                
            default:
                
                let image = imageView.image ?? UIImage(named: "0")!
                galleryItem = GalleryItem.image { $0(image) }
            }
            
            items.append(DataItem(imageView: imageView, galleryItem: galleryItem))
        }

    }


    // MARK: - Private functions
    private func setPageViewController() {
        let pageVC = self.storyboard?.instantiateViewController(withIdentifier: "promoPageVC") as! UIPageViewController
        pageVC.dataSource = self
        
        let firstController = getViewController(atIndex: 0)
        
        pageVC.setViewControllers([firstController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        self.pageViewController = pageVC
        
        self.addChildViewController(self.pageViewController!)
        self.pageView.addSubview(self.pageViewController!.view)
        self.pageViewController?.didMove(toParentViewController: self)
        
    }
    
    fileprivate func getViewController(atIndex index: Int) -> PromoContentViewController {
        let promoContentVC = self.storyboard?.instantiateViewController(withIdentifier: "promoContentVC") as! PromoContentViewController
        
        promoContentVC.imageName = arrPageImg[index]
        promoContentVC.pageIndex = index
        
        return promoContentVC
    }
    
    @objc private func loadNextController () {
        currentIndex += 1
        
        if currentIndex == arrPageImg.count {
            currentIndex = 0
        }
        
        let nextController = getViewController(atIndex: currentIndex)
        
        self.pageViewController?.setViewControllers([nextController], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        
        self.pageControl.currentPage = currentIndex
    }

    func galleryConfiguration() -> GalleryConfiguration {
        
        return [
            
            GalleryConfigurationItem.closeButtonMode(.builtIn),
            
            GalleryConfigurationItem.pagingMode(.standard),
            GalleryConfigurationItem.presentationStyle(.displacement),
            GalleryConfigurationItem.hideDecorationViewsOnLaunch(false),
            
            GalleryConfigurationItem.swipeToDismissMode(.vertical),
            GalleryConfigurationItem.toggleDecorationViewsBySingleTap(false),
            
            GalleryConfigurationItem.overlayColor(UIColor(white: 0.035, alpha: 1)),
            GalleryConfigurationItem.overlayColorOpacity(1),
            GalleryConfigurationItem.overlayBlurOpacity(1),
            GalleryConfigurationItem.overlayBlurStyle(UIBlurEffectStyle.light),
            
            GalleryConfigurationItem.maximumZoomScale(8),
            GalleryConfigurationItem.swipeToDismissThresholdVelocity(500),
            
            GalleryConfigurationItem.doubleTapToZoomDuration(0.15),
            
            GalleryConfigurationItem.blurPresentDuration(0.5),
            GalleryConfigurationItem.blurPresentDelay(0),
            GalleryConfigurationItem.colorPresentDuration(0.25),
            GalleryConfigurationItem.colorPresentDelay(0),
            
            GalleryConfigurationItem.blurDismissDuration(0.1),
            GalleryConfigurationItem.blurDismissDelay(0.4),
            GalleryConfigurationItem.colorDismissDuration(0.45),
            GalleryConfigurationItem.colorDismissDelay(0),
            
            GalleryConfigurationItem.itemFadeDuration(0.3),
            GalleryConfigurationItem.decorationViewsFadeDuration(0.15),
            GalleryConfigurationItem.rotationDuration(0.15),
            
            GalleryConfigurationItem.displacementDuration(0.55),
            GalleryConfigurationItem.reverseDisplacementDuration(0.25),
            GalleryConfigurationItem.displacementTransitionStyle(.springBounce(0.7)),
            GalleryConfigurationItem.displacementTimingCurve(.linear),
            
            GalleryConfigurationItem.statusBarHidden(true),
            GalleryConfigurationItem.displacementKeepOriginalInPlace(false),
            GalleryConfigurationItem.displacementInsetMargin(50)
        ]
    }

    
    func showGalleryImageViewer(_ sender: UITapGestureRecognizer) {
        
        if let indexPath = self.photoCollectionView?.indexPathForItem(at: sender.location(in: self.photoCollectionView)) {
            
            // let cell = self.photoCollectionView?.cellForItem(at: indexPath) as! PhotoCollectionViewCell
            
            // guard let displacedViewIndex = items.index(where: { $0.imageView == displacedView }) else { return }
            
            let displacedViewIndex = indexPath.item
            
            let frame = CGRect(x: 0, y: 0, width: 200, height: 24)
            let headerView = CounterView(frame: frame, currentIndex: displacedViewIndex, count: items.count)
            let footerView = CounterView(frame: frame, currentIndex: displacedViewIndex, count: items.count)
            
            let galleryViewController = GalleryViewController(startIndex: displacedViewIndex, itemsDataSource: self, itemsDelegate: self, displacedViewsDataSource: self, configuration: galleryConfiguration())
            galleryViewController.headerView = headerView
            galleryViewController.footerView = footerView
            
            galleryViewController.launchedCompletion = { print("LAUNCHED") }
            galleryViewController.closedCompletion = { print("CLOSED") }
            galleryViewController.swipedToDismissCompletion = { print("SWIPE-DISMISSED") }
            
            galleryViewController.landedPageAtIndexCompletion = { index in
                
                print("LANDED AT INDEX: \(index)")
                
                headerView.count = self.items.count
                headerView.currentIndex = index
                footerView.count = self.items.count
                footerView.currentIndex = index
            }
            
            self.presentImageGallery(galleryViewController)
            
            print("you can do something with the cell or index path here")
        } else {
            print("collection view was tapped")
        }
        
        
        
    }

    
    func loadPhotos() {
        
    }
    

}

// extension to homeviewcontroller

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let pageContentVC = viewController as! PromoContentViewController
        var index = pageContentVC.pageIndex
        
        if index == 0 || index == NSNotFound {
            return getViewController(atIndex: arrPageImg.count - 1)
        }
        
        index -= 1
        
        return getViewController(atIndex: index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let pageContentVC = viewController as! PromoContentViewController
        var index = pageContentVC.pageIndex
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == arrPageImg.count {
            return getViewController(atIndex: 0)
        }
        
        return getViewController(atIndex: index)
     }
}

// extension to UICollectionViewDatasource

extension HomeViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photosCollection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPhoto", for: indexPath) as! PhotoCollectionViewCell
        
        let photo = photosCollection[indexPath.row]
        cell.photoImageView.image = UIImage(named: photo)
        
        return cell
    }
}

extension HomeViewController: GalleryDisplacedViewsDataSource {
    
    func provideDisplacementItem(atIndex index: Int) -> DisplaceableView? {
        
        return index < items.count ? items[index].imageView : nil
    }
}

extension HomeViewController: GalleryItemsDataSource {
    
    func itemCount() -> Int {
        
        return items.count
    }
    
    func provideGalleryItem(_ index: Int) -> GalleryItem {
        
        return items[index].galleryItem
    }
}

extension HomeViewController: GalleryItemsDelegate {
    
    func removeGalleryItem(at index: Int) {
        
        print("remove item at \(index)")
        
        let imageView = items[index].imageView
        imageView.removeFromSuperview()
        items.remove(at: index)
    }
}

// Some external custom UIImageView we want to show in the gallery
class FLSomeAnimatedImage: UIImageView {
}

// Extend ImageBaseController so we get all the functionality for free
class AnimatedViewController: ItemBaseController<FLSomeAnimatedImage> {
}
