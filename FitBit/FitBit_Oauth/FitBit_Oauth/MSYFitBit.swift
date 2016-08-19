//
//  MSYFitBit.swift
//  fbLogin
//
//  Created by Mahendra Yadav on 2/10/16.
//  Copyright © 2016 Appstudioz. All rights reserved.
//

import UIKit


let fitbit_clientID=""
let fitbit_consumer_secret=""
let fitbit_redirect_uri="fivedotsFitbit://"


class MSYFitBit: NSObject {
    
    let oauthswift = OAuth2Swift(
        consumerKey:    fitbit_clientID, //serviceParameters["consumerKey"]!,
        consumerSecret: fitbit_consumer_secret,
        authorizeUrl:   "https://www.fitbit.com/oauth2/authorize",
        accessTokenUrl: "https://api.fitbit.com/oauth2/token",
        responseType:   "token"
    )
    
    
    var parameter = [String: AnyObject?]()
    var accessToken:String?
    
    let group = DispatchGroup()
    
    // completion handler
    typealias fitBitBlockType = (_ result: Dictionary<String , AnyObject>, _ success:Bool) -> Void
    var completionFitBit:fitBitBlockType?
    
    
    
    // the swift way of defining singletons
    
    static let shareFitBit = MSYFitBit()
    private override init() {}

    
    // This stackoverflow link explains the rationale of using @escaping before the closure http://stackoverflow.com/questions/38990882/closure-use-of-non-escaping-parameter-may-allow-it-to-escape
    
    func fetchDataFromFitbit(completion: @escaping (_ result: Dictionary<String , AnyObject>, _ success:Bool) -> Void){
        
        completionFitBit = completion
        
        let token=UserDefaults.standard.value(forKey: "Atoken") //as String
        
        
        if let currentAccessToken=token {
            print(currentAccessToken)
            callDispatch()
            
        }else{
            self.doOAuthFitbit2(completion: { (success) -> Void in
                if success {
                    
                    self.callDispatch()
                    
                }else{

                }
            })
            return
        }
    }
    
    
    
    func callDispatch(){
        group.enter()
        self.getHeartRateFitbit2(oauthswift: self.oauthswift)
        
        
        group.enter()
        self.getActivityFitbit2(oauthswift: self.oauthswift)
        
        
        group.enter()
        self.getWeightFitbit2(oauthswift: self.oauthswift)
        
        group.enter()
        self.getStepFitbit2(oauthswift: self.oauthswift)
        
        
        group.notify(queue: DispatchQueue.main) {
            self.completionFitBit!(Dictionary(), true)
            
        }
        
    }
    
    
    
    func doOAuthFitbit2(completion: @escaping (_ success:Bool) -> Void) {
        oauthswift.accessTokenBasicAuthentification = true
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "fivedotsFitbit://") as! URL, scope: "profile activity heartrate weight nutrition location", state: state, success: {
            credential, response, parameters in
            //print("credential is \(credential)")
            //print("response is \(response)")
            print("parameters is \(parameters)")
            self.parameter=parameters as [String: AnyObject?]
            self.accessToken=parameters["access_token"] as? String
            print(self.accessToken)
            UserDefaults.standard.setValue(self.accessToken, forKey: "Atoken")
            
            completion(true)
            
            
            }, failure: { error in
                print(error.localizedDescription)
                completion(false)
        })
    }
    
    func getProfileFitbit2(oauthswift: OAuth2Swift) {
        let token=UserDefaults.standard.value(forKey: "Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/profile.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: [])
            print(jsonDict)
        }) { (error) -> Void in
            print(error.localizedDescription)
            self.showALertWithTag(tag: 999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    func getActivityFitbit2(oauthswift: OAuth2Swift) {
        
        
        
        let token=UserDefaults.standard.value(forKey: "Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/activities/list.json?offset=2&limit=5&sort=desc&beforeDate=2016-03-13", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: [])
            print(jsonDict)
            self.group.leave()
            
        }) { (error) -> Void in
            print(error.localizedDescription)
            self.showALertWithTag(tag: 999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    
    
    func getStepFitbit2(oauthswift: OAuth2Swift) {
        
        let token=UserDefaults.standard.value(forKey: "Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/activities/steps/date/2016-03-03/1m.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: [])
            print(jsonDict)
            self.group.leave()
            
        }) { (error) -> Void in
            print(error.localizedDescription)
            self.showALertWithTag(tag: 999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    
    func getWeightFitbit2(oauthswift: OAuth2Swift) {
        
        
        let token=UserDefaults.standard.value(forKey: "Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/body/log/weight/date/2016-03-13/1m.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: [])
            print(jsonDict)
            self.group.leave()
        }) { (error) -> Void in
            print(error.localizedDescription)
            self.showALertWithTag(tag: 999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    func getHeartRateFitbit2(oauthswift: OAuth2Swift) {
        
        
        let token=UserDefaults.standard.value(forKey: "Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        oauthswift.client.request("https://api.fitbit.com/1/user/-/activities/heart/date/2016-03-13/1m.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict = try? JSONSerialization.jsonObject(with: data, options: [])
            print(jsonDict)
            self.group.leave()
        }) { (error) -> Void in
            print(error.localizedDescription)
            self.showALertWithTag(tag: 999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    
    //MARK: AlertView - deprecated in iOS 9
    func showALertWithTag(tag:Int, title:String, message:String?,delegate:AnyObject!, cancelButtonTitle:String?, otherButtonTitle:String?)
    {
        let alert = UIAlertView()
        
        alert.tag = tag
        alert.title = title
        alert.message = message
        alert.delegate = delegate
        if (cancelButtonTitle != nil)
        {
            alert.addButton(withTitle: cancelButtonTitle!)
        }
        if (otherButtonTitle != nil)
        {
            alert.addButton(withTitle: otherButtonTitle!)
        }
        
        alert.show()
    }
    
    
    
}
