//
//  HeadlineTableViewCell.swift
//  NewsArticlesApp
//
//  Created by AhmedFareed on 09/04/2022.
//

import UIKit

class HeadlineTableViewCell: UITableViewCell {
    

    @IBOutlet weak var headLineLabel: UILabel!
    @IBOutlet weak var headlineImageVIew: UIImageView!
    func configureCell(imageURL: String?, title: String?) {
        headLineLabel.text = title
        if let imageURL = imageURL {
            headlineImageVIew.setImageWith(url: imageURL)
        }
    }

    
}
