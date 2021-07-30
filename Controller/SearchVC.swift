//
//  SearchTableVC.swift
//  just camping
//
//  Created by 則佑林 on 2020/12/11.
//

import UIKit
import Alamofire
import KRProgressHUD
import CoreData

class SearchVC: UIViewController, /*UISearchResultsUpdating,*/ UITableViewDataSource, UISearchBarDelegate, RateVCDelegate {

//    var searchController: UISearchController!
    var downloadDatas: [JSONDatas] = [] //儲存下載資料
    var searchDownload: [Info] = [] //儲存搜尋結果
    var ratings: [InfoDescription] = []
    
    @IBOutlet weak var searchTableView: UITableView!
    
    //MARK:- 視圖控制
    override func viewDidLoad() {
        super.viewDidLoad()
        //Search 設定
        let searchController = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchController
//        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        self.searchTableView.dataSource = self
        //Search View
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        searchController.searchBar.placeholder = NSLocalizedString("area and name", comment: "搜尋說明")
        searchController.searchBar.tintColor = UIColor(red: 255, green: 128, blue: 0)
        
        searchTableView.tableFooterView = UIView(frame: CGRect.zero)
    
        //Star DownLoadJSON
        self.queryFromServer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.searchTableView.reloadData()
        self.checkCoreDataRating()
    }
    
    //初次使用APP載入導覽畫面
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "Walkthrough") {
            return
        }
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughVC = storyboard.instantiateViewController(withIdentifier: "WalkthroughVC") as? WalkthroughVC {
            walkthroughVC.modalPresentationStyle = .fullScreen //全螢幕式
            present(walkthroughVC, animated: true, completion: nil)
        }
    }

    //MARK: - Search
    //過濾條件
    func filterContent(for searchText: String) {
        let text = searchText.replacingOccurrences(of: "台", with: "臺")
        
        searchDownload = downloadDatas[0].xmlHead.infos.info.filter { (info) -> Bool in
            let isMatch = info.add.localizedCaseInsensitiveContains(text) ||
                info.name.localizedCaseInsensitiveContains(text)
            return isMatch
        }
    }
    //搜尋功能三合一
//    func updateSearchResults(for searchController: UISearchController) {
//        if let searchText = searchController.searchBar.text {
//            filterContent(for: searchText)
//            searchTableView.reloadData()
//        }
//    }
    
    //按下搜尋時呼叫
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return  }
        filterContent(for: searchText)
        searchTableView.reloadData()
    }
    //User輸入文字時
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchDownload = []
        searchTableView.reloadData()
    }
    //點擊cancel時
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchDownload = []
        searchTableView.reloadData()
    }
    //MARK: - AlamoFrie JSON
    func queryFromServer() {
        KRProgressHUD.show()
        AF.request("https://gis.taiwan.net.tw/XMLReleaseALL_public/hotel_C_f.json").responseString { response in
            switch response.result {
            case .success( _):
                let decoder = JSONDecoder()
                if let data = response.data {
                    do {
                        let searchDatas = try decoder.decode(JSONDatas.self, from: data)
                        self.downloadDatas = [searchDatas]
                        KRProgressHUD.dismiss()
                        MyDatas.shared.allDataJSON = [searchDatas] //存singlten
                    } catch let e {
                        print("Couldn't Parse data because... \(e)")
                    }
                }
            case .failure(let error):
                AF.cancelAllRequests()
                KRProgressHUD.dismiss()
                print(error)
                let alert = UIAlertController(title: "", message: NSLocalizedString("error down", comment: ""), preferredStyle: .alert)
                let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }
//        AF.request("https://gis.taiwan.net.tw/XMLReleaseALL_public/hotel_C_f.json").responseJSON { (response) in
//            let decoder = JSONDecoder()
//            if let data = response.data {
//                do {
//                    let searchDatas = try decoder.decode(JSONDatas.self, from: data)
//                    self.downloadDatas = [searchDatas]
//                    KRProgressHUD.dismiss()
//                    MyDatas.shared.allDataJSON = [searchDatas] //存singlten
//                    self.checkCoreDataRating()
//                } catch {
//                    AF.cancelAllRequests()
//                    KRProgressHUD.dismiss()
//                    let alert = UIAlertController(title: "", message: "資料下載失敗，請確認您網路是否連線正常！", preferredStyle: .alert)
//                    let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
//                    alert.addAction(ok)
//                    self.present(alert, animated: true, completion: nil)
//                    return
//                }
//            }
//        }.resume()
    }
    //checkRating
    func checkCoreDataRating() {
        let moc = CoreDataHelper.shared.managedObjectContext()
        let fetchRequest = NSFetchRequest<InfoDescription>(entityName: "UserData")
        let predicate = NSPredicate(format: "rating = %@", "love")
        fetchRequest.predicate = predicate
        do {
            let results = try moc.fetch(fetchRequest)
            ratings = results
        } catch {
            assertionFailure("Core Data資料查詢失敗: \(error)")
        }
    }
    
    
    //MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchDownload.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! SearchTableViewCell
        let search = searchDownload
        
        cell.nameLabel?.text = "\(search[indexPath.row].name)"
        cell.addLabel?.text = search[indexPath.row].add
        
        if indexPath.row > 75  {
            let index = indexPath.row % 76
            cell.imageViewCell.image = thumbnailImage(str: MyDatas.shared.imageDatas[index])
        } else {
            cell.imageViewCell.image = thumbnailImage(str: MyDatas.shared.imageDatas[indexPath.row])
        }
        
//        for i in 0..<search.count {
//            for j in 0..<ratings.count {
//                if search[i].id == ratings[j].id {
//                    cell.imageLikeView.image = UIImage(named: ratings[j].rating!)
//                } else {
//                    cell.imageLikeView.image = .none
//                }
//            }
//        }
        
        if let rate = search[indexPath.row].rating {
            cell.imageLikeView.image = UIImage(named: rate)
        } else {
            cell.imageLikeView.image = .none
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showsearch" {
            if let indexPath  = self.searchTableView.indexPathForSelectedRow {
                let search = self.searchDownload[indexPath.row]
                
                if indexPath.row > 75 {
                    let index = indexPath.row % 76
                    let image = MyDatas.shared.imageDatas[index]
                    let searchDetailVC = segue.destination as! SearchDetailTableVC
                    searchDetailVC.detailVCimage = image
                    searchDetailVC.searchdetail = search
                    searchDetailVC.delegate = self
                } else {
                    let image = MyDatas.shared.imageDatas[indexPath.row]
                    let searchVC = segue.destination as! SearchDetailTableVC
                    searchVC.detailVCimage = image
                    searchVC.searchdetail = search
                    searchVC.delegate = self
                }
            }
        }
    }
    
    func didFinisUpdateRate(Rate: Info) {
        if let index = self.searchDownload.firstIndex(of: Rate) {
            searchDownload[index].rating = Rate.rating
            searchDownload[index].id = Rate.id
            let indexPath = IndexPath(row: index, section: 0)
            self.searchTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    
}

