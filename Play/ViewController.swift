//
//  ViewController.swift
//  Play
//
//  Created by Rajesh Senapathi on 18/05/1400 AP.
//

import UIKit
import Foundation
import CoreXLSX
import Contacts
import ContactsUI

struct Contact {
    let name: String
    let mobileNumber: String
}
class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    var columnAstrings:[String]?
    let phArry = NSMutableArray()
    var contacts = PhoneContact()
    var contactDict: [String: String] = [:]
    var store  = CNContactStore()
    var nameArry = [String]()
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var filteredArray : [dataModel]?
    var issearching :Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let filepath = Bundle.main.path(forResource: "Book", ofType: "xlsx") else{return}
        guard let file = XLSXFile(filepath: filepath) else {
          fatalError("XLSX file at \(filepath) is corrupted or does not exist")
        }
        do {
        for path in try file.parseWorksheetPaths() {
            let emptystringarray = NSMutableArray()
            let ws = try file.parseWorksheet(at: path)
            for row in ws.data?.rows ?? [] {
                if row.cells.count < 2{
                    for c in row.cells{
                        let colomn = c.reference.column.value
                        if colomn == "B"{
                            emptystringarray.add("1001")
                        }
                    }
              }
                for c in row.cells{
                    let colomn = c.reference.column.value
                    if colomn == "A"{
                        emptystringarray.add(c.value ?? "")
                    }
                }
            }
            let items :[String] = emptystringarray as! [String]
            let indexes = items.enumerated().filter({$0.element == "1001"}).map({$0.offset})
            
            if let sharedStrings = try file.parseSharedStrings() {
                columnAstrings = ws.cells(atColumns: [ColumnReference("A")!])
                    .compactMap { $0.stringValue(sharedStrings) }
            }
            for value in indexes{
                columnAstrings?.insert("abcd", at: value)
            }
            for row in ws.data?.rows ?? [] {
                for c in row.cells{
                if row.cells.count < 2{
                    let colomn = c.reference.column.value
                    if colomn == "B"{
                        phArry.add("123456")
                        continue
                    }
                    }
                }
                    for c in row.cells{
                        let colomn = c.reference.column.value
                        if colomn == "B"{
                           phArry.add(c.value ?? "")
                        }
                    }
            }
        }
            
        }
        
        catch{
                
            }
        searchbar.delegate = self
        tableView.delegate = self
        tableView.dataSource  = self
        jsonParser.shared.parser()
        jsonParser.shared.reloadTableView = {
        DispatchQueue.main.async {
            self.tableView.reloadData() }
        }
        addConrtactstoIphoneContacts()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if issearching{
            return  filteredArray?.count ?? 0
        }
        else{
            return jsonParser.shared.numofcells ?? 0
        }
        
    }
    func addConrtactstoIphoneContacts(){
        for (index, element) in columnAstrings!.enumerated() {
            let phoneelemen = phArry[index] as? String
            let count = phoneelemen?.count
            if index == 0 || count! < 10  || (element == "abcd" && ((phArry[index]) as! String).count  < 10)  {
                continue
            }
            else{
                contactDict[element] = phArry[index] as? String
            }
            }
        
        for (key,value) in contactDict{
            
            let some = Contact(name: (key), mobileNumber: (value))
            if isContactExistsInContactStore(contactMobilenumber: some.mobileNumber) == true {
               print("existed")
        }
                else{
                    saveContact(name: some.name, phonenumber: some.mobileNumber)

                        }
            }
        
        
        }
    func isContactExistsInContactStore(contactMobilenumber: String) -> Bool{
        var iscontactexists = false
        let some = getContactsfFromStore()
        var FlattenArray = [String]()
        for value in some{
            let somme = value.withoutPunctuations.filter({$0 != " "})
            FlattenArray.append(somme)
        }
        if FlattenArray.contains(contactMobilenumber)
          {
            iscontactexists = true
        }
            else{
                iscontactexists = false
            }
        
        return iscontactexists
    }
    
    func saveContact(name :String,phonenumber: String){
        let newContact = CNMutableContact()
        newContact.givenName = name
        if newContact.givenName == "abcd"{
            newContact.givenName = ""
        }
        newContact.phoneNumbers.append(CNLabeledValue(
                    label: "mobile", value: CNPhoneNumber(stringValue: phonenumber)))
        
            let saveRequest = CNSaveRequest()
            saveRequest.add(newContact, toContainerWithIdentifier: nil)
            do {
                try store.execute(saveRequest)
            } catch {
                print("Saving contact failed, error: \(error)")
            }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
     guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as? TableViewCell else{ return UITableViewCell()}
        let count = filteredArray?.count
        if issearching{
            guard let count  = count,count > 0 else{return UITableViewCell()}
            cell.idLabel.text = String(describing: filteredArray![indexPath.row].id)
            cell.emailLabel.text = String(describing: filteredArray![indexPath.row].userID)
            cell.usernameLabel.text = filteredArray?[indexPath.row].title
        }
        else{
            cell.loadWithViewModel(indexpath: indexPath)

        }
        cell.selectionStyle = .none
        
        return  cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        issearching = true

        if issearching == true {
            filteredArray = jsonParser.shared.setViewModel?.filter({ arr in
                return arr.title.lowercased().contains(searchText.lowercased())
        })
        }

        if searchText == "" || issearching == false{
            issearching = false
            filteredArray  = nil
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    
    func getContactsfFromStore() -> [String]{
        var phonenumberArry =  [String]()
        let contactStore = CNContactStore()
        var contacts = [CNContact]()
        let keys = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                        CNContactPhoneNumbersKey,
                        CNContactEmailAddressesKey
                ] as [Any]
        let request = CNContactFetchRequest(keysToFetch: keys as! [CNKeyDescriptor])
        do {
            try contactStore.enumerateContacts(with: request){
                    (contact, stop) in
                // Array containing all unified contacts from everywhere
                contacts.append(contact)
                for phoneNumber in contact.phoneNumbers {
                let number = phoneNumber.value
                    phonenumberArry.append(number.stringValue)
                    self.nameArry.append(contact.givenName)
                }
            }

        } catch {
            print("unable to fetch contacts")
        }
        return phonenumberArry
    }
    
}
extension String {
  var withoutPunctuations: String {
    return self.components(separatedBy: CharacterSet.punctuationCharacters).joined(separator: "")
  }
}
