//
//  TabBarController.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/24.
//

import UIKit

class TabBarController: UITabBarController,UITabBarControllerDelegate {
//追加１UITabBarControllerDelegate追加
    //TabBarControllerはUITabBarControllerを継承し、UITabBarControllerDelegateに準拠するように宣言している
    
    
    //viewDidLoadメソッドないで初期化処理
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //------------ここから追加１タブバーの設定
        //
        //タブアイコンの色
        self.tabBar.tintColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        //タブバーの背景色設定
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        self.tabBar.standardAppearance = appearance
        self.tabBar.scrollEdgeAppearance = appearance
        //UITabBarControllerDelegateプロトコルのメソッドをこのクラスで処理する
        //↓deledateメソッドの呼び出し先をこのクラスにする
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    //タブバーのアイコンがタップされた時に呼ばれるdelegateメソッドを処理
    //第２引数（viewController）に切り替え先のviewControllerインスタンスがあり、if~で切り替え先がImageSelectViewControllerだったら（カメラボタンが押されたら）、instantiateViewController（withIdentifier:)メソッドでImageSelectViewControllerを読み込み、present(_:animated:complettion:)メソッドでモーダル遷移するようにする
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is ImageSelectViewController {
            //↓ImageSelectViewControllerは、タブ切り替えじゃなくモーダル遷移するって処理
            let imageSelectViewController = storyboard!.instantiateViewController(withIdentifier: "ImageSelect")
            present(imageSelectViewController, animated: true)
            return false
        } else {
            //↓その他のViewControllerは通常なタブ切り替えを実施する
            return true
        }
    }
    //------------ここまで追加１タブバーの設定
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
