//
//  CommentViewController.swift
//  Instagram
//
//  Created by yasu on 2020/04/18.
//  Copyright © 2020 tmyasu0131. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {
    
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var commentImage: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var postData: PostData!//課題追加
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画像の表示
        //commentImage.sd_imageIndicator = SDWebImageActivityIndicator.gray
        let imageRef = Storage.storage().reference().child(Const.ImagePath).child(postData.id + ".jpg")
        commentImage.sd_setImage(with: imageRef)
        
        // キャプションの表示
        self.commentLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func commentPostButton(_ sender: Any) {
        
        // HUDで投稿処理中の表示を開始
        SVProgressHUD.show()

        // commenter を 取り出す
        let commenter = Auth.auth().currentUser?.displayName
        // 更新データを作成する
        var commentValue: FieldValue
        commentValue = FieldValue.arrayUnion(["\(commenter!): \(commentTextField.text!)\n"])
        // commentに更新データを書き込む
        let postRef = Firestore.firestore().collection(Const.PostPath).document(postData.id)
        postRef.updateData(["comments": commentValue])
        
        
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        // 投稿処理が完了したので先頭画面に戻る
        UIApplication.shared.windows.first{ $0.isKeyWindow }?.rootViewController?.dismiss(animated: true, completion: nil)

    }
    
    @IBAction func commentCancelButton(_ sender: Any) {
        // 加工画面に戻る
        self.dismiss(animated: true, completion: nil)
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
