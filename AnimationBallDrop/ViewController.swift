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
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            let vc = BallDropVC()
            vc.ballTotal = 15
            vc.delayBetweenBallsInput = 0.4
            vc.dropDurationInput = 4
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
    }
}
