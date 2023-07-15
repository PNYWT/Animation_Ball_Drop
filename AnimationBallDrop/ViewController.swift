//
//  ViewController.swift
//  AnimationBallDrop
//
//  Created by CallmeOni on 13/7/2566 BE.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .blue
        
    }
    @IBAction func actionOpenBallDrop(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            let vc = BallDropVC()
            vc.ballTotal = 30
            vc.totalAnimationDuration = 15
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
    }
}
