//
//  AboutTableVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/29.
//

import UIKit

class AboutTableVC: UITableViewController {
    
    var sectionTitles = [NSLocalizedString("about", comment: "")]
    let versions = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") //取得目前版本
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.tableFooterView = UIView(frame: CGRect.zero)
    }

    // MARK: - Table view Title

    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    // MARK: - Table View Data
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as! DetailIconTextViewCell
            cell.imageView?.image = UIImage(named: "notes")
            cell.shortTextLabel.text = NSLocalizedString("Version", comment: "") + "\(versions ?? "")"
            
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as! DetailIconTextViewCell
            cell.iconImageView.image = UIImage(systemName: "envelope.circle")?.withTintColor(.orange,renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = NSLocalizedString("Problem Report", comment: "")
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell", for: indexPath) as! DetailIconTextViewCell
            cell.iconImageView.image = UIImage(systemName: "face.smiling")?.withTintColor(.orange,renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = NSLocalizedString("Satisfaction adjustment", comment: "")
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PrivacyCell", for: indexPath) as! DetailIconTextViewCell
            cell.iconImageView.image = UIImage(systemName: "externaldrive.fill")?.withTintColor(.orange,renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = NSLocalizedString("Data Source & Copyright Statement", comment: "")
            
            return cell

        default:
            fatalError("資料錯誤")
        }
    
    }

    //MARK: - cell觸擊設定
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            self.emailFromMe()
        }
        if indexPath.row == 2 {
            self.appStoreRate()
        }
        
    }

    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showPrivacy" {
            _ = segue.destination as! PrivacyVC
        }
    }
    

}
