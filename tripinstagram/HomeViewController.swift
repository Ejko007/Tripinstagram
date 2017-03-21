//
//  HomeViewController.swift
//  ImageViewer
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2017 MailOnline. All rights reserved.
//

import UIKit
import Parse

extension UIImageView: DisplaceableView {}

struct DataItem {
    
    let imageView: UIImageView
    let galleryItem: GalleryItem
}

struct PhotoItem {
    
    let imageView: UIImageView
    let imageID: String
}

var photos: [PhotoItem] = []
var items: [DataItem] = []

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    
    @IBOutlet weak var pageView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var photoCollectionLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var uuid: UILabel!
    
    var pageViewController: UIPageViewController?
        
    var currentIndex = 0
    
    var tripuuid = String()
    var username = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // title label at the top
        self.navigationItem.title = photogallery_str.uppercased()

        // new photo button
        let newBtn = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addPhoto))
        
        // show new button for current user post only
        if PFUser.current()?.username == self.username.lowercased() {
            self.navigationItem.rightBarButtonItems = [newBtn]
            newBtn.isEnabled = true
        } else {
            self.navigationItem.rightBarButtonItems = []
            newBtn.isEnabled = false
        }
        
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        photoCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        uuid.translatesAutoresizingMaskIntoConstraints = false
        
        uuid.text = tripuuid
        
        // constraints
        // vertical
        let navheight = Int((self.navigationController?.navigationBar.frame.height)!) + Int(UIApplication.shared.statusBarFrame.size.height)
        self.view.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-(\(navheight))-[contentview]-0-|",
            options: [],
            metrics: nil, views: ["contentview":contentView]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-0-[pageview(200)]-(-37)-[pagecontrol(37)]-15-[photocollectlabel(30)]-(-15)-[collectionview]-|",
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
        
        uuid.text = tripuuid
        uuid.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        photos.removeAll(keepingCapacity: false)
        photos = findPhotos()
        
        pageControl.numberOfPages = photos.count
        
        var bgImage = UIImageView()
        var tapGestureRecognizer = UITapGestureRecognizer()
        
        if !photos.isEmpty {
            
            if photos.count > 1 {
                Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.loadNextController),         userInfo: nil, repeats: true)
            }
            
            items.removeAll(keepingCapacity: false)
            
            for i in 0...photos.count - 1 {
                bgImage = photos[i].imageView
                bgImage.isUserInteractionEnabled = true
                tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(showGalleryImageViewer))
                tapGestureRecognizer.delegate = self
                self.photoCollectionView.addGestureRecognizer(tapGestureRecognizer)
            }
            
            for photo in photos {
                
                // guard let imageView = imageView else { continue }
                
                var galleryItem: GalleryItem!
                
                let image = photo.imageView.image ?? UIImage(named: "0")!
                galleryItem = GalleryItem.image { $0(image) }
                
                items.append(DataItem(imageView: photo.imageView, galleryItem: galleryItem))
            }
            
            setPageViewController()
            
        }
        
    }
    
    // --------------------- finding photos ----------------------------------------
    
    func findPhotos() -> [PhotoItem] {
        // load photos procedure
        var myphotoItems = [PhotoItem]()
        
        let photosQuery = PFQuery(className: "photos")
        photosQuery.whereKey("uuid", equalTo: postuuid.last!)
        
        do {
            let photoObjects = try photosQuery.findObjects()
            
            myphotoItems.removeAll(keepingCapacity: false)
            
            for photoObject in photoObjects {
                let thumbnail = photoObject.value(forKey: "picture") as! PFFile
                let objID = photoObject.value(forKey: "objectId") as! String
                let data = try thumbnail.getData()
                if let image = UIImage(data: data) {
                    let bgImage = UIImageView(image: image)
                    myphotoItems.append(PhotoItem(imageView: bgImage, imageID: objID))
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return myphotoItems
    }
    
    // add new photo procedure
    func addPhoto() {
        // self.performSegue(withIdentifier: "addPhotoGalleryVC", sender: self)
        let destination = self.storyboard?.instantiateViewController(withIdentifier: "addPhotoGalleryVC") as! addPhotoGalleryVC
        self.navigationController?.pushViewController(destination, animated: true)
        
        destination.tripuuid = postuuid.last!
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
        
        if !photos.isEmpty {
            if index < photos.count {
                promoContentVC.photoImage = photos[index].imageView.image
                promoContentVC.pageIndex = index
            }
        }
        
        return promoContentVC
    }
    
    @objc private func loadNextController () {
        currentIndex += 1
        
        if currentIndex == photos.count {
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
                
                headerView.count = items.count
                headerView.currentIndex = index
                footerView.count = items.count
                footerView.currentIndex = index
            }
            
            self.presentImageGallery(galleryViewController)
            
            print("you can do something with the cell or index path here")
        } else {
            print("collection view was tapped")
        }
    }
}

// extension to homeviewcontroller

extension HomeViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let pageContentVC = viewController as! PromoContentViewController
        var index = pageContentVC.pageIndex
        
        if index == 0 || index == NSNotFound {
            return getViewController(atIndex: photos.count - 1)
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
        
        if index == photos.count {
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
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPhoto", for: indexPath) as! PhotoCollectionViewCell
        
        cell.photoImageView.image = photos[indexPath.row].imageView.image
        
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
        
        // remove photo from the server
        let photoQuery = PFQuery(className: "photos")
        photoQuery.whereKey("uuid", equalTo: tripuuid)
        photoQuery.whereKey("objectId", equalTo: photos[index].imageID)
        photoQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                for object in objects! {
                    object.deleteInBackground(block: { (success: Bool, error: Error?) in
                        if success {
                            
                            // send notification to rootViewController to update shown photos
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "uploaded"), object: nil)
                            
                            // push back
                            _ = self.navigationController?.popViewController(animated: true)
                            // self.dismiss(animated: true, completion: nil)
                            // self.reloadInputViews()
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
        
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
