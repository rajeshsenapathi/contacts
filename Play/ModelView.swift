//
//  ModelView.swift
//  Play
//
//  Created by Rajesh Senapathi on 18/05/1400 AP.
//

import Foundation

class jsonParser: NSObject{
    
static let shared = jsonParser()
    var reloadTableView: (()->())?
    var jsonObj : [WelcomeElement]?

    var setViewModel : [dataModel]? = [dataModel](){
    
        willSet{
            DispatchQueue.main.async { [weak self] in
                self?.reloadTableView?()
                
            }
        }
    }
    func parser(){
        APIservice.shared.makeServiceCall(method: HttpMethod.GET, url: "https://jsonplaceholder.typicode.com/todos") { [weak self] result in
            switch result{
            case .success(let x):
                self?.setcellconfig(datas: x)
                DispatchQueue.main.async {
                    self?.reloadTableView?()
                }
            case .failure(let err):
                
                print(err.localizedDescription)
                
           }
        }
    }
    
    var numofcells : Int? {
        return self.jsonObj?.count ?? 0
        
    }
    
    func configurecell(indexpath :IndexPath) -> dataModel {
        guard let _ = self.setViewModel?.count,self.setViewModel!.count > 0 else { return dataModel.init(userID: 0, id: 0, title: "") }
        
        return setViewModel?[indexpath.row] ?? dataModel(userID: 0, id: 0, title: "")

    }
    
    func setcellconfig(datas: [WelcomeElement]){
        
        jsonObj = datas
        
        var vm = [dataModel]()
        
            for data in datas{
                vm.append(dataModel(userID: data.userID, id: data.id, title: data.title))
            }
            setViewModel = vm
        
    }
    
}
struct dataModel {
    
        let userID, id: Int
        let title: String
}
