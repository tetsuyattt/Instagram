//
//  PostViewController.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/24.
//

import UIKit
import FirebaseAuth //追加９
import FirebaseFirestore//追加９
import FirebaseStorage //追加９
import SVProgressHUD //追加９


class PostViewController: UIViewController {
    
    var image: UIImage!//追加９（２）
    
//追加９　投稿画面初期配置
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //追加９（２）受け取った画像をimageViewに貼り付ける
        imageView.image = image
    }
    
    //--------ここから追加９(4)　投稿ボタンを押したら・・・
    @IBAction func handlePostButton(_ sender: Any) {
        //画像をjpag形式に変換して、
        //「jpegData()」で変換できる。「compressionQuality」で圧縮できる
        let imageData = image.jpegData(compressionQuality: 0.75)
        //画像と投稿データの保存場所を定義して、
        //postRef=Firebaseの保存場所
        //Const.PostPathは追加９（３）で書いたConstのやつ
        let postRef = Firestore.firestore().collection(Const.PostPath).document()
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postRef.documentID + ".jpg")    //どの投稿の画像か紐付けてる
        //その間に、HUDで投稿処理中であることを表示（ちょっと待っててねーってこと）
        SVProgressHUD.show()
        //Strageに画像をアップロードして、
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        imageRef.putData(imageData!, metadata: metadata) { (metadata,error) in
            //アップロードが成功すれば、error引数はnilになる
            //エラーの時は、
            //「!=」これって、等しくない時ってことじゃないっけ
            if error != nil {
                //画像のアップロード失敗させて、
                print(error!)
                SVProgressHUD.showError(withStatus: "画像のアップロードが失敗しました")
                //投稿処理をキャンセルして先頭画面に戻る
                //PostViewController（今の画面）はTabBar→ImageSelect→CLImageEditor→今の画面とモーダル遷移してきたから、全部一気に閉じる方法を実装↓
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
                return
            }
            //エラーなければ、Firebaseに投稿データを保存する
            //投稿データのFirebase保存って、ここしかないんだよな。。。
            //でも、いいねみたいに、投稿者のFieldに保存されるようにするには？
            let name = Auth.auth().currentUser?.displayName
            let postDic = [
                "name": name!,
                "caption": self.textField.text!,
                "date": FieldValue.serverTimestamp(),
            ] as [String : Any]
            postRef.setData(postDic)
            //HUDで投稿完了を表示して、
            SVProgressHUD.showSuccess(withStatus: "投稿しました")
            //投稿処理が完了したら、先頭画面に戻る
            self.view.window?.rootViewController?.dismiss(animated: true,completion: nil)
        }
        //--------ここまで追加９(4)
        
    }
    //追加９　キャンセルボタン
    //追加９（４）戦闘画面じゃなく、画像加工画面に戻って追加編集できるようにする
    @IBAction func handleCancelButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
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
