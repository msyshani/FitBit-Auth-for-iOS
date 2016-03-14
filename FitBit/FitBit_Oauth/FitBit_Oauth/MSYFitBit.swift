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
    
    
    var parameter = [String: String]()
    var accessToken:String?
    
    let group:dispatch_group_t=dispatch_group_create()
    
    // completion handler
    typealias fitBitBlockType = (result:Dictionary<String , AnyObject>,success:Bool) ->Void
    var completionFitBit:fitBitBlockType?
    
    
    
    class var shareFitBit: MSYFitBit{
        struct Static {
            static var once_token:dispatch_once_t = 0
            static var instance:MSYFitBit? = nil
        }
        dispatch_once(&Static.once_token){
            Static.instance = MSYFitBit()
        }
        return Static.instance!
    }
    
    
    
    
    func fetchDataFromFitbit(completion: (result: Dictionary<String , AnyObject>, success:Bool) -> Void){
        
        completionFitBit = completion
        
        let token=NSUserDefaults.standardUserDefaults().valueForKey("Atoken") //as String
        
        
        if let currentAccessToken=token {
            print(currentAccessToken)
            callDispatch()
            
        }else{
            self.doOAuthFitbit2({ (success) -> Void in
                if success {
                    
                    self.callDispatch()
                    
                }else{
                    
                }
            })
            return
        }
    }
    
    
   
    func callDispatch(){
        dispatch_group_enter(group)
           self.getHeartRateFitbit2(self.oauthswift)
        
        
        dispatch_group_enter(group)
           self.getActicityFitbit2(self.oauthswift)
        
        
        dispatch_group_enter(group)
           self.getWeightFitbit2(self.oauthswift)
        
        dispatch_group_enter(group)
        self.getStepFitbit2(self.oauthswift)
        
        dispatch_group_notify(group, dispatch_get_main_queue(), {
            self.completionFitBit!(result: Dictionary(), success: true)
        })
    }
    
    
    
    func doOAuthFitbit2(completion: (success:Bool) -> Void) {
        oauthswift.accessTokenBasicAuthentification = true
        let state: String = generateStateWithLength(20) as String
        oauthswift.authorizeWithCallbackURL( NSURL(string: "fivedotsFitbit://")!, scope: "profile activity heartrate weight nutrition location", state: state, success: {
            credential, response, parameters in
            //print("credential is \(credential)")
            //print("response is \(response)")
            print("parameters is \(parameters)")
            self.parameter=parameters;
            self.accessToken=parameters["access_token"]
            print(self.accessToken)
            NSUserDefaults.standardUserDefaults().setValue(self.accessToken, forKey: "Atoken")
            
           completion(success: true)
            
            
            }, failure: { error in
                print(error.localizedDescription)
                completion(success: false)
        })
    }
    
    func getProfielFitbit2(oauthswift: OAuth2Swift) {
        let token=NSUserDefaults.standardUserDefaults().valueForKey("Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/profile.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            print(jsonDict)
            }) { (error) -> Void in
                print(error.localizedDescription)
                self.showALertWithTag(999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    func getActicityFitbit2(oauthswift: OAuth2Swift) {
        
        
        
        let token=NSUserDefaults.standardUserDefaults().valueForKey("Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/activities/list.json?offset=2&limit=5&sort=desc&beforeDate=2016-03-13", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
               let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                print(jsonDict)
                dispatch_group_leave(self.group);
            
            }) { (error) -> Void in
                print(error.localizedDescription)
                self.showALertWithTag(999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
     }
    
    
    
    
    func getStepFitbit2(oauthswift: OAuth2Swift) {
       
        let token=NSUserDefaults.standardUserDefaults().valueForKey("Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/activities/steps/date/2016-03-03/1m.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
            let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
            print(jsonDict)
            dispatch_group_leave(self.group);
            
            }) { (error) -> Void in
                print(error.localizedDescription)
                self.showALertWithTag(999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    
    func getWeightFitbit2(oauthswift: OAuth2Swift) {
       
        
        let token=NSUserDefaults.standardUserDefaults().valueForKey("Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        //header=["Authorization":"Bearer " + token]
        oauthswift.client.request("https://api.fitbit.com/1/user/-/body/log/weight/date/2016-03-13/1m.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
                let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                print(jsonDict)
                dispatch_group_leave(self.group);
            }) { (error) -> Void in
                print(error.localizedDescription)
                self.showALertWithTag(999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    func getHeartRateFitbit2(oauthswift: OAuth2Swift) {
      
        
        let token=NSUserDefaults.standardUserDefaults().valueForKey("Atoken") //as String
        let header=["Authorization":"Bearer "+(token as! String)]
        
        
        oauthswift.client.request("https://api.fitbit.com/1/user/-/activities/heart/date/2016-03-13/1m.json", method: .GET, parameters: [:], headers: header, success: { (data, response) -> Void in
                 let jsonDict: AnyObject! = try? NSJSONSerialization.JSONObjectWithData(data, options: [])
                 print(jsonDict)
                 dispatch_group_leave(self.group);
            }) { (error) -> Void in
                 print(error.localizedDescription)
                 self.showALertWithTag(999, title: "error.....", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "OK", otherButtonTitle: nil)
        }
    }
    
    
    
    //MARK: AlertView
     func showALertWithTag(tag:Int, title:String, message:String?,delegate:AnyObject!, cancelButtonTitle:String?, otherButtonTitle:String?)
    {
        let alert = UIAlertView()
        
        alert.tag = tag
        alert.title = title
        alert.message = message
        alert.delegate = delegate
        if (cancelButtonTitle != nil)
        {
            alert.addButtonWithTitle(cancelButtonTitle!)
        }
        if (otherButtonTitle != nil)
        {
            alert.addButtonWithTitle(otherButtonTitle!)
        }
        
        alert.show()
    }

    
    
}


