//
//  Const.swift
//  Instagram
//
//  Created by 富樫　哲也 on 2023/06/26.
//

//追加９（３）Firebase関連の定数を別ファイルに記述する アプリ全体で使うから、一箇所にまとめとくといいよ
//「static let」として宣言すれば、構造体を生成しなくてもあとで「Const.PostPath」のような記述で値を得られるようになる
import Foundation

//---------ここから追加９（３）
struct Const {
    static let ImagePath = "images" //画像の保存先をFirebaseのimagesフォルダに指定してる
    static let PostPath = "posts"   //投稿データの保存先をFirebaseのpostsフォルダに指定してる
}
//---------ここまで追加９（３）
//「ImagePath」=Strage内の画像の保存場所を定義してる
//「PostPath」＝Firebase内の投稿データ（投稿者名、キャプション（見出しのこと）、投稿日時など）の保存場所を定義してる
