//
//  SearchDetailVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/18.
//

import UIKit
import SafariServices
import CoreData

protocol RateVCDelegate: AnyObject {
    func didFinisUpdateRate(Rate: Info)
}
class SearchDetailTableVC: UIViewController, UITableViewDelegate, UITableViewDataSource, SFSafariViewControllerDelegate {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var headerView: DetailHeaderView!
    
    
    var searchdetail: Info!
    var detailVCimage =  ""
    
    var checkRatingdetail: Bool = false

    weak var delegate: RateVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = .orange
        navigationItem.largeTitleDisplayMode = .never
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.separatorStyle = .none
        
        overrideUserInterfaceStyle = .dark
        
        headerView.nameLabel?.text = "\(searchdetail.name)"
        headerView.townLabel.text = searchdetail.town
        headerView.headerImageView.image = UIImage(named: detailVCimage)
        if searchdetail.rating != nil {
            headerView.ratingImageView.image = UIImage(named: searchdetail.rating!)
            self.checkRatingdetail = true
        } else {
            headerView.ratingImageView.image = UIImage(named: "")
        }
        tableView.delegate = self
        tableView.dataSource = self
        
        
    }
    //處理下拉返回鍵消失
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
        
    }

    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailIconTextViewCell.self), for: indexPath) as! DetailIconTextViewCell
            
            cell.iconImageView.image = UIImage(systemName: "phone")?.withTintColor(.orange,renderingMode: .alwaysOriginal)
            cell.shortTextLabel.text = "\(searchdetail.tel)"
            cell.shortTextLabel.textColor = .white
            cell.shortTextLabel.shadowColor = .blue
            cell.selectionStyle = .none
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailIconTextViewCell.self), for: indexPath) as! DetailIconTextViewCell
            
            cell.iconImageView.image = UIImage(systemName: "network")?.withTintColor(.orange,renderingMode: .alwaysOriginal)
            
            if searchdetail.website != "" {
                cell.shortTextLabel.text = searchdetail.website
                cell.shortTextLabel.textColor = .white
                cell.shortTextLabel.shadowColor = .blue
                cell.selectionStyle = .none
            } else {
                cell.shortTextLabel.text = "很抱歉，此店家未提供官網"
                cell.selectionStyle = .none
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailIconTextViewCell.self), for: indexPath) as! DetailIconTextViewCell
            
            cell.iconImageView.image = UIImage(systemName: "mappin.and.ellipse")?.withTintColor(.orange,renderingMode: .alwaysOriginal)
            
            cell.shortTextLabel.text = searchdetail.add
            cell.selectionStyle = .none
            
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailIconTextViewCell.self), for: indexPath) as! DetailIconTextViewCell
            
            cell.iconImageView.image = UIImage(systemName: "bed.double.fill")?.withTintColor(.orange,renderingMode: .alwaysOriginal)
            if searchdetail.spec != "" {
                cell.shortTextLabel.text = searchdetail.spec
                cell.selectionStyle = .none
            } else {
                cell.shortTextLabel.text = "很抱歉，此店家未提供床型介紹"
                cell.selectionStyle = .none
            }
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailTextCell.self), for: indexPath) as! DetailTextCell
            
            cell.descriptionLabel.text = "\(searchdetail.infoDescription)"
            cell.selectionStyle = .none
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailSeparatorCell.self), for: indexPath) as! DetailSeparatorCell
            
            cell.titleLabel.text = "HOW TO GET HERE"
            cell.selectionStyle = .none
            
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailMapCell.self), for: indexPath) as! DetailMapCell
            
            cell.configure(location: searchdetail.add)
            
            return cell
            
        default:
            fatalError("資料錯誤")
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let alerts = UIAlertController(title: "提醒您", message: "將會外撥電話至 \(searchdetail.name)", preferredStyle: .alert)
            let phone = searchdetail.tel
            let ok = UIAlertAction(title: "撥打電話", style: .default) { (_) in
                if let url = URL(string: "tel:\(phone)") {
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        print("無法開啟URL")
                    }
                } else {
                    print("連結錯誤")
                }
            }
            let Wait = UIAlertAction(title: "取消", style: .default, handler: nil)
            alerts.addAction(ok)
            alerts.addAction(Wait)
            self.present(alerts, animated: true, completion: nil)
        }
        //show safari
        if indexPath.row == 1 {
            if let url = URL(string: searchdetail.website) {
                if url.scheme != "http" {
                    //判斷網址是否有http
                    guard let url = URL(string: "http://\(searchdetail.website)") else {  return  }
                    let safari = SFSafariViewController(url: url)
                    safari.delegate = self
                    present(safari, animated: true, completion: nil)
                } else {
                    let safari = SFSafariViewController(url: url)
                    safari.delegate = self
                    present(safari, animated: true, completion: nil)
                }
            }
        }
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMap" {
            let destinationController = segue.destination as! MapVC
            destinationController.mapdatail = searchdetail
        }  else if segue.identifier == "showReview" {
            let destinationController = segue.destination as! RateVC
            destinationController.teavelimages = detailVCimage
        }
        
    }
    
    // (X) 回退segue
    @IBAction func close(segue: UIStoryboardSegue) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    // (表情)回退segue
    @IBAction func rateRestaurant(segue: UIStoryboardSegue) {
        dismiss(animated: true) {
            //將User點選的表情str回傳
            if let rating = segue.identifier {
                self.searchdetail.rating = rating
                self.headerView.ratingImageView.image = UIImage(named: rating)
                
                //MARK: - CoreData儲存
                let moc = CoreDataHelper.shared.managedObjectContext()
                //查詢CoreData.ID是否存在
                let fetchRequest = NSFetchRequest<InfoDescription>(entityName: "UserData")
                let predicate = NSPredicate(format: "id = %@", self.searchdetail.id)
                fetchRequest.predicate = predicate
                do {
                    let results = try moc.fetch(fetchRequest)
                        //第二次存取表情更改
                    if results.count > 0 {
                        results[0].rating = self.searchdetail.rating
                        CoreDataHelper.shared.saveContext()
                    } else {
                        //首次更改表情CoreData存檔
                        let saveCoreData = InfoDescription(context: CoreDataHelper.shared.managedObjectContext())
                        saveCoreData.id = self.searchdetail.id
                        saveCoreData.rating = rating
//                        saveCoreData.seq = 0
                        CoreDataHelper.shared.saveContext()
                    }
                } catch {
                    assertionFailure("儲存Core Data.Error: \(error)")
                }
                //MARK: - VC資料傳遞
                self.delegate?.didFinisUpdateRate(Rate: self.searchdetail)
                
                let scaleTransform = CGAffineTransform.init(scaleX: 0.1, y: 0.1)
                self.headerView.ratingImageView.transform = scaleTransform
                self.headerView.ratingImageView.alpha = 0
                
                UIView.animate(withDuration: 0.4, delay: 0,
                               usingSpringWithDamping: 0.3,
                               initialSpringVelocity: 0.7, options: []) {
                    self.headerView.ratingImageView.transform = .identity
                    self.headerView.ratingImageView.alpha = 1
                }
               
                //如Rating是love則存到favoriteVC
//                if rating == "love", self.checkRatingdetail == false{
//                    self.searchdetail.rating = rating
//                    let tabBar = self.tabBarController!
//                    let navigationViewController = tabBar.viewControllers![1] as! UINavigationController //找到tabBar上的navigat
//                    let favoriteViewController = navigationViewController.viewControllers[0] as! FavoriteVC //再找到favorite
//                    favoriteViewController.favoriteDetail.append(self.searchdetail)
//                    favoriteViewController.teavelimages.append("\(self.teavelimages)")
//                }
            }
        }
        
    }
    
    
    
}
