# FitBit-Auth

The Fitbit API allows developers to interact with Fitbit data in their own applications, products and services.
The API allows for most of the read and write methods that you will need to support your application. If you have uses or needs that are not currently supported by the API, drop by the Dev Forum and let us know! We look forward to working closely with the development community to make the Fitbit API a system that enables you to do awesome, mind blowing stuff.

You can fetch fitbit data in your health app , please follow following procedure.

1. Resister your application in fit bit developer account https://dev.fitbit.com/apps/new
2. Copy Client Id and consumer_secret , It will be used in your Application.
3. Download FitBit-Auth-for-iOS from https://github.com/msyshani/FitBit-Auth-for-iOS
4. Drag and drop MSYFitBit.swift in your application.
5. Dard and drop OAuthSwift files in your project.
6.  In AppDelegate
7.  
     func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
         if (url.host == "oauth-callback") {
              OAuthSwift.handleOpenURL(url)
          }
         return true
     }

8. In Your ViewController
9. 
       MSYFitBit.shareFitBit.fetchDataFromFitbit { (result, success) -> Void in
            
        }
