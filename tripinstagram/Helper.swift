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
let new_feed_str = "Nový záznam"
let publish_str = "Publikovat"
let name_of_feed = "Název příspěvku"
let hide_str = "Skrýt"
let no_rates_str = "Tento příspěvek nebyl zatím nikým hodnocen."
let rate_it_str = "Ohodnotit"
let choose_data_range_str = "Zvolte termín"
let triproute_menu_str = "Trasa"
let spents_menu_str = "Náklady"
let spent_str = "Náklad"
let spent_beginning_str = "Počáteční"
let spent_other_str = "Další"
let amount_str = "Částka:"
let spent_name_placehoder_str = "Specifikujte název pro výdej..."
let deletion_spent_description = "Pokud zvolíte 'Smazat', smaže se uvedený záznam o nákladu."
let spent_deletion_confirmation_str = "Záznam o vynaloženém nákladu byl úspěšně smazán ze serveru."
let trip_details = "Výlety"
let trips_list_str = "Výlety"
let trip_list_str = "Výlet"
let trip_POI_str = "Body"
let standard_str = "Standard"
let satelite_str = "Satelit"
let hybrid_str = "Hybrid"
let annotation_str = "Anotace"
let annotation_save_confirm_str = "Anotace byla úspěšně uložena na server do seznamu bodů zájmů. Zde ji můžete dodatečně upravit, případně smazat."
let description_str = "Popis"
let trip_POI_search_str = "Hledat body zájmu"
let poi_name_str = "Název průchozího bodu"
let poi_description_str = "Popis průchozího bodu"
let poi_comment_str = "Komentář k průchozímu bodu"
let latitude_str = "Latituda"
let longitude_str = "Longituda"
let trip_point = "Bod"
let point_passthru_str = "Průchozí"
let point_interest_str = "Zájmový"
let not_specified_str = "Nespecifikovaný"
let thought_str = "Příběh"
let photogallery_str = "Fotogalerie"
let get_actual_position_str = "Použít aktuální pozici"
let camera_str = "Fotogalerie"
let map_str = "Mapa"
let map_itinerary_str = "Itinerář"
let km_str = "km"
let see_all_str = "Vše"
let from_str = "z"  // 1 from 10 - counter
let new_snapshot_str = "Nový snímek"
let back_str = "Zpět"
let done_str = "Hotovo"
let countries_str = "Seznam zemí"
let countries_max_str = "Maximální počet vybraných zemí je 7. Vyberte prosím ze seznamu menší počet zemí."
let add_str = "Přidat"
let add_spent_name_str = "Zadejte název nákladové položky. Toto políčko nemůže zůstat prázdné."
let currency_code_str = "Kód měny"
let currency_used_str = "Použít pro přepočet tuto měnu"
let wrong_email_address_format_str = "Špatný formát emailové adresy"
let change_email_address_format_str = "Opravte prosím formát emailové adresy."
let wrong_webpage_url_format_str = "Špatný formát webové stránky"
let change_webpage_url_format_str = "Opravte prosím formát adresy webové stránky."
let sharing_notification_str = "Pokud máte aktivovaný Facebook nebo Twitter účet, můžete tento příspěvek sdílet na těchto sociálních sítích."
let twitter_unavailable = "Twitter je nedostupný"
let facebook_unavailable = "Facebook je nedostupný"
let twitter_registration_error = "Váš Twitter účet není správně nakonfigurován, nebo nemáte vůbec zde vytvořen účet."
let facebook_registration_error = "Váš Facebook účet není správně nakonfigurován, nebo nemáte vůbec zde vytvořen účet."
let twitter_str = "Twitter"
let facebook_str = "Facebook"
let share_item = "Zde je zajímavý příspěvek"
let home_application_url_str = "http://www.ejko.cz"


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

// get currency references
func getCurrencyList(referenceCurrency: String) -> [Currency] {
    
    var finalCurrencyList = [Currency]()

    let requestURL = URL(string: "http://api.fixer.io/latest?base=" + referenceCurrency)
    let data = try! Data(contentsOf: requestURL!)
    
    finalCurrencyList.removeAll(keepingCapacity: false)
    if let json = try! JSONSerialization.jsonObject(with: data, options: .allowFragments)  as? [String: AnyObject]{
        for (name, rate) in json["rates"] as! [String: Double]{
            let currencyInstance = Currency(name: name, rate: rate)
            finalCurrencyList.append(currencyInstance!)
        }
    }
    
    return finalCurrencyList
}

func getCurrencyRate(referenceCurrency: String, searchCurrency: String) -> Double {
    var tempRate:Double = 0.0
    var tempCurrentList = [Currency]()
    tempCurrentList = getCurrencyList(referenceCurrency: referenceCurrency)
    for currency in tempCurrentList {
        if currency.name.uppercased() == searchCurrency.uppercased() {
            tempRate = currency.rate
            break
        }
    }
    return tempRate
}


extension Double {
    /// Rounds the double to decimal places value
    func roundTo(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIImage {
    func imageResize (sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = true
        let scale: CGFloat = 0.0 // Use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage!
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)}
        
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)}
}



