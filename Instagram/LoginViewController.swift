//
//  LoginViewController.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/24.
//

import UIKit
import FirebaseAuth //追加３ログイン画面
import SVProgressHUD //追加４　SceneDelegateより　HUD実装

class LoginViewController: UIViewController {
    
    //ここから追加３ログイン画面設定
    @IBOutlet weak var mailAddressTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var displayNameTextField: UITextField!
    //ここまで追加３ログイン画面設定
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //追加３ログイン画面設定
    //ログインボタンが押された時の処理
    @IBAction func handleLoginButton(_ sender: Any) {
        if let address = mailAddressTextField.text, let password = passwordTextField.text {
            
            //アドレスとパスワードの両方入力されていなければダメ
            if address.isEmpty || password.isEmpty {
                //追加４（２）　HUD実装
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //追加４（２）　HUDで「処理中であること」を表示
            SVProgressHUD.show()
            
            
            Auth.auth().signIn(withEmail: address, password: password) { authResult, error in
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription)
                    //追加４（２）　HUDで表示
                    SVProgressHUD.showError(withStatus: "サインインに失敗しました。")
                    return
                }
                print("DEBUG_PRINT: ログインに成功しました。")
                
                //追加４（２）　HUDを消す処理
                SVProgressHUD.dismiss()
                
                //画面を閉じてタブ画面に戻る
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    //追加３ログイン画面設定
    //アカウント作成ボタンが押された時の処理
    @IBAction func handleCreateAccountButton(_ sender: Any) {
        //追加３アカウント作成の実装
        if let address = mailAddressTextField.text, let password = passwordTextField.text, let displayName = displayNameTextField.text {
            
            //アドレス、パスワード、表示名の中で1つでも入力されていなければ　→何もしない（returnでメソッドを抜ける）
            //全ての欄の入力を必須としてる
            if address.isEmpty || password.isEmpty || displayName.isEmpty {
                print("DEBUG_PRINT: 何かが空文字です。")
                
                //追加４（２）　HUD実装
                SVProgressHUD.showError(withStatus: "必要項目を入力してください")
                return
            }
            
            //追加４（２）　HUDで「処理中であること」を表示
            SVProgressHUD.show()
            
            //アドレスとパスワードでユーザー作成。作成に成功すると自動的にログインする
            //withEmail:(第１引数)、password：（第２引数）、{completion:(第３引数)←authResultのやつ全部　}
            //第２引数で受け取ったerrorがnilであれば、アカウント作成が成功したと意味する
            Auth.auth().createUser(withEmail: address, password: password) { authResult, error in
                //エラーがあったら原因をprintして、returnすることで以降の処理を実行せずに処理を終了する
                if let error = error {
                    print("DEBUG_PRINT: " + error.localizedDescription )
                    
                    
                    //追加４（２）　HUDで表示
                    SVProgressHUD.showError(withStatus: "ユーザー作成に失敗しました。")
                    
                    return
                }
                print("DEBUG_PRINT: ユーザー作成に成功しました。")
                
//            }　←前はここにこれがあって、アカウント作成時にHUDが止まらず、設定画面の表示名も出てこなかったけど、消して下記の「print("createUser終わり")」の前に置いたらできた。（メンタリング時アドバイスのおかげ）
                //表示名の設定
                //上のcreateUser()メソッドのクロージャ内でアカウント作成の成功を確認したら、次は表示名（displayName）の設定をする
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            //プロフィールの更新でエラーが発生した時
                            print("DEBUG_PRINT: " + error.localizedDescription)
                            
                            //追加４（２）　HUDで表示
                            SVProgressHUD.showError(withStatus: "表示名の設定に失敗しました。")
                            return
                        }
                        print("DEBUG_PRINT: [displayName = \(user.displayName!)]の作成に成功しました。")
                        
                        //HUDを消す
                        SVProgressHUD.dismiss()
                        
                        //画面を閉じてタブ画面に戻る
                        //dismiss=解散　→モーダル遷移で作成したviewControllerを除去する的な意味
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            print("createUser終わり")
        }
        
    }


    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
