//
//  RateVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/24.
//

import UIKit

class RateVC: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var Buttons: [UIButton]!
    @IBOutlet var closeButton: UIButton!
    
    var teavelimages =  ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundImageView.image = UIImage(named: teavelimages)
        
        //應用模糊效果
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        //表情按鈕終止狀態"隱藏"
        for button in Buttons {
            button.transform = moveScaleTransform
            button.alpha = 0
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.2, initialSpringVelocity: 0.3, options: [], animations: {
            self.Buttons[0].alpha = 1.0
            self.Buttons[0].transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
            self.Buttons[1].alpha = 1.0
            self.Buttons[1].transform = .identity
        }, completion: nil)
        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
            self.Buttons[2].alpha = 1.0
            self.Buttons[2].transform = .identity
        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.1, options: [], animations: {
            self.closeButton.transform = .identity
        }, completion: nil)
        
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
