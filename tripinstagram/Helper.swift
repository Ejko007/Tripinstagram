//
//  Helper.swift
//  tripinstagram
//
//  Created by Pavol Polacek on 05/01/2016.
//  Copyright © 2016 Pavol Polacek. All rights reserved.
//

import Foundation
import Parse

let has_mentioned_you_str = "se zmínil o vás"  // "has mentioned you"
let has_commented_your_post_str = "vás komentoval"  // "has mentioned you"
let now_following_you_str = "vás nyní sleduje"  // "now following you"
let likes_your_post_str = "líbí se váš příspěvek"   // "likes your post"
let enter_text_str = "Vložte zde text..."     // "Enter text..."
let followers_str = "sledující"   // "followers"
let followings_str = "sledují"  // "followings"
let feed_str = "Příspěvky" // Feed
let notifications_str = "Upozornění" // "NOTIFICATIONS"
let follow_str = "Sleduj"           // "Follow"
let following_str = "Sleduji"     // "Following"
let comments_str = "Komentáře"   // "Comments"
let photo_str = "Výlet"         // "Photo"
let mention_str = "uvést"       // "mention"
let comment_str = "komentovat"  // "comment"
let like_str = "líbí"           // "like"
let now_str = "nyní"            // "now"
let seconds_abbrav_str = "s"    // "s"
let minutes_abbrav_str = "m"    // "m"
let hours_abbrav_str = "h"      // "h"
let days_abbrav_str = "d"       // "d"
let weeks_abbrav_str = "t"      // "w"

// calculate rates value for post or feed
func calculateRates(uuid: String) -> Double {
    
    var sumaRates : Double = 0.0
    var i = 1

    let countRates = PFQuery(className: "rates")
    countRates.whereKey("uuid", equalTo: uuid)
    countRates.findObjectsInBackground(block: { (ratesObjects: [PFObject]?, ratesError: Error?) in
        
        if ratesError == nil {
            
            // calculate summary rates
            for ratesObject in ratesObjects! {
                sumaRates = sumaRates + (ratesObject.value(forKey: "rating") as! Double)
                i += 1
            }
            
            // add rates value to array
            if i > 1 {
                sumaRates = sumaRates / Double((i - 1))
            }
            
        } else {
            print(ratesError!.localizedDescription)
        }
    })
    
    return sumaRates
}
