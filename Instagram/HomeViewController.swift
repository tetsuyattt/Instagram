//
//  HomeViewController.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/24.
//

import UIKit
import FirebaseAuth      //追加１１（３）
import FirebaseFirestore //追加１１（３）


//追加１１　 UITableViewDataSource, UITableViewDelegate
class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
   //追加１１
    var postArray: [PostData] = []
    
    //追加１１（３）Firebaseのデータ更新を監視するリスナー
    var listener: ListenerRegistration?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//---------------ここから追加１１（２）　投稿をホームテーブルに表示
        tableView.delegate = self
        tableView.dataSource = self
        
        //カスタムセルを登録する
        //xibファイルを読み込むためにUINib(nibName:bundle:)を使い、それをregister(_:forCellReuseIdentifier:)を用いて、カスタムセルを”Cell”identifierで登録する
        let nib = UINib(nibName: "PostTabelViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
    }
    
    //ーーーーーーーーーーーーーーーーーーーーここから追加１１（３）
    //投稿データを読み込む処理を実装
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        //ログイン済みか確認して、
        //現在のUserがnilでない時ってこと
        //descending=降順
        //ログイン状態を確認して、ログインしてる時だけ投稿データの読み込み（監視）をする
        if Auth.auth().currentUser != nil {
            //listenerを登録して投稿データの更新を監視して、（もしエラーがあったら何もしないで戻る）
            //postRefで、Firebaseのpostsに格納されている投稿データを投稿日時の新しい順位取得するクエリを作成して、addSnapshotListenerメソッドで読み込む
            let postRef = Firestore.firestore().collection(Const.PostPath).order(by: "date", descending: true)
            listener = postRef.addSnapshotListener() { (querySnapshot, error) in
                if let error = error {
                    print("DEBUG_PRINT: snapshotの取得が失敗しました。 \(error)")
                    return
                }
                //取得したdocumentを元にPostDataを作成し、postArrayの配列にして、
                //addSnapshotListenerに最新のデータが入ってて、documentsプロパティに一覧として存在し、PostDataの配列に変換してpostArrayに格納する
                //mapメソッドで配列の要素を変換して新しい配列を作成する。クロージャの引数（document）で変換元の配列要素を受け取り変換した要素をクロージャの戻り値（return postData）で配列を変換できる
                self.postArray = querySnapshot!.documents.map { document in
                    let postData = PostData(document: document)
                    print("DEBUG_PRINT: \(postData)")
                    return postData
                }
                    //TableViewの表示を更新する
                    self.tableView.reloadData()
            }
        }
    }
    
    //ホーム画面が閉じられる時に呼ばれるメソッド
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("DEBUG_PRINT: viewWillDisappear")
        
        //listenerを削除して監視を停止する
        listener?.remove()
        
    }
    //ーーーーーーーーーーーーーーーーーーーーここまで追加１１（３）
    
    //テーブル表示のために必須のdelegateメソッド2つ　→前やってる
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //dequeueReusableCellメソッドでセルを取得して、setPostDataメソッドでindexPathに対応するPostDataをセルに表示させてる
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTabelViewCell
        cell.setPostData(postArray[indexPath.row])
        
        //ーーーーー追加１２　いいねボタン処理　→次は99行目
        //セル内のボタンのアクションをソースコードで設定する
        //addTarget(_:action:for)メソッドが、control押しながら青い線で部品からアクション設定する時の代わり
        //selfはこのHomeViewController自身を呼び出し対象にしてる
        cell.likeButton.addTarget(self, action: #selector(handleButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
//---------------ここまで追加１１（２）　投稿をホームテーブルに表示
    
//ーーーーーーーーーここから追加１２（２）handleButton(_:forEvent:)メソッドを実装
    ////selector指定で呼び出されるメソッドは「@objc」をつける
    @objc func handleButton(_ sender:UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがクリックされました。")
        
        //タップされたセルのインデックスを求めて,
        let touch = event.allTouches?.first
           //location(in:)で、タッチされた座標が自身のtableViewの中がタッチされたと割り出す
        let point = touch!.location(in: self.tableView)
           //indexPathForRow(at:)で、tableView内のどのindexPath位置をタッチしたのか取得する
        let indexPath = tableView.indexPathForRow(at: point)
        
        //配列から、タップされたインデックスのデータを取り出して、
           //取得したindexPathを使って、postArray[indexPath!.row]で、タップしたセルの投稿データ（postData）を取得できる
        let postData = postArray[indexPath!.row]
        
        //「likes」を更新するために、
        if let myid = Auth.auth().currentUser?.uid {
            //更新データを作成するけど、
            var updataValue: FieldValue
            
            //もし、すでにいいねしている場合は、いいね解除のため、myidを取り除く更新データを作成して、
            if postData.isLiked {
                updataValue = FieldValue.arrayRemove([myid])
            } else {
                //また、今回新たにいいねをした場合は、myidを追加する更新データを作成して、
                updataValue = FieldValue.arrayUnion([myid])
            }
            //最後に、likesに更新データを書き込む
            let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
            postRef.updateData(["likes": updataValue])
        }
    }
//ーーーーーーーーーここまで追加１２（２）
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
