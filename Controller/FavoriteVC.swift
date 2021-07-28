//
//  FavoriteVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/25.
//

import UIKit
import CoreData

class FavoriteVC: UIViewController, UITableViewDataSource, UITableViewDelegate, RateVCDelegate {
    
    var favoriteDetail: [Info] = []
    
    var fetchController: NSFetchedResultsController<InfoDescription>!
    var imageNames : [String] = []
    
    @IBOutlet weak var favoriteTableView: UITableView!
    
    //待Move CoreData排序
    @IBAction func editButton(_ sender: Any) {
        self.favoriteTableView.setEditing(!self.favoriteTableView.isEditing, animated: true)
    }
    
    //MARK: - 視圖控制
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.favoriteTableView.dataSource = self
        self.favoriteTableView.delegate = self
        overrideUserInterfaceStyle = .dark
        
        favoriteTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkCoreData() //確認CoreData的最愛是否存在
        imageNames = []
        //開始塞隨機圖片
        let ran = self.favoriteDetail.count
        for _ in 0..<ran {
            let images = MyDatas.shared.imageDatas.randomElement() ?? ""
            imageNames.append(images)
        }
    }
    
    func checkCoreData() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let jsondatas = MyDatas.shared.allDataJSON[0].xmlHead.infos.info
        let fetchRequest = NSFetchRequest<InfoDescription>(entityName: "UserData")
        do {
            let results = try moc.fetch(fetchRequest)
            favoriteDetail.removeAll()
            //迴圈 -> Json.id與CoreData.id比對確認是否存在,並add至favoriteDetail
            for i in 0..<results.count {
                let fav = results[i]
                if var info = jsondatas.filter({ (info) -> Bool in
                    return info.id == fav.id
                }).first {
                    info.rating = fav.rating
                    if info.rating == "love" {
                        favoriteDetail.append(info)
                    }
                }
            }
            favoriteTableView.reloadData()
        } catch {
            assertionFailure("Core Data資料查詢失敗: \(error)")
        }
    }
    
    //MARK: - TableView
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        let sectiontitle = favoriteDetail[section].region
//        return sectiontitle
//    }
//    //回傳sections
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return favoriteDetail.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //....區分section中的rows
        return favoriteDetail.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteCell", for: indexPath) as! SearchTableViewCell
        
        let favortie = favoriteDetail
        cell.nameLabel.text = "\(favortie[indexPath.row].name)"
        cell.addLabel.text = favortie[indexPath.row].add
        //        cell.imageViewCell.image = thumbnailImage(str: MyDatas.shared.imageDatas[indexPath.row])
        //隨機圖片
        cell.imageViewCell.image = thumbnailImage(str: imageNames[indexPath.row])
        cell.imageLikeView.image = UIImage(named: favortie[indexPath.row].rating!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: "注意！", message: "您將會刪除此筆紀錄", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "刪除", style: .destructive) { (cancel) in
                //Core Data刪除
                let context = CoreDataHelper.shared.managedObjectContext()
                let fetchRequest = NSFetchRequest<InfoDescription>(entityName: "UserData")
                let predicate = NSPredicate(format: "rating = %@", "love")
                fetchRequest.predicate = predicate
                do {
                    var results = try context.fetch(fetchRequest)
                    results[indexPath.row].id = self.favoriteDetail[indexPath.row].id
                    let delet = results.remove(at: indexPath.row)
                    context.performAndWait {
                        context.delete(delet)
                    }
                    CoreDataHelper.shared.saveContext()
                } catch {
                    assertionFailure("刪除Core Data.Error: \(error)")
                }
                
                self.favoriteDetail.remove(at: indexPath.row)
                MyDatas.shared.imageDatas.remove(at: indexPath.row)
                self.favoriteTableView.deleteRows(at: [indexPath], with: .automatic)
            }
            let Wait = UIAlertAction(title: "讓我再想想！", style: .default, handler: nil)
            alert.addAction(cancel)
            alert.addAction(Wait)
            self.present(alert, animated: true, completion: nil)
        }
    }
    //往右滑呼叫share
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let shareAction = UIContextualAction(style: .normal, title: "Share") { (action, sourceView, completionHandler) in
            let str01 = "嘿,我發現一家不錯的旅社！"
            let nameText = "店家名稱： " + self.favoriteDetail[indexPath.row].name
            let addText = "地址： " + self.favoriteDetail[indexPath.row].add
            let str02 = "APP裡面有更多詳細訊息，趕快來下載吧！"
            let str03 = "https://itunes.apple.com/us/app/itunes-u/id1547393444"
            let activityController = UIActivityViewController(activityItems: [str01,nameText,addText, str02,str03], applicationActivities: nil)
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
        }
        shareAction.backgroundColor = UIColor(red: 254, green: 149, blue: 38)
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [shareAction])
        return swipeConfiguration
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let favoite = self.favoriteDetail.remove(at: sourceIndexPath.row)
        let teavel = MyDatas.shared.imageDatas.remove(at: sourceIndexPath.row)
        self.favoriteDetail.insert(favoite, at: destinationIndexPath.row)
        MyDatas.shared.imageDatas.insert(teavel, at: destinationIndexPath.row)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "favoriteCell" {
            if let indexPath  = self.favoriteTableView.indexPathForSelectedRow {
                let favorite = favoriteDetail[indexPath.row]
                
                let searchDetailVC = segue.destination as! SearchDetailTableVC
                searchDetailVC.searchdetail = favorite
                searchDetailVC.detailVCimage = imageNames[indexPath.row]
                searchDetailVC.searchdetail.rating = favorite.rating!
                searchDetailVC.delegate = self
            }
        }
    }
    
    func didFinisUpdateRate(Rate: Info) {
        if let index = self.favoriteDetail.firstIndex(of: Rate) {
            favoriteDetail[index].rating = Rate.rating
            let indexPath = IndexPath(row: index, section: 0)
            self.favoriteTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}
