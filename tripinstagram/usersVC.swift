//
//  usersVC.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import UIKit
import Parse

class usersVC: UITableViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // declare search bar
    var searchBar = UISearchBar()
    
    // tableView arrays to hold information from the server
    var usernameArray = [String]()
    var avaArray = [PFFile]()
    var genderArray = [String]()

    
    // collectionView UI
    var collectionView : UICollectionView!
    
    // collectionView arrays to hold information from the server
    var picArray = [PFFile]()
    var uuidArray = [String]()
    var refresher = UIRefreshControl()
    var page : Int = 15
    
    
    // deafault function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // implement search bar
        searchBar.delegate = self
        searchBar.sizeToFit()
        searchBar.tintColor = UIColor.groupTableViewBackground
        searchBar.frame.size.width = self.view.frame.size.width - 34
        let searchItem = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = searchItem
        
        // call functions
        loadUsers()
        
        // call collectionView
        collectionViewLaunch()
    }

    // SEARCHING CODE
    // load users function
    func loadUsers() {
        
        let usersQuery = PFQuery(className: "User")
        usersQuery.addDescendingOrder("createdAt")
        usersQuery.limit = 20
        usersQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.usernameArray.removeAll(keepingCapacity: false)
                self.avaArray.removeAll(keepingCapacity: false)
                self.genderArray.removeAll(keepingCapacity: false)
                
                // found related objects
                for object in objects! {
                    self.usernameArray.append(object.value(forKey: "username") as! String)
                    self.avaArray.append(object.value(forKey: "ava") as! PFFile)
                    self.genderArray.append(object.value(forKey: "gender") as! String)
                }
                
                // reload
                self.tableView.reloadData()
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }

    // search updated
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        // find by username
        let usernameQuery = PFQuery(className: "User")
        usernameQuery.whereKey("username", matchesRegex: "(?i)" + self.searchBar.text!)
        usernameQuery.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // if no objects are found according to entered text in username column, find by fullname
                if objects!.isEmpty {
                    
                    let fullnameQuery = PFUser.query()
                    
                    fullnameQuery?.whereKey("fullname", matchesRegex: "(?i)" + self.searchBar.text!)
                    
                    fullnameQuery?.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
                        if error == nil {
                            
                            // cleanup
                            self.usernameArray.removeAll(keepingCapacity: false)
                            self.avaArray.removeAll(keepingCapacity: false)
                            self.genderArray.removeAll(keepingCapacity: false)
                            
                            // found related objects
                            for object in objects! {
                                self.usernameArray.append(object.object(forKey: "username") as! String)
                                self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                                self.genderArray.append(object.object(forKey: "gender") as! String)
                            }
                            
                            // reload
                            self.tableView.reloadData()
                            
                        } else {
                            print(error!.localizedDescription)
                        }
                    })
                    
                    // clean up
                    self.usernameArray.removeAll(keepingCapacity: false)
                    self.avaArray.removeAll(keepingCapacity: false)
                    self.genderArray.removeAll(keepingCapacity: false)

                    // found related objects
                    for object in objects! {
                        self.usernameArray.append(object.object(forKey: "username") as! String)
                        self.avaArray.append(object.object(forKey: "ava") as! PFFile)
                        self.genderArray.append(object.object(forKey: "gender") as! String)
                    }

                    // reload
                    self.tableView.reloadData()
                }
            } else {
                print(error!.localizedDescription)
            }
        })
        
        return true
    }
    
    
    // clicked cance button in search bar
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        // unhide collectionView when tapped cancel button
        collectionView.isHidden = false
        
        // dismiss keyboard
        searchBar.resignFirstResponder()
        
        // hide cance button
        searchBar.showsCancelButton = false
        
        // reset text
        searchBar.text = ""
        
        // reset shown users
        loadUsers()
    }
    
    
    // tapped on search bar
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        // hide collectView when started search
        collectionView.isHidden = true
        
        // show cancel button
        searchBar.showsCancelButton = true
    }
    
    
    // cell numb
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usernameArray.count
    }
    
    // cell height
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }

    // cell config
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // define cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! followersCell
        
        // follow button
        cell.followBtn.isHidden = true
        
        // connect cell's objects with received information from the server
        cell.usernameLbl.text = usernameArray[indexPath.row]
        if genderArray[indexPath.row] == "male" {
            cell.usernameLbl.textColor = .blue
        } else {
            cell.usernameLbl.textColor = .red
        }

        avaArray[indexPath.row].getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                cell.avaImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        return cell
    }
    
    // selected tableView cell - selected user
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // calling cell again to call cell data
        let cell = tableView.cellForRow(at: indexPath) as! followersCell
        
        // if user tap on his name go home else go guest
        if cell.usernameLbl.text! == PFUser.current()?.username {
            let home = self.storyboard?.instantiateViewController(withIdentifier: "homeVC") as! homeVC
            self.navigationController?.pushViewController(home, animated: true)
        } else {
            guestname.append(cell.usernameLbl.text!)
            let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
            self.navigationController?.pushViewController(guest, animated: true)
        }
    }
    
    // COLLECTIONVIEW CODE
    func collectionViewLaunch() {
        
        // layout of collection view
        let layout : UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        // item size
        layout.itemSize = CGSize(width: self.view.frame.size.width / 3, height: self.view.frame.size.width / 3)
        
        // direction of scrolling
        layout.scrollDirection = UICollectionViewScrollDirection.vertical
        
        // define frame of collectionView
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - self.tabBarController!.tabBar.frame.size.height - self.navigationController!.navigationBar.frame.size.height - 20)
        
        // declare collectionView
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        // define cell for collectionView
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        // call function to load posts
        loadPosts()
    }
    
    // cell line spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // cell inter spacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // TABLEVIEW CODE
    // cell numb
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return picArray.count
    }
    
    // cell config
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // define cell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        // create picture imageview in cell to show loaded pictures
        let picImg = UIImageView(frame: CGRect(x: 0, y: 0, width: cell.frame.size.width, height: cell.frame.size.height))
        cell.addSubview(picImg)
        
        // get loaded imabe from array
        picArray[indexPath.row].getDataInBackground(block: { (data: Data?, error: Error?) in
            if error == nil {
                picImg.image = UIImage(data: data!)
            } else {
                print(error!.localizedDescription)
            }
        })
        return cell
    }
    
    // cell's selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // take unique id of the post to load in postVC
        postuuid.append(uuidArray[indexPath.row])
        
        // present postVC programatically
        let post = self.storyboard?.instantiateViewController(withIdentifier: "postVC") as! postVC
        self.navigationController?.pushViewController(post, animated: true)
    }
    
    // load posts
    func loadPosts() {
        let query = PFQuery(className: "posts")
        // show only published posts
        query.whereKey("isPublished", equalTo: true)
        query.limit = page
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            if error == nil {
                
                // clean up
                self.picArray.removeAll(keepingCapacity: false)
                self.uuidArray.removeAll(keepingCapacity: false)
                
                // found related objects
                for object in objects! {
                    self.picArray.append(object.object(forKey: "pic") as! PFFile)
                    self.uuidArray.append(object.object(forKey: "uuid") as! String)
                }
                
                // reload collectionView to present images
                self.collectionView.reloadData()
                self.refresher.endRefreshing()
                
            } else {
                print(error!.localizedDescription)
            }
        })
    }
    
    // scrolled down
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // scroll down for paging
        if scrollView.contentOffset.y >= scrollView.contentSize.height / 6 {
            self.loadMore()
        }
    }
    
    // pagination
    func loadMore() {
        
        // if more posts are unloaded, we wanna load them
        if page <= picArray.count {
            
            // increase page size
            page += 15
            
            // load additional posts
            let query = PFQuery(className: "posts")
            // show only published posts
            query.whereKey("isPublished", equalTo: true)
            query.limit = page
            query.findObjectsInBackground(block: { (objects:[PFObject]?, error:Error?) in
                if error == nil {
                    
                    // clean up
                    self.picArray.removeAll(keepingCapacity: false)
                    self.uuidArray.removeAll(keepingCapacity: false)
                    
                    // find related objects
                    for object in objects! {
                        self.picArray.append(object.object(forKey: "pic") as! PFFile)
                        self.uuidArray.append(object.object(forKey: "uuid") as! String)
                    }
                    
                    // reload collectionView to present loaded images
                    self.collectionView.reloadData()
                } else {
                    print(error!.localizedDescription)
                }
            })
        }
    }

}
