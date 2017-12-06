//
//  ApiManager.swift
//
//  Created by Molham Mahmoud on 25/04/16.
//  Copyright © 2016. All rights reserved.
//

import SwiftyJSON
import Alamofire

/// - Api store do all Networking stuff
///     - build server request 
///     - prepare params
///     - and add requests headers
///     - parse Json response to App data models
///     - parse error code to Server error object
///
class ApiManager: NSObject {

    typealias Payload = (MultipartFormData) -> Void
    
    /// frequent request headers
    var headers: HTTPHeaders{
        get{
            let httpHeaders = [
                "Authorization": ((DataStore.shared.me?.token) != nil) ? "JWT " + (DataStore.shared.me?.token)! : "",
                "Accept-Language": AppConfig.currentLanguage.langCode
            ]
            return httpHeaders
        }
    }
    
    let baseURL = "https://dev.alpha-apps.ae/warda/api/"
    let error_domain = "Wardah"
    
    //MARK: Shared Instance
    static let shared: ApiManager = ApiManager()
    
    private override init(){
        super.init()
    }    
   
    // MARK: Authorization

    /// User login request
    func userLogin(email: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)accounts/login"
        let parameters : [String : Any] = [
            "email": email,
            "password": password
        ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                 if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                 } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    /// User Signup request
    func userSignup(user: AppUser, password: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        // url & parameters
        guard password.length>0,
            let _ = user.email
            else {
                return
        }
        
        let signUpURL = "\(baseURL)accounts"
        
        var parameters : [String : String] = [
            "name": user.fullName!,
            "email": user.email!,
            "password": password,
            "mobile": user.mobile!,
            "address":user.address!,
            "city":user.city!,
            "state":user.state!
        ]
        
        if let bDate = user.birthday {
            let bDateString = DateHelper.getISOStringFromDate(bDate)
            parameters["dateOfBirth"] = bDateString!
        }
        // build request
        Alamofire.request(signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    /// User signup request
    func userSignUpWithImage(user: AppUser, password: String, image:UIImage?, completionBlock: @escaping (_ sucess: Bool, _ error: NSError?) -> Void) {
        
        guard password.length>0,
              let _ = user.email
        else {
            return
        }
        
        let signUpURL = "\(baseURL)accounts"
        
        var parameters : [String : Any] = [
            "firstName": user.firstName ?? "",
            "lastName": user.lastName ?? "",
            "email": user.email ?? "",
            "gender": user.gender ?? "",
            "password": password
            ]
        
        if let bDate = user.birthday {
            let bDateString = DateHelper.getISOStringFromDate(bDate)
            parameters["birthday"] = bDateString
        }
        
        let payload : Payload = { multipartFormData in
            
//            if let photo = image, let imageData = UIImageJPEGRepresentation(photo, 0.5){
//                multipartFormData.append(imageData, withName: sign_up_4_image, fileName: "file.png", mimeType: "image/png")
//            }
            
            for (key, value) in parameters{
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
            }}
        
        Alamofire.upload(multipartFormData: payload, to: signUpURL, method: .post, headers: nil,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                                upload.responseJSON { responseObject in
                                    //Request success
                                    if responseObject.result.isSuccess {
                                        let jsonResponse = JSON(responseObject.result.value!)
                                        if let _ = jsonResponse["error"].string {
                                            let errCode = jsonResponse["code"].intValue
                                            let errObj = NSError(domain: self.error_domain, code: errCode, userInfo: nil)
                                            completionBlock(false, errObj)
                                        } else {
                                            //parse user object and save it
                                            let user = AppUser(json: jsonResponse["user"])
                                            DataStore.shared.me = user
                                            completionBlock(true , nil)
                                        }
                                    }
                                    //Network error
                                    if responseObject.result.isFailure {
                                        let error : NSError = responseObject.result.error! as NSError
                                        completionBlock(false, error)
                                    }
                                }
                            case .failure(let encodingError):
                                completionBlock(false, encodingError as NSError?)
                            }
        })
    }
    
    /// Verify user using confirmation code
    func userVerify(code: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?, _ user:AppUser?) -> Void) {
        
        let signUpURL = "\(baseURL)auth/confirm_code"
        let parameters : [String : String] = [
            "code": code
        ]
        
        // build request
        Alamofire.request(signUpURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError, nil)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    completionBlock(true , nil, user)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError, nil)
                } else {
                    completionBlock(false, ServerError.connectionError, nil)
                }
            }
        }
    }
    
    func requestResendVerify(completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        
        let signUpURL = "\(baseURL)auth/resend_code"
        
        // build request
        Alamofire.request(signUpURL, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // MARK: Reset Password
    /// User forget password
    func forgetPassword(email: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)/accounts/reset"
        let parameters : [String : Any] = [
            "email": email,
        ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    /// Confirm forget password
    func confirmForgetPassword(email: String, code: String, password: String, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let signInURL = "\(baseURL)auth/confirm_forgot_password"
        let parameters : [String : Any] = [
            "email": email,
            "code": code,
            "password": password
            ]
        // build request
        Alamofire.request(signInURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    DataStore.shared.me = user
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // MARK: User
    /// Get current user information "me"
    func getUserMe(completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        let categoriesListURL = "\(baseURL)users/me"
        Alamofire.request(categoriesListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    // parse response to data model >> user object
                    let user = AppUser(json: jsonResponse["user"])
                    user.token = DataStore.shared.me?.token
                    DataStore.shared.me = user
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    /// Update user preferences
    func updateUserPreferences(completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let updatePreferencesURL = "\(baseURL)users/update_preferences"
        var categoriesArray = [String]()
        if let array: [Category] = DataStore.shared.me?.preferences?.categories {
            categoriesArray = array.map({ $0.id })
        }
        let parameters : [String : Any] = [
            "myCelebrities": NSNumber(value: DataStore.shared.me?.preferences?.isMyCelebrities ?? false),
            "categories": categoriesArray
            ]
        // build request
        Alamofire.request(updatePreferencesURL, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    // MARK: Categories
    /// Get full list of categories
    func getCategories(completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        let categoriesListURL = "\(baseURL)categories"
        Alamofire.request(categoriesListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
               // let resJson = JSON(responseObject.result.value!)
                
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    if let data = responseObject.result.value {
                        let categories: [Category] = Category.modelsFromDictionaryArray(array: data as! NSArray)
                        // save to cache
                        DataStore.shared.categories = categories
                    }
                    completionBlock(true, nil)
                }
            }
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    
    
    /// Get feature
    func getFeature(completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        let featureListURL = "\(baseURL)products/featured"
        Alamofire.request(featureListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    if let data = responseObject.result.value {
                        let feature = Product.modelsFromDictionaryArray(array: data as! NSArray)
                        // save to cache
                        DataStore.shared.featureProducts = feature
                    }
                    completionBlock(true, nil)
                }
            }
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    
    
    
    /// Get Category products
    func getProducts(category:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        let productsListURL = "\(baseURL)/categories/\(category)/products"
        AppConfig.currentProuductList = AppProductsList.normal
        Alamofire.request(productsListURL, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                //let resJson = JSON(responseObject.result.value!)
                
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    if let data = responseObject.result.value {
                        let products: [Product] = Product.modelsFromDictionaryArray(array: data as! NSArray)
                        // save to cache
                        
                        DataStore.shared.products = products
                    }
                    completionBlock(true, nil)
                }
            }
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    
    /// Get  products by name for autocomplete
    
    func getProductsBy(name:String,completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        let productsListURL = "\(baseURL)/products?filter={\"where\":{\"title\":{\"like\":\"%\(name)%\"}}}".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        AppConfig.currentProuductList = AppProductsList.searching
        Alamofire.request(productsListURL!, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    if let data = responseObject.result.value {
                        let products: [Product] = Product.modelsFromDictionaryArray(array: data as! NSArray)
                        // save to cache
                        
                        DataStore.shared.searchProducts = products
                    }
                    completionBlock(true, nil)
                }
            }
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
    
    
 
    // MARK: Posts
    /// Get page of home stories
    func getStories(lastId: String, completionBlock: @escaping (_ success: Bool, _ isMoreData:Bool? , _ error: ServerError?) -> Void) {
        let url = "\(baseURL)stories?last_id=\(lastId)"
        Alamofire.request(url, method: .get, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let resJson = JSON(responseObject.result.value!)
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false, nil, serverError)
                } else if let data = resJson["stories"].array, data.count > 0 {
                    let stories: [Story] = data.map{Story(json: $0)}
                    if lastId.isEmpty {
                        // save stories to cache
                        DataStore.shared.stories = stories
                    } else {
                        DataStore.shared.stories.append(contentsOf: stories)
                    }
                    completionBlock(true, stories.count > 0 , nil)
                } else {
                    completionBlock(true, false, nil)
                }
            }
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, true, ServerError.unknownError)
                } else {
                    completionBlock(false, true, ServerError.connectionError)
                }
            }
        }
    }
    
    /// Update user preferences
    func likePost(post: Post, completionBlock: @escaping (_ success: Bool, _ error: ServerError?) -> Void) {
        // url & parameters
        let likePostURL = "\(baseURL)posts/\(post.id)/like"
        // build request
        Alamofire.request(likePostURL, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { (responseObject) -> Void in
            if responseObject.result.isSuccess {
                let jsonResponse = JSON(responseObject.result.value!)
                if let code = responseObject.response?.statusCode, code >= 400 {
                    let serverError = ServerError(json: jsonResponse) ?? ServerError.unknownError
                    completionBlock(false , serverError)
                } else {
                    completionBlock(true , nil)
                }
            }
            // Network error request time out or server error with no payload
            if responseObject.result.isFailure {
                if let code = responseObject.response?.statusCode, code >= 400 {
                    completionBlock(false, ServerError.unknownError)
                } else {
                    completionBlock(false, ServerError.connectionError)
                }
            }
        }
    }
}

/**
 Server error represents custome errors types from back end
 */
struct ServerError {
    
    static let errorCodeConnection = 50
    
    public var errorName:String?
    public var status: Int?
    public var code:Int!
    
    public var type:ErrorType {
        get{
            return ErrorType(rawValue: code) ?? .unknown
        }
    }
    
    /// Server erros codes meaning according to backend
    enum ErrorType:Int {
        case connection = 50
        case unknown = -111
        case authorization = 900
        case alreadyExists = 101
        case socialLoginFailed = -110
		case notRegistred = 102
        case missingInputData = 104
        case expiredVerifyCode = 107
        case invalidVerifyCode = 108
        case userNotFound = 109
        
        /// Handle generic error messages
        /// **Warning:** it is not localized string
        var errorMessage:String {
            switch(self) {
                case .unknown:
                    return "ERROR_UNKNOWN".localized
                case .connection:
                    return "ERROR_NO_CONNECTION".localized
                case .authorization:
                    return "ERROR_NOT_AUTHORIZED".localized
                case .alreadyExists:
                    return "ERROR_SIGNUP_EMAIL_EXISTS".localized
				case .notRegistred:
                    return "ERROR_SIGNIN_WRONG_CREDIST".localized
                case .missingInputData:
                    return "ERROR_MISSING_INPUT_DATA".localized
                case .expiredVerifyCode:
                    return "ERROR_EXPIRED_VERIFY_CODE".localized
                case .invalidVerifyCode:
                    return "ERROR_INVALID_VERIFY_CODE".localized
                case .userNotFound:
                    return "ERROR_RESET_WRONG_EMAIL".localized
                default:
                    return "ERROR_UNKNOWN".localized
            }
        }
    }
    
    public static var connectionError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.connection.rawValue
            return error
        }
    }
    
    public static var unknownError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.unknown.rawValue
            return error
        }
    }
    
    public static var socialLoginError: ServerError{
        get {
            var error = ServerError()
            error.code = ErrorType.socialLoginFailed.rawValue
            return error
        }
    }
    
    public init() {
    }
    
    public init?(json: JSON) {
        guard let errorCode = json["code"].int else {
            return nil
        }
        code = errorCode
        if let errorString = json["error"].string{ errorName = errorString}
        if let statusCode = json["status"].int{ status = statusCode}
    }
}


