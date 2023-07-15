//
//  BallDropVC.swift
//  AnimationBallDrop
//
//  Created by CallmeOni on 13/7/2566 BE.
//

import UIKit

class BallView: UIView {
    var tapAction: (() -> Void)?
    private var animator: UIViewPropertyAnimator?
    
    var imageBall = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGesture()
        configureAppearance()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureGesture()
        configureAppearance()
    }
    
    private func configureGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ballTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }
    
    private func configureAppearance() {
        backgroundColor = .red
        layer.cornerRadius = frame.width / 2
        
        /*
        imageBall = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        imageBall.backgroundColor = .clear
        imageBall.layer.cornerRadius = frame.width / 2
        imageBall.image = UIImage(named: "BallImage_0")
        self.addSubview(imageBall)
         */
    }
    
    @objc private func ballTapped() {
        tapAction?()
    }
    
    func startFalling(duration: TimeInterval, maxWidth: CGFloat, delay: TimeInterval) {
        let randomX = CGFloat.random(in: 0...(maxWidth - frame.width))
        frame.origin.x = randomX
        
        animator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.center.y = UIScreen.main.bounds.height + self.frame.height
        }
        animator?.startAnimation(afterDelay: delay)
    }
    
    func stopFalling() {
        animator?.stopAnimation(true)
    }
}

class BallDropVC: UIViewController {
    
    private var ballCount = 0
    private var ballsArr = [BallView]()
    private var dropDurationInput = 4.0 //ระยะเวลาที่ลูกบอลตก
    private var delayBetweenBallsInput = 0.0 //ความถี่ระหว่างลูกบอลที่จะตก
    
    var ballTotal = 0  //จำนวนบอลทั้งหมด
    var totalAnimationDuration:Double = 0.0 //เวลาทั้งหมด
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .gray.withAlphaComponent(0.4)
        DispatchQueue.main.asyncAfter(deadline: .now()+1.5) {
            self.createBalls(total:15)
        }
    }

    private func createBalls(total:Int) {
        let ballSize: CGFloat = 100
        
        for _ in 0..<total {
            let ball = BallView(frame: CGRect(x: 0, y: -ballSize, width: ballSize, height: ballSize))
            view.addSubview(ball)
            ballsArr.append(ball)
            
            ball.tapAction = { [weak self, weak ball] in
                guard let theBall = ball else { return }
                self?.handleBallTap(theBall)
            }
        }
        
        self.delayBetweenBallsInput = (totalAnimationDuration - 5) /  Double(ballTotal)
        
        startDroppingBalls(delayBetweenBalls: delayBetweenBallsInput, dropDuration: dropDurationInput)
    }
    
    private func startDroppingBalls(delayBetweenBalls:Double, dropDuration:Double) {

        let maxWidth = view.bounds.width
        
        for (index, ball) in ballsArr.enumerated() {
            let delay = TimeInterval(index) * TimeInterval(delayBetweenBalls)
            ball.startFalling(duration: TimeInterval(dropDuration), maxWidth: maxWidth, delay: delay)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + totalAnimationDuration) { [weak self] in
            self?.removeDroppedBalls()
            self?.dismiss(animated: false)
        }
    }
    
    private func removeDroppedBalls() {
        ballsArr.removeAll { $0.frame.origin.y >= self.view.bounds.height }
    }
    
    //MARK: Tab Ball
    private func handleBallTap(_ ball: BallView) {
        ballCount += 1
        ball.stopFalling()
        ball.removeFromSuperview()
        ballsArr.removeAll { $0 == ball }
        print("Ball Count: \(ballCount)")
        
        /*
         //แสดง animation หลังกดแตะ
         let imagesArr:[UIImage] = [.init(named: "ball_tab1")!,.init(named: "ball_tab2")!,.init(named: "ball_tab3")!]
         
         ballCount += 1
         ball.stopFalling()
         // Animate the image changes
         BallView.transition(with: ball.imageBall, duration:  0.3) {
         ball.stopFalling()
         ball.imageBall.image = imagesArr[0]
         } completion: { _ in
         BallView.transition(with: ball.imageBall, duration:  0.3) {
                 ball.imageBall.image = imagesArr[1]
             } completion: { _ in
         BallView.transition(with: ball.imageBall, duration: 0.3) {
                     ball.imageBall.image = imagesArr[2]
                    ball.removeFromSuperview()
                     self.ballsArr.removeAll { $0 == ball }
                     print("ball Count: \(self.ballCount)")
                 }
             }
         }
         */
    }
}
