//
//  RatingViewController.swift
//  PopupDialog
//
//  Created by Martin Wildfeuer on 11.07.16.
//  Copyright © 2016 CocoaPods. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {

    @IBOutlet weak var cosmosStarRating: CosmosView!

    @IBOutlet weak var commentTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cosmosStarRating.rating = 0.0
        cosmosStarRating.settings.fillMode = .precise
        cosmosStarRating.starSize = 20.0
        cosmosStarRating.filledColor = .orange
        cosmosStarRating.filledBorderColor = .orange
        cosmosStarRating.emptyBorderColor = .orange


        commentTextField.delegate = self
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
    }

    func endEditing() {
        view.endEditing(true)
    }
}

extension RatingViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing()
        return true
    }
}
