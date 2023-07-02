//
//  PostData.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/26.
//

//全て追加１０
import UIKit
import FirebaseAuth
import FirebaseFirestore

class PostData: NSObject {
    var id = ""
    var name = ""
    var caption = ""
    var comment = "" //追加２　課題　コメント実装
    var date = ""
    var likes: [String] = []
    var isLiked: Bool = false
    
    
    init(document: QueryDocumentSnapshot) {
        self.id = document.documentID
        
        let postDic = document.data()
        
        if let name = postDic["name"] as? String {
            self.name = name
        }
        
        if let caption = postDic["caption"] as? String {
            self.caption = caption
        }
        
//        if let comment = postDic["comment"] as? String {
//            self.comment = comment
//        }↑元々こうだった
        
        //チャットGPTから、"comment"の形式を変えるよう指示あり　→今まで上のやつだった時はコメントが表示されなかったけど、変えたら表示された
        //保存したのは配列になっているが、読み込もうとしてるのは文字列だから読み込めないんじゃねってことだった　→すげえよほんと
        //joinedでやったら全部のコメントが表示された！すげえ！
        if let commentArray = postDic["comment"] as? [String] {
            self.comment = commentArray.joined(separator: "\n")
        }

        
        if let timestamp = postDic["date"] as? Timestamp {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.date = formatter.string(from: timestamp.dateValue())
        }
        
        if let likes = postDic["likes"] as? [String] {
            self.likes = likes
        }
        
        if let myid = Auth.auth().currentUser?.uid {
            //likesの配列の中にmyidが含まれてるかチェックすることで、自分がいいねを押してるか確認して、
            if self.likes.firstIndex(of: myid) != nil {
                //myidがあれば、いいねを押していると判断する
                self.isLiked = true
            }
        }
    }
    
    //追加２　課題「comment\(comment);」入力（デバッグ用、とのこと）
    override var description: String {
        return "PostData: name=\(name); caption=\(caption); comment\(comment); date=\(date); likes=\(likes); id=\(id);"
    }
    
}
