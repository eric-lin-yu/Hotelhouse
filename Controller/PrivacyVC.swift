//
//  PrivacyVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/31.
//

import UIKit

class PrivacyVC: UIViewController {
    
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var showImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImageView.image = UIImage(named: "80CEC64C-F681-4DB1-B4AB-5AB7CFC4A964_1_105_c")
        showImageView.image = UIImage(named: "專題隱私權")
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
