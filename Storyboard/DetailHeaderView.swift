//
//  SearchEndHeaderView.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/17.
//

import UIKit

class DetailHeaderView: UIView {
    
    @IBOutlet weak var ratingImageView: UIImageView!
    
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel! {
        didSet {
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet weak var townLabel: UILabel!{
        didSet {
            townLabel.layer.cornerRadius = 5.0
            townLabel.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var Privacytext: UILabel!

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
