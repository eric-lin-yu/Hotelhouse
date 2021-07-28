//
//  TravelTableViewCell.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/12.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    @IBOutlet var nameLabel: UILabel!{
        didSet{
            nameLabel.textColor = .white
            nameLabel.numberOfLines = 0
        }
    }
    @IBOutlet var addLabel: UILabel! {
        didSet{
            addLabel.textColor = UIColor(red: 255, green: 128, blue: 0)
            addLabel.numberOfLines = 0
        }
    }
    @IBOutlet var imageViewCell: UIImageView!
    @IBOutlet var imageLikeView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
