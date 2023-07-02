//
//  commentViewController.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/28.
//

//追加４　課題　コメントする時にcommentViewControllerにモーダル遷移させる
//ここ全部追加

import UIKit
import FirebaseAuth
import FirebaseFirestore
import SVProgressHUD

class commentViewController: UIViewController {
    
    //遷移で持ってくるデータを受け取るやつ
    //チャットGPTに聞いた
    //var postData: [PostData] = []　←前こうだった
    var postData: PostData?
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func commentPostButton(_ sender: Any) {
        
        let postData = postData
        //「likes」を更新するためのやつ参考に
        
//        if let myid = Auth.auth().currentUser?.uid {
//
//            //updataValue使ってないんだけど、これなくてもいけるの？　→いけそう
//            //myidもいらないかも。。。
//            var updataValue: FieldValue
//            updataValue = FieldValue.arrayUnion([myid])
            
            //postDataの後ろに「！」入れたらできた（チャットGPTすご）
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData!.id)
            
            //名前表示させたい
            let commenter = Auth.auth().currentUser?.displayName
            
            //投稿する時こうやってたけど、upDateDataで使ってない・・・→解決
            //「コメントをこういう形でFirebaseに保存してね」的な感じ
            //「commenter!」にしたらいけたすげえ
            
//            let postDic = ["\(commenter!): \(self.commentTextField.text!)"]
            // ↓上の[]を消したら表示されるコメントの["〇〇"]なくなった
            let postDic = "\(commenter!): \(self.commentTextField.text!)"

            print("PRINT: コメントView：postDic= \(postDic)")//→表示されるok
            
//            postRef.updateData(["comment": updataValue])//"comment"フィールドがなかったら追加して、　　←いらない
            postRef.updateData(["comment":FieldValue.arrayUnion(["\(postDic)"])])
        //"comment"フィールドがなかったら追加して、"comment"の内容も追加する
            
            print("PRINT: コメントView：postDic２= \(postDic)")// →表示されるok

//            postRef.setData(postDic) →これはあかん、投稿が上位のドキュメントに追加される
//        }
    
        //HUDで投稿完了を表示して、
        SVProgressHUD.showSuccess(withStatus: "コメントしました")
        //投稿処理が完了したら、先頭画面に戻る
        self.view.window?.rootViewController?.dismiss(animated: true,completion: nil)
        
    }
        
            @IBAction func commentCancelButton(_ sender: Any) {
                self.dismiss(animated: true,completion: nil)
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
