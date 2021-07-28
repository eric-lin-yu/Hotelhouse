//
//  Email.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/31.
//

import Foundation
import MessageUI

extension UIViewController:  MFMailComposeViewControllerDelegate{
    func emailFromMe() {
        // 必須User有使用內建的郵件APP
        if (MFMailComposeViewController.canSendMail()){
            let alert = UIAlertController(title: "發信給我們", message: "很抱歉發生異常！針對您的問題，我們將會竭盡所能解決，謝謝您的來信", preferredStyle: .alert)
            let email = UIAlertAction(title: "email發信", style: .default, handler: { (action) -> Void in
                let mailController = MFMailComposeViewController()
                mailController.mailComposeDelegate = self
                mailController.title = "我有問題"
                mailController.setSubject("我有問題")
                let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") //取得APP的版本
                let product = Bundle.main.object(forInfoDictionaryKey: "CFBundleName")  //APP的名稱
                let messageBody = "<br/><br/><br/>Product:\(product!): \(version!))"
                mailController.setMessageBody(messageBody, isHTML: true)
                mailController.setToRecipients(["zl2408399@gmail.com"])
                self.present(mailController, animated: true, completion: nil)
            })
            let Wait = UIAlertAction(title: "稍後", style: .default, handler: nil)
            alert.addAction(email)
            alert.addAction(Wait)
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "糟糕！", message: "您似乎沒有安裝Apple官方的郵件app！可直接發信至[zl2408399@gmail.com]與我們聯繫謝謝。", preferredStyle: .alert)
            let ok = UIAlertAction(title: "收到", style: .default, handler: nil)
            alert.addAction(ok)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //搭配郵件使用處理狀況
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .cancelled:
            print("user cancelled")
        case .failed:
            print("user failed")
        case .saved:
            print("user saved email")
        case .sent:
            print("email sent")
        default:
            print("Unknow")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func appStoreRate() {
        let askController = UIAlertController(title: "您好", message: "如果您喜歡此APP，期盼您能給予評分支持，謝謝您", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "我要評分", style: .default) { (action) in
            let appID = "1547393444"  //上架後的APP ID
            let appURL = URL(string: "https://itunes.apple.com/us/app/itunes-u/id\(appID)?action=write-review")!
            UIApplication.shared.open(appURL, options: [:],
                                      completionHandler: { (success) in
                                      })
        }
        askController.addAction(okAction)
        let laterAction = UIAlertAction(title: "稍後再評", style: .default, handler: nil)
        askController.addAction(laterAction)
        self.present(askController, animated: true, completion: nil)
    }
}
