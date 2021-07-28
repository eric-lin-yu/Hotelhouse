//  Created by 則佑林 on 2020/12/15.
//

import CoreData
struct JSONDatas: Codable {
    let xmlHead: XMLHead

      enum CodingKeys: String, CodingKey {
          case xmlHead = "XML_Head"
      }
}

// MARK: - XMLHead
struct XMLHead: Codable {
    var listname: String
    var language: String
    var orgname: String
    var updatetime: String
    var infos: Infos

    enum CodingKeys: String, CodingKey {
        case listname = "Listname"
        case language = "Language"
        case orgname = "Orgname"
        case updatetime = "Updatetime"
        case infos = "Infos"
    }
}

// MARK: - Infos
struct Infos: Codable {
    var info: [Info]

    enum CodingKeys: String, CodingKey {
        case info = "Info"
    }
}
struct Info: Codable, Equatable {
    static func == (lhs: Info, rhs: Info) -> Bool {
        return lhs.id == rhs.id
    }
    var id: String
    var name: String
    var infoDescription: String
    var add: String
    var town: String?
    var region: String?
    var tel: String
    var website: String
    var px: Double
    var py: Double
    var spec: String?
    var rating: String?
    enum CodingKeys: String, CodingKey {
        case id = "Id"
        case name = "Name"
        case infoDescription = "Description"
        case add = "Add"
        case town = "Town"
        case region = "Region"
        case tel = "Tel"
        case website = "Website"
        case px = "Px"
        case py = "Py"
        case spec = "Spec"
    }
    


}

