//
//  SettingViewController.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/24.
//

import UIKit
import FirebaseAuth //追加５（２）
import SVProgressHUD //追加５（２）

class SettingViewController: UIViewController {

    //追加５　設定（表示名変更）

    @IBOutlet weak var displayNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //ここから追加５（２）　表示名を取得してTextFieldに設定する
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
    }
    //ここまで追加５（２）　表示名を取得してTextFieldに設定する
    

    //追加５　設定（表示名変更ボタンを押した時の処理）
    @IBAction func handleChangeButton(_ sender: Any) {
    //-------------ここから追加５（３）表示名変更コード
        if let displayName = displayNameTextField.text {
            //表示名が入力されていない時はHUDを出して、何もしない（return）
            if displayName.isEmpty {
                SVProgressHUD.showError(withStatus: "表示名を入力してください")
                return
            }
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges { error in
                    if let error = error {
                        SVProgressHUD.showError(withStatus: "表示名の更新に失敗しました。")
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        return
                    }
                    print("DEBUG_PRINT: [displayName = \(user.displayName!)]の設定に成功しました。")
                    
                    //HUDで完了したことを知らせる
                    SVProgressHUD.showSuccess(withStatus: "表示名を変更しました")
                }
            }
        }
        //キーボードを閉じる
        self.view.endEditing(true)
    }
    //-------------ここまで追加５（３）表示名変更コード
    
    //追加５　設定（ログアウトボタンを押した時の処理）
    //Firebaseのログアウト処理を行い、ログアウト後はLoginViewControllerクラス（ログイン画面）を起動時と同様にモーダルとして表示させる
    @IBAction func handleLogoutButton(_ sender: Any) {
    //-------------ここから追加５（４）ログアウト処理実装
        //ログアウトして、
        try! Auth.auth().signOut()
        //ログイン画面表示して、
        //instantiate=インスタンス化する
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        //ログイン画面から戻ってきた時のために、ホーム画面（indez=0）を選択している状態にしておく
        //tabBarControllerのselectedIndexを０にすることで、一番左のホーム画面に切り替えておく
        tabBarController?.selectedIndex = 0
    }
    //-------------ここまで追加５（４）ログアウト処理実装
    
 
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
