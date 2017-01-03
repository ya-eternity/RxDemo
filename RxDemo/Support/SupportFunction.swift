//
//  SupportFunction.swift
//  RxDemo
//
//  Created by bmxd-002 on 16/11/23.
//  Copyright © 2016年 Zoey. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

#if DEBUG
let host = "https://stg-rxswift.leanapp.cn"
#else
let host = "https://rxswift.leanapp.cn"
#endif

struct Alert {
    
    static func showInfo(title: String, message: String? = nil) {
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default) { _ in })
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
    
    
}

extension UIApplication {
    
    class func topViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
