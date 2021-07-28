//
//  GDriveManager.swift
//  HelloMyGDriveManager
//
//  Created by student43 on 2020/11/16.
//

import Foundation
import GoogleAPIClientForREST
import GTMSessionFetcher

class GDriveManager{
    
    private let drive = GTLRDriveService()
    
    static let shared = GDriveManager()
    private init(){
        
    }
    
    func setAuthorizer(authorizer:GTMFetcherAuthorizationProtocol){
        drive.authorizer = authorizer
    }
    
    func uploadfile(url:URL, name: String, mimeType: String, description: String,completion:GTLRServiceCompletionHandler?){
        //prepare GTLRDrive_File.
        let file = GTLRDrive_File()
        file.name = name
        file.descriptionProperty = description
        file.mimeType = mimeType
        //        file.originalFilename = ....//原始檔名
        
        //prepare parameters and query.
        let parameters = GTLRUploadParameters(fileURL: url, mimeType: mimeType)
        let query = GTLRDriveQuery_FilesCreate.query(withObject: file, uploadParameters: parameters)
        
        //Execute query.
        drive.executeQuery(query, completionHandler: completion)
    }
    
    func downloadFileList(completion: GTLRServiceCompletionHandler?) {
        drive.shouldFetchNextPages = true  //回報資料時不要分頁 (ex:如資料僅最多顯示20筆，分頁時才載入)
        let query = GTLRDriveQuery_FilesList.query()
        //        query.q = "..." 以q來應用其他功能
        drive.executeQuery(query, completionHandler: completion)
    }
    
    func deleteFile(by identifier: String,completion: GTLRServiceCompletionHandler?){
        let query = GTLRDriveQuery_FilesDelete.query(withFileId: identifier)
        drive.executeQuery(query, completionHandler: completion)
    }
    
    func dowbloadFile(by identifier: String,completion: GTMSessionFetcherCompletionHandler?){
        let urlString = String(format:"https://www.googleapis.com/drive/v2/files/\(identifier)?alt=media")
        let fetcher = drive.fetcherService.fetcher(withURLString: urlString)
        
        fetcher.beginFetch(completionHandler: completion)
    }
    
    
}
