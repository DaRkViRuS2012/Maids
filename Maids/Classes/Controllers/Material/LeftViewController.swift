/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material
import SafariServices
import SCLAlertView
import Alamofire

struct Item {
    var text: String
    var imageName: String
    var badge : String
}

protocol LeftViewControllerDelegate {

    func refresh()

}

class LeftViewController: UIViewController ,SFSafariViewControllerDelegate{
    fileprivate var transitionButton: FlatButton!
    
    
    
    let userDefulat = UserDefaults.standard
    var safariVC:SFSafariViewController?
    let cellid = "leftDrowerCell"
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        safariVC?.delegate = self
        view.backgroundColor = Color.blue.base
        prepareView()
        prepareCells()
        prepareTableView()
        //prepareTransitionButton()
    }
    
    
    let tableView: UITableView = UITableView()
    
    /// A list of all the navigation items.
    var items: Array<Item> = Array<Item>()
    
    let nameLabel: UILabel = UILabel()
    let emailLabel: UILabel = UILabel()
    let imageView:UIImageView = UIImageView()
    
    func showView(VC:UIViewController) {
        navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        /*
         The dimensions of the view will not be updated by the side navigation
         until the view appears, so loading a dyanimc width is better done here.
         The user will not see this, as it is hidden, by the drawer being closed
         when launching the app. There are other strategies to mitigate from this.
         This is one approach that works nicely here.
         */
        
        prepareProfileView()
        prepareNotification()
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        prepareCells()
        
    }
    
    func prepareNotification(){
    
       NotificationCenter.default.addObserver(self, selector: #selector(prepareCells), name: Notification.Name("refresh"), object: nil)
    
    }
    
    
    
    /// General preparation statements.
    private func prepareView() {
        view.backgroundColor =  UIColor(red: 63/255, green: 168/255, blue: 193/255, alpha: 1) //Color.grey.darken4
        prepareCells()
    }
    
    /// Prepares the items that are displayed within the tableView.
     @objc private func prepareCells() {
        items.removeAll()
        
        let msgNum = Globals.messegesNum
        
        items.append(Item(text: NSLocalizedString("My Messages", comment: ""), imageName: "ic_place_white",badge:msgNum))
     //   items.append(Item(text: NSLocalizedString("My Notifications", comment: ""), imageName: "ic_place_white",badge:"0"))
        items.append(Item(text: NSLocalizedString("My Prescriptions", comment: ""), imageName: "ic_place_white",badge:"0"))
        items.append(Item(text: NSLocalizedString("About", comment: ""), imageName: "ic_place_white",badge:"0"))
        items.append(Item(text: NSLocalizedString("Contact Us", comment: ""), imageName: "ic_place_white",badge:"0"))
        items.append(Item(text: NSLocalizedString("Log Out", comment: "") , imageName: "ic_today",badge:"0"))
        tableView.reloadData()
    }
    
    /// Prepares profile view.
    private func prepareProfileView() {
        let backgroundView: View = View()
        backgroundView.image = UIImage(named: "MaterialBackground")
        
        let profileView: View = View()
        profileView.contentMode = .scaleAspectFit
        profileView.image = UIImage(named: "logo")
        profileView.backgroundColor = Color.clear
//        profileView.shapePreset = .circle
        profileView.borderColor = Color.white
        profileView.borderWidth = 0
//        profileView
        
        
        imageView.image = UIImage(named: "profileBG")
        
        emailLabel.textAlignment = .center

        emailLabel.textColor = Color.white
        nameLabel.font = RobotoFont.medium(with:13)
        
        nameLabel.textAlignment = .center
        nameLabel.textColor = Color.white
        nameLabel.font = RobotoFont.medium(with:12)
        
        if let name = Globals.user?.user?.name {
            nameLabel.text = name
        }
        
        if let email = Globals.user?.user?.mail{
            emailLabel.text = email
        }
        view.layout(imageView).top(0).left(0).right(0).height(175).centerHorizontally()
        view.layout(profileView).width(90).height(90).top(30).centerHorizontally()
        view.layout(nameLabel).top(120).left(20).right(20)
        view.layout(emailLabel).top(135).left(20).right(20)
        
    }
    
    /// Prepares the tableView.
    private func prepareTableView() {
        let nib = UINib(nibName: cellid, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: cellid)
        //self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        self.tableView.backgroundColor = Color.clear
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorStyle = .none
        
        // Use Layout to easily align the tableView.
        view.layout(tableView).edges(top: 170)
    }
    
}


extension LeftViewController {
    @objc
 
    
    fileprivate func closeNavigationDrawer(result: Bool) {
        if UIApplication.isRTL(){
            navigationDrawerController?.closeLeftView()
        
        }else{
        
        navigationDrawerController?.closeRightView()
        }
    }
    
    
    
    
}


extension LeftViewController: UITableViewDataSource {
    @available(iOS 2.0, *)
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: leftDrowerCell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! leftDrowerCell
        
        let item: Item = items[indexPath.row]
        
        cell.titleLbl.text = item.text
        cell.badgeNum = item.badge
        cell.titleLbl!.textColor = Color.grey.lighten2
        cell.titleLbl!.font = RobotoFont.medium
//        cell.imageView!.image = UIImage(named: item.imageName)?.withRenderingMode(.alwaysTemplate)
//        cell.imageView!.tintColor = Color.grey.lighten2
        cell.backgroundColor = Color.clear
        
        return cell
    }
    
    /// Determines the number of rows in the tableView.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
}

/// UITableViewDelegate methods.
extension LeftViewController: UITableViewDelegate {
    /// Sets the tableView cell height.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    
    func transitionToViewController(viewController:UIViewController){
        
        (navigationDrawerController?.rootViewController as? UINavigationController)?.pushViewController(viewController, animated: true)
        closeDrawer()
    }
    
    
    func show(viewController:UIViewController){
        closeDrawer()
        let vc = UINavigationController(rootViewController: viewController)
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func showAlert(title:String,msg:String,style:SCLAlertViewStyle){
        
        SCLAlertView().showTitle(
            title, // Title of view
            subTitle: msg, // String of view
            duration: 0.0, // Duration to show before closing automatically, default: 0.0
            completeText: "OK", // Optional button value, default: ""
            style: style, // Styles - see below.
            colorStyle: 0x54BEC0,
            colorTextButton: 0xFFFFFF
        )
        
    }
    
    func closeDrawer(){
        if (UIApplication.isRTL()){
            navigationDrawerController?.toggleRightView()
        }else{
            navigationDrawerController?.toggleLeftView()
            
        }
    
    }
    
    
    func switchLang(){
    
        var transition: UIViewAnimationOptions = .transitionFlipFromLeft
        if L102Language.currentAppleLanguage() == "en" {
            L102Language.setAppleLAnguageTo(lang: "ar")
           UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            L102Language.setAppleLAnguageTo(lang: "en")
            transition = .transitionFlipFromRight
           UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        restart(transition: transition)
   
       // showAlert(title: "", msg: "Restart the app to make changes", style: .info)
            }
    
    func restart(transition:UIViewAnimationOptions){
    
        let homeViewController = HomeViewController()
        if(!UIApplication.isRTL()){
            let vc = AppNavigationDrawerController(rootViewController: UINavigationController(rootViewController: homeViewController), leftViewController: LeftViewController(), rightViewController: nil)
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = vc
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.55001, options: transition, animations: { () -> Void in
            }) { (finished) -> Void in
                
            }        }
        else
        {
            
            let vc = AppNavigationDrawerController(rootViewController: UINavigationController(rootViewController: homeViewController), leftViewController: nil, rightViewController: LeftViewController())
            
            let rootviewcontroller: UIWindow = ((UIApplication.shared.delegate?.window)!)!
            rootviewcontroller.rootViewController = vc
            let mainwindow = (UIApplication.shared.delegate?.window!)!
            mainwindow.backgroundColor = UIColor(hue: 0.6477, saturation: 0.6314, brightness: 0.6077, alpha: 0.8)
            UIView.transition(with: mainwindow, duration: 0.55001, options: transition, animations: { () -> Void in
            }) { (finished) -> Void in
                
            }
        }
    
        
     
    
    }
    
    
    func removeToken(){
    
     //￼￼http://shefaaonline.net/api/push_notifications/%7Btoken%7D
    
        let fcmtok = Globals.fcmtoken
    
        
        
        let url = Globals.baseUrl + "/api/push_notifications/\(fcmtok)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        print(url)
        
        Alamofire.request(url,method:.delete).responseJSON { response in
            print(response.response)
            switch response.result{
            case .success:
                if let JSON = response.result.value {
                    print("JSON: \(JSON)")
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
        
    }
    
    func openWeb(url:String){
        
       
        
        safariVC = SFSafariViewController(url: NSURL(string: url)! as URL)
        self.present(safariVC!, animated: true, completion: nil)
    }
    
    
    func handleLogout(){
    
        Globals.user = nil
        Globals.isLogedin = false
        userDefulat.removeObject(forKey: "user")
        userDefulat.removeObject(forKey: "pass")
        
        removeToken()
        self.dismiss(animated: true, completion: nil)
        
    }
    /// Select item at row in tableView.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //   showView(LoginViewController())
        
        switch (indexPath.row){
        
        case 0 :
           transitionToViewController(viewController: MessagesViewController())
            
        case 1:
            transitionToViewController(viewController: PrescriptionsViewController())
        case 4:
            handleLogout()
            break
        case 2 :
//            switchLang()
            //UIApplication.shared.openURL(URL(string:"http://shefaaonline.net/about-us")!)
            openWeb(url: "http://shefaaonline.net/about-us")
            break
        case 3 :
            openWeb(url: "http://shefaaonline.net/contact-us")
            //UIApplication.shared.openURL(URL(string:"http://shefaaonline.net/contact-us")!)
            break
        default:
            print(indexPath.row)
        }
        
        
    }
    
}

