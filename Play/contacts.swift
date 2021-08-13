//
//  contacts.swift
//  Play
//
//  Created by Rajesh Senapathi on 21/05/1400 AP.
//

import Foundation
import ContactsUI

class PhoneContact: NSObject {

    var name: String?
    var avatarData: Data?
    var phoneNumber: [String] = [String]()
    var email: [String] = [String]()
    var isSelected: Bool = false
    var isInvited = false

    init(contact: CNContact) {
        name        = contact.givenName + " " + contact.familyName
        for phone in contact.phoneNumbers {
            phoneNumber.append(phone.value.stringValue)
        }
        
    }

    override init() {
        super.init()
    }
    

}

