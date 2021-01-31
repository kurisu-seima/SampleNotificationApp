//
//  ViewController.swift
//  SampleNotificationApp
//
//  Created by 栗須星舞 on 2021/01/28.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myTextField: UITextField!
    
    var count = 0
    var numString = ""
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myLabel.text = String(count)
        myTextField.text = numString
       
        //最初の画面のみオブザーバになる
        if count == 0 {
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification(_:)), name: ViewController.notificationName, object: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        myTextField.text = numString
    }
    
    @IBAction func nextButtonDidTapped(_ sender: Any) {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "myVC") as! ViewController
        if let text = myTextField.text, var counting = Int(myLabel.text!) {
            nextVC.numString = text
            counting += 1
            nextVC.count = counting
        }
        
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        guard let viewController = presentingViewController as? ViewController, let text = myTextField.text else {
            return
        }
        viewController.numString = text
    }
    
    @IBAction func rootButtonDidTapped(_ sender: Any) {
        post()
    }
    
    //ポストする
    func post() {
        NotificationCenter.default.post(name: ViewController.notificationName, object: myTextField.text)
    }
    
    //通知を受け取った際に実行する
    @objc func handleNotification(_ notification: Notification) {
        self.dismiss(animated: true, completion: nil)
        if let text = notification.object as? String {
            numString = text
        } else {
            numString = ""
        }
    }
}

//通知を設定
extension ViewController {
    static let notificationName = Notification.Name("CloseNotification")
}
