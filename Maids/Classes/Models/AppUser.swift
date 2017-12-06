//
//  User.swift
//  Wardah
//
//  Created by Dania on 6/12/17.
//  Copyright © 2017 BrainSocket. All rights reserved.
//

import SwiftyJSON

// MARK: Gender types
enum GenderType: String {
    case male = "male"
    case female = "female"
}

// MARK: User account type
enum AccountType: String {
    case normal = "normal"
    case celebrity = "celebrity"
}

// MARK: User login type
enum LoginType: String {
    case rombeye = "rombeye"
    case facebook = "facebook"
    case twitter = "twitter"
    case instagram = "instagram"
    /// check current login state (Social - Normal)
    var isSocial:Bool {
        switch self {
        case .rombeye:
            return false
        default:
            return true
        }
    }
}

class AppUser: BaseModel {
    // MARK: Keys
    private let kUserFirstNameKey = "firstName"
    private let kUserLastNameKey = "lastName"
    private let kUserEmailKey = "email"
    private let kUserProfilePicKey = "avatar"
    private let kUserBirthdayKey = "birthday"
    private let kUserGenderKey = "gender"
    private let kUserCountryKey = "country"
    private let kUserFollowingCountKey = "followingCount"
    private let kUserFollowersCountKey = "followersCount"
    private let kUserCategoriesKey = "categories"
    private let kUserLoginTypeKey = "loginType"
    private let kUserAccountTypeKey = "type"
    private let kUserIsVerifiedKey = "isVerified"
    private let kUserTokenKey = "token"
    private let kUserPreferencesKey = "preferences"
    // MARK: Properties
    public var firstName: String?
    public var lastName: String?
    public var email: String?
    public var profilePic: String?
    public var birthday: Date?
    public var gender: GenderType?
    public var country: String?
    public var followingCount: Int?
    public var followersCount: Int?
    public var categories: [Category]?
    public var loginType: LoginType?
    public var accountType: AccountType?
    public var isVerified: Bool?
    public var token: String?
    public var preferences: Preferences?
    public var mobile:String?
    public var address:String?
    public var city:String?
    public var state:String?
    public var fullName:String?
    
    // user full name
//    public var fullName: String {
//        if let fName = firstName, !fName.isEmpty {
//            if let lName = lastName, !lName.isEmpty {
//                return  fName + " " + lName
//            }
//            return fName
//        }
//        return lastName ?? ""
//    }
    
    // MARK: User initializer
    public override init(){
        super.init()
    }
    
    public required init(json: JSON) {
        super.init(json: json)
        firstName = json[kUserFirstNameKey].string
        lastName = json[kUserLastNameKey].string
        email = json[kUserEmailKey].string
        profilePic = json[kUserProfilePicKey].string
        if let dateString = json[kUserBirthdayKey].string {
            birthday = DateHelper.getDateFromISOString(dateString)
        }
        if let genderString = json[kUserGenderKey].string {
            gender = GenderType(rawValue: genderString)
        }
        country = json[kUserCountryKey].string
        followingCount = json[kUserFollowingCountKey].intValue
        followersCount = json[kUserFollowersCountKey].intValue
        if let categoriesJsonArr = json[kUserCategoriesKey].array {
            categories = categoriesJsonArr.map{Category(json:$0)}
        }
        loginType = .rombeye
        if let loginTypeString = json[kUserLoginTypeKey].string {
            loginType = LoginType(rawValue: loginTypeString)
        }
        accountType = .normal
        if let accountTypeString = json[kUserAccountTypeKey].string {
            accountType = AccountType(rawValue: accountTypeString)
        }
        isVerified = json[kUserIsVerifiedKey].boolValue
        token = json[kUserTokenKey].string
        if (json[kUserPreferencesKey] != JSON.null) {
            preferences = Preferences(json: json[kUserPreferencesKey])
        }
    }
    
    public override func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = super.dictionaryRepresentation()
        // first name
        if let value = firstName {
            dictionary[kUserFirstNameKey] = value
        }
        // last name
        if let value = lastName {
            dictionary[kUserLastNameKey] = value
        }
        // email
        if let value = email {
            dictionary[kUserEmailKey] = value
        }
        // profile picture
        if let value = profilePic {
            dictionary[kUserProfilePicKey] = value
        }
        // birthday
        if let value = birthday {
            dictionary[kUserBirthdayKey] = DateHelper.getISOStringFromDate(value)
        }
        // gender
        if let value = gender?.rawValue {
            dictionary[kUserGenderKey] = value
        }
        // country
        if let value = country {
            dictionary[kUserCountryKey] = value
        }
        // following count
        if let value = followingCount {
            dictionary[kUserFollowingCountKey] = value
        }
        // followers count
        if let value = followersCount {
            dictionary[kUserFollowersCountKey] = value
        }
        // categories
        if let array: [Category] = categories {
            let categoriesDictionaries : [[String:Any]] = array.map{$0.dictionaryRepresentation()}
            dictionary[kUserCategoriesKey] = categoriesDictionaries
        }
        // login type
        if let value = loginType?.rawValue {
            dictionary[kUserLoginTypeKey] = value
        }
        // account type
        if let value = accountType?.rawValue {
            dictionary[kUserAccountTypeKey] = value
        }
        // is verified
        if let value = isVerified {
            dictionary[kUserIsVerifiedKey] = value
        }
        // token
        if let value = token {
            dictionary[kUserTokenKey] = value
        }
        // preferences
        if let value = preferences {
            dictionary[kUserPreferencesKey] = value.dictionaryRepresentation()
        }
        return dictionary
    }
    
}
