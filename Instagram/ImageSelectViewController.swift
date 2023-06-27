//
//  ImageSelectViewController.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/24.
//

import UIKit
import CLImageEditor //追加８　画像加工画面実装


//追加６　UIImagePickerControllerDelegate, UINavigationControllerDelegate
//追加８ CLImageEditorDelegate
class ImageSelectViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLImageEditorDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    //追加６ライブラリボタン
    @IBAction func handleLibraryButton(_ sender: Any) {
        //追加６（２）デバイスがフォトライブラリへのアクセスをサポートしている場合に、ユーザーにフォトライブラリから画像を選択するためのピッカーコントローラーを表示する
        //ライブラリ（カメラロール）を指定してピッカーを開く
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        //completionにはピッカーコントローラーの表示が完了した後に実行する必要があるコード（クロージャ）を指定するが、この例では何も指定しない。←チャットGPTより
        }
    }
    //追加６カメラボタン
    @IBAction func handleCameraButton(_ sender: Any) {
        //追加６（２）ライブラリボタンのを「.camera」にした
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let pickerController = UIImagePickerController()
            pickerController.delegate = self
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    //追加６キャンセルボタン
    @IBAction func handleCancelButton(_ sender: Any) {
        //追加６　画面を閉じる処理
        self.dismiss(animated: true, completion: nil)
    }
    
//ーーーーーーーーーここから追加７　UIImagePickerControllerを使う　写真選択した時
    //写真を撮影／選択した時に呼ばれるメソッド
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //まず、UIImagepickerController画面を閉じる
        picker.dismiss(animated: true, completion: nil)
        //撮影/選択した画像はinfo[.originalImage]で取得
        //画像加工処理
        if info[.originalImage] != nil {
            //撮影／選択された画像を取得する
            let image = info[.originalImage] as! UIImage
            
            //あとでCLImageEditorライブラリで加工する　→追加８(２）へ
            print("DEBUG_PRINT: image = \(image)")
            //---------ここから追加８（２）　なんとなくわかる
            //CLImageEditorにimageを渡して、画像加工画面を起動する
            let editor = CLImageEditor(image: image)!
            editor.delegate = self
            self.present(editor, animated: true, completion: nil)
            //---------ここまで追加８（２）
        }
    }
    //ーーーーーーーーーここから追加８（３）CLImageEditorで加工が終わった時に呼ばれるメソッド
    func imageEditor(_ editor: CLImageEditor!, didFinishEditingWith image: UIImage!) {
        //投稿画面を開くようにする
        let postViewController = self.storyboard!.instantiateViewController(withIdentifier: "Post") as! PostViewController
        postViewController.image = image!
        editor.present(postViewController, animated: true, completion: nil)
    }
    //CLImageEditorの編集がキャンセルされた時に呼ばれるメソッド
    func imageEditorDidCancel(_ editor: CLImageEditor!) {
        //CLImageEditorの画面を閉じる
        editor.dismiss(animated: true, completion: nil)
    }
    //ーーーーーーーーーここまで追加８（３）
    
    //UIImagePickeController画面内でキャンセルボタンが押された時、
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //UIImagePickeController画面を閉じる
        picker.dismiss(animated: true, completion: nil)
    }
//ーーーーーーーーーここまで追加７　写真選択した時

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
