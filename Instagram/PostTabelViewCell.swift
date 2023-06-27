//
//  PostTabelViewCell.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/26.
//

import UIKit
import FirebaseStorageUI //追加１０（２）

//追加１０　９までは投稿したデータがネットに保存されているって状況で、ここからはそのデータをアプリに読み込むって作業をする必要があるってこと

class PostTabelViewCell: UITableViewCell {

    //追加１０（１）UI部品各種初期配置実装
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
       
//------------ここから追加１０（２）
    //PostDataの内容をセルに表示
    //内容をセルに表示させるためにsetPostData(_:)メソッドを使う
    func setPostData(_ postData: PostData) {
        //画像を表示させて、
        //sd_imageIndicatorプロパティで、CloudStorageから画像をダウンロードしてるよっていうインディケーターを表示してくれる（ダウンロード中だよーってこと）今回はグレーのクルクルしたやつ
        //sd_setImage(with:)の引数にCloudStorageの画像保存場所を入れると自動的にダウンロードしてくれる
        postImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        postImageView.sd_setImage(with: imageRef)
        
        //キャプションも表示させて、
        self.captionLabel.text = "\(postData.name) : \(postData.caption)"
        //日時も表示させて、
        self.dateLabel.text = postData.date
        //いいね数も表示させて、
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        //いいねボタンも表示させる
        //自分がいいねしてれば赤いやつ、そうじゃなければ白いやつってこと
        //いいねされた時、画像を赤いやつに変更
        if postData.isLiked {
            //setImage(_:for:)で画像を変更できる
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
//------------ここまで追加１０（２）

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
