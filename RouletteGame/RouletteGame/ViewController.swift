//
//  ViewController.swift
//  RouletteGame
//
//  Created by Tu on 3/21/19.
//  Copyright © 2019 tunv. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var btn_Action: UIButton!
    @IBOutlet weak var imageView: ZoomImageView!
    @IBOutlet weak var img_Result: ZoomImageView!
    @IBOutlet weak var v_TmpDick: UIView!
    
    @IBOutlet weak var cst_tmpDickHeight: NSLayoutConstraint!
    @IBOutlet weak var img_DumpResult: UIImageView!
    @IBOutlet weak var cst_X: NSLayoutConstraint!
    
    @IBOutlet weak var cst_DickResultY: NSLayoutConstraint!
    @IBOutlet weak var v_DickResult: UIView!
    @IBOutlet weak var v_Dick: UIView!
    @IBOutlet weak var img_Dick: UIImageView!
    var duration:Double = 0.15
    var numberOfRotate:Int = 1
    var currentIndex:Int = 1
    var isSetup = false
    var defaultIndex = 0
    let defaultImageGifs = ["defaultAnimation0", "defaultAnimation0"]
    let dickImage = "dick"
    let dickSmileImage = "dickSmile"
    let rotationAnimation = "animation"
    let resultImage = "result"
    let scale:CGFloat = 2.5
    let maxRotation:UInt32 = 12
    let timeToShowResult:Double = 3
    var isZoomIn = false
    var randomInt = Int(arc4random_uniform(2))
    let ratio:CGFloat = 0.185
    
    var isShowDefault = true {
        didSet{
            if(self.isShowDefault == false){
                self.imageView.loopCount = -1
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView.imageView.delegate = self
        self.hideResultViews()
        self.img_Result.delegateZoomImageView = self
        self.img_Result.image = UIImage(gifName: resultImage)
//        self.img_Result.isHidden = true
        self.showDefaultAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.imageView.zoomMode = .fill
            self.img_Result.zoomMode = .fill
            
            self.showResultAnimation(isShow: false)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cst_tmpDickHeight.constant = (self.view.frame.height*self.ratio - CGFloat(UIDevice.modelBufferHeight))
        print(self.cst_DickResultY.constant)
        self.cst_DickResultY.constant = -(self.cst_tmpDickHeight.constant * scale) - CGFloat(UIDevice.modelBufferHeight)
        
        
    }
    @IBAction func action(_ sender: Any) {
        isShowDefault = false
        btn_Action.isEnabled = false
        print(self.view.frame)
        self.imageView.image = UIImage(gifName: rotationAnimation)
        self.img_Result.isHidden = true
        let width:CGFloat = 50 * scale
        let height:CGFloat = 10 * scale
        let marginX:CGFloat = 0 * scale
        let marginY:CGFloat = 0 * scale
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.imageView.zoomView(scale: self.scale, with: CGPoint.init(x: self.v_TmpDick.center.x, y: self.v_TmpDick.frame.origin.y))
            self.img_Result.zoomView(scale: self.scale, with: CGPoint.init(x: self.v_TmpDick.center.x, y: self.v_TmpDick.frame.origin.y))
            
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.v_Dick.isHidden = false
        }
        
        
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: v_Dick.center.x - width/2 - marginX, y: v_Dick.center.y - marginY, width: width, height: height))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = ovalPath.cgPath

        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
         shapeLayer.lineWidth = 3.0
//        shapeLayer.strokeColor = UIColor.red.cgColor
        
        view.layer.addSublayer(shapeLayer)
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = 1.045
        animation.timeOffset = -0.27
        animation.calculationMode = kCAAnimationPaced
        animation.repeatCount = MAXFLOAT
        animation.path = ovalPath.cgPath
        v_Dick.layer.add(animation, forKey: nil)
        self.img_Result.isHidden = true
        self.img_Dick.image = UIImage.init(named: dickImage)
        numberOfRotate = Int(arc4random_uniform(maxRotation * 2) + maxRotation)
        currentIndex = 1
        self.rotateView(targetView: self.v_Dick, duration: duration)
    }
    func rotateView(targetView: UIView, duration: Double = 1.0) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveLinear, animations: {
            targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi/(Double(arc4random_uniform(1) + 10))) + CGFloat(Double.pi))
        }) { finished in
            if(self.numberOfRotate != self.currentIndex){
                self.currentIndex = self.currentIndex + 1
                self.rotateView(targetView: targetView, duration: duration)
            }else{
                self.v_Dick.layer.removeAllAnimations()
                self.showResultAnimation(isShow: true)
                self.showDickResult(isShow: true)
                self.img_Dick.image = UIImage.init(named: self.dickSmileImage)
                DispatchQueue.main.asyncAfter(deadline: .now() + self.timeToShowResult) {
                    self.zoomOutResult()
                }

            }
        }
    }
    
    func showDefaultAnimation(){
        if(randomInt == 0){
            randomInt = 1
        }else{
            randomInt = 0
        }
        self.imageView.image = UIImage(gifName: defaultImageGifs[randomInt])
    }
    func zoomOutResult(){
//        self.img_DumpResult.image = self.imageView.screenshot()
        self.img_Result.zoomView(scale: 1, with: CGPoint.init(x: self.v_TmpDick.center.x, y: self.v_TmpDick.frame.origin.y))
    }
    
    func showDickResult(isShow: Bool){
        self.v_Dick.isHidden = isShow
        self.v_DickResult.isHidden = !isShow
        if(isShow == true){
            v_DickResult.transform = v_DickResult.transform.rotated(by: v_Dick.transform.b)
        }
        
        
    }
    func hideResultViews(){
        self.v_Dick.isHidden = true
        self.v_DickResult.isHidden = true
    }
    func showResultAnimation(isShow: Bool){
        if(isShow){
            self.img_Result.isHidden = false
            self.img_Result.imageView.startAnimatingGif()
            self.imageView.imageView.stopAnimatingGif()
        }else{
            self.img_Result.isHidden = true
            self.img_Result.imageView.stopAnimatingGif()
            self.imageView.imageView.startAnimatingGif()
        }
        
    }
}
extension ViewController: SwiftyGifDelegate{
    public func gifDidStop(sender: UIImageView) {
        if(self.isShowDefault == true){
            self.showDefaultAnimation()
        }
    }
}
extension ViewController: ZoomImageViewDelegate{
    func didZoomOut() {
        DispatchQueue.main.async {
            self.isShowDefault = true
            self.showResultAnimation(isShow: false)
            self.img_Result.isHidden = true
            self.btn_Action.isEnabled = true
            self.hideResultViews()
            self.showDefaultAnimation()
        }
        
    }
}
