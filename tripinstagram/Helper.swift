//
//  Helper.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import Foundation
import Parse
import PopupDialog

let has_mentioned_you_str = "se zmínil(a) o vás"  // "has mentioned you"
let has_commented_your_post_str = "vás komentoval(a)"  // "has mentioned you"
let now_following_you_str = "vás nyní sleduje"  // "now following you"
let likes_your_post_str = "líbí se váš příspěvek"   // "likes your post"
let rated_your_post_str = "ohodnotil(a) váš příspěvek"  // "rated your post"
let enter_text_str = "Vložte zde text..."     // "Enter text..."
let followers_str = "sledující"   // "followers"
let followings_str = "sledování"  // "followings"
let feeds_str = "Příspěvky" // Feed
let feed_str = "Příspěvek" // Feed
let notifications_str = "Upozornění" // "NOTIFICATIONS"
let follow_str = "Sledovat"           // "Follow"
let following_str = "Sleduji"     // "Following"
let comments_str = "Komentáře"   // "Comments"
let rates_str = "Hodnocení"   // "Rates"
let photo_str = "Příspěvek"         // "Photo"
let mention_str = "uvést"       // "mention"
let comment_str = "komentovat"  // "comment"
let like_str = "líbí"           // "like"
let now_str = "nyní"            // "now"
let seconds_abbrav_str = "s"    // "s"
let minutes_abbrav_str = "m"    // "m"
let hours_abbrav_str = "h"      // "h"
let days_abbrav_str = "d"       // "d"
let weeks_abbrav_str = "t"      // "w"
let no_data_available = "Zatím chybí data..."      // "No data available"
let cancel_button_str = "Zrušit"
let question_what_to_do_with_article = "Co chcete udělat s tímto příspěvkem?"
let deletion_article_description = "Pokud zvolíte 'Smazat', smažou se spolu s uvedeným příspěvkem i všechny komentáře a hodnocení."
let hide_article_description = "Pokud zvolíte 'Skrýt', příspěvek se stane neveřejným."
let show_article_description = "Pokud zvolíte 'Publikovat', příspěvek se stane veřejným."
let complain_article_description = "Pokud zvolíte 'Nahlásit', označí se příspek komentářem."
let delete_str = "Smazat"       // Delete
let complain_str = "Nahlásit"    // Complain
let ok_str = "OK"               // OK
let complain_confirmation_str = "Oznámení probéhlo v pořádku. Děkujem. Pokusíme se včas posoudit vaše upozornění." // "Complain has been made successfully.", message: "Thank you! We will consider your complain."
let hashtag_str = "Hashtag s názvem"   // "hashtag"
let is_created = "byl úspěšně vytvořen"         // "is created"
let error_str = "Chyba"      // Error
let male_str = "muž"
let female_str = "žena"
let update_profile_str = "Upravit profil"  // Update profile
let update_post_str = "Upravit"  // Update post
let no_login_and_password_error_str = "Přihlaste se k účtu vyplněním jména a hesla."
let all_fields_no_empty_str = "Je nutné vyplnit všechny políčka formuláře."
let password_fields_no_match = "Použité hesla nejsou stejná."
let registration_str = "Registrace"
let registration_successful_str = "Registrace nového uživatele na serveru proběhla úspěšně."
let user_has_no_account = "Tento uživatel nemá v aplikaci vytvořen účet."
let save_str = "Uložit"
let new_feed_str = "Nový příspěvek"
let publish_str = "Publikovat"
let name_of_feed = "Název příspěvlu"
let hide_str = "Skrýt"
let no_rates_str = "Tento příspěvek nebyl zatím nikým hodnocen."
let rate_it_str = "Ohodnotit"
let choose_data_range_str = "Zvolte termín"

// croping picture and center it
func cropToBounds(_ image: UIImage, width: Double, height: Double) -> UIImage {
    
    let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
    
    let contextSize: CGSize = contextImage.size
    
    var posX: CGFloat = 0.0
    var posY: CGFloat = 0.0
    var cgwidth: CGFloat = CGFloat(width)
    var cgheight: CGFloat = CGFloat(height)
    
    // See what size is longer and create the center off of that
    if contextSize.width > contextSize.height {
        posX = ((contextSize.width - contextSize.height) / 2)
        posY = 0
        cgwidth = contextSize.height
        cgheight = contextSize.height
    } else {
        posX = 0
        posY = ((contextSize.height - contextSize.width) / 2)
        cgwidth = contextSize.width
        cgheight = contextSize.width
    }
    
    let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
    
    // Create bitmap image from context using the rect
    let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
    
    // Create a new image based on the imageRef and rotate back to the original orientation
    let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
    
    return image
}

// cut an image into the circle
func maskRoundedImage(_ image: UIImage, radius: Float) -> UIImage {
    let imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage!
}


// resize image function
func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
    let size = image.size
    
    let widthRatio  = targetSize.width  / image.size.width
    let heightRatio = targetSize.height / image.size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    if(widthRatio > heightRatio) {
        newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
    } else {
        newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
    }
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage!
}


