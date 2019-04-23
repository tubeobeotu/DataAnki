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
    @IBOutlet weak var tf_Duration: UITextField!
    @IBOutlet weak var tf_Width: UITextField!
    @IBOutlet weak var tf_Height: UITextField!
    @IBOutlet weak var tf_OffsetY: UITextField!
    @IBOutlet weak var btn_ShowCircle: UIButton!
    @IBOutlet weak var btn_ShowDick: UIButton!
    @IBOutlet weak var btn_LoopForever: UIButton!
    
    @IBOutlet weak var v_guide: UIView!
    var vDidZoomOut = true
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
    let maxRotation:UInt32 = 10
    let timeToShowResult:Double = 3
    var isZoomIn = false
    var randomInt = Int(arc4random_uniform(2))
    let ratio:CGFloat = 0.2008
    let isTesing = true
    var isShowDefault = true {
        didSet{
            if(self.isShowDefault == false){
//                self.imageView.loopCount = -1
            }
        }
    }
    
    let durationCons:Double = 2
    
    var showCircle = false{
        didSet{
            self.btn_ShowCircle.setTitle("ShowCircle \(showCircle)", for: .normal)
        }
    }
    var showDick = true{
        didSet{
            self.btn_ShowDick.setTitle("ShowDick \(showDick)", for: .normal)
        }
    }
    var dickAnimation = true
    var loopForever = false{
        didSet{
            self.btn_LoopForever.setTitle("LoopForever \(loopForever)", for: .normal)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showCircle = false
        self.showDick = true
        self.loopForever = false
        self.v_guide.isHidden = !self.isTesing
        self.tf_Width.text = "\(CGFloat(UIDevice.modelBufferWidth))"
        self.tf_Height.text = "\(UIDevice.modelBufferHeight)"
        self.tf_Duration.text = "\(CGFloat(UIDevice.modelBufferDuration))"
        self.tf_OffsetY.text = "\((UIDevice.modelBufferOffset))"
        
        self.imageView.imageView.delegate = self
        self.hideDickResultViews()
        self.img_Result.delegateZoomImageView = self
        self.img_Result.image = UIImage(gifName: resultImage)
        self.showDefaultAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.imageView.zoomMode = .fill
            self.img_Result.zoomMode = .fill
            
            self.showResultAnimation(isShow: false)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.cst_tmpDickHeight.constant = (self.view.frame.height*self.ratio )
        self.cst_DickResultY.constant = -(self.cst_tmpDickHeight.constant * scale) - CGFloat(UIDevice.modelBufferY)
        
        
    }
    @IBAction func showCircle(_ sender: Any) {
        showCircle = !showCircle
    }
    @IBAction func showDick(_ sender: Any) {
        showDick = !showDick
    }
    @IBAction func dickAnimation(_ sender: Any) {
        dickAnimation = !dickAnimation
    }
    
    @IBAction func loopForever(_ sender: Any) {
        loopForever = !loopForever
    }
    @IBAction func apply(_ sender: Any) {
        self.stop()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.action(sender)
        }
    }
    
    func prepareZoomIn(){
        self.imageView.image = UIImage(gifName: rotationAnimation)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.imageView.zoomView(scale: self.scale, with: CGPoint.init(x: self.v_TmpDick.center.x, y: self.view.frame.height))
            self.img_Result.zoomView(scale: self.scale, with: CGPoint.init(x: self.v_TmpDick.center.x, y: self.view.frame.height))
            
        }
    }
    func addCircleAnimation(){
        let width:CGFloat = self.tf_Width.text!.toCGFloat() * scale
        let height:CGFloat = self.tf_Height.text!.toCGFloat() * scale
        let marginX:CGFloat = 0 * scale
        let marginY:CGFloat = 0 * scale
        let ovalPath = UIBezierPath(ovalIn: CGRect(x: v_Dick.center.x - width/2 - marginX, y: v_Dick.center.y - marginY, width: width, height: height))
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = ovalPath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.0
        if(showCircle){
            shapeLayer.strokeColor = UIColor.red.cgColor
        }
        
        view.layer.addSublayer(shapeLayer)
        let animation = CAKeyframeAnimation(keyPath: #keyPath(CALayer.position))
        animation.duration = CFTimeInterval(self.tf_Duration.text!.toCGFloat())
        animation.timeOffset = CFTimeInterval(self.tf_OffsetY.text!.toCGFloat())
        animation.calculationMode = kCAAnimationPaced
        animation.repeatCount = MAXFLOAT
        animation.path = ovalPath.cgPath
        v_Dick.layer.add(animation, forKey: nil)
    }
    @IBAction func action(_ sender: Any) {
        print(self.v_Dick.frame)
        self.view.endEditing(true)
        self.v_Dick.transform = CGAffineTransform.identity
        isShowDefault = false
        btn_Action.isEnabled = false
        self.img_Result.isHidden = true
        self.img_Dick.image = UIImage.init(named: dickImage)
        numberOfRotate = Int(arc4random_uniform(maxRotation * 2) + maxRotation)
        currentIndex = 1
        
        if(vDidZoomOut == false){
            self.actionDidZoomOut()
        }else{
            self.prepareZoomIn()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.v_Dick.isHidden = false
        }
        self.addCircleAnimation()
        self.rotateView(targetView: self.v_Dick, duration: self.durationCons)
        
    }
    func rotateView(targetView: UIView, duration: Double = 1.0) {
        var currentDuration:Double = abs(Double(currentIndex - ((self.numberOfRotate + 1)*(currentIndex/((self.numberOfRotate/2) + 1)))))
        if(currentDuration == 0){
            currentDuration = Double(self.numberOfRotate/2) + 1
        }
        targetView.isHidden = !showDick
        UIView.animate(withDuration: self.durationCons/currentDuration, delay: 0.0, options: .curveLinear, animations: {
                targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi/(Double(arc4random_uniform(1) + 10))) + CGFloat(Double.pi))
        }) { finished in
            if(self.numberOfRotate != self.currentIndex || self.loopForever == true){
                self.currentIndex = self.currentIndex + 1
                self.rotateView(targetView: targetView, duration: self.durationCons/currentDuration)
            }else{
                self.stop()
            }
        }
    }
    func stop(){
        print(self.v_Dick.frame)
        self.vDidZoomOut = false
        self.btn_Action.isEnabled = true
        self.v_Dick.layer.removeAllAnimations()
        self.showResultAnimation(isShow: true)
        self.img_Dick.image = UIImage.init(named: self.dickSmileImage)
        DispatchQueue.main.asyncAfter(deadline: .now() + self.timeToShowResult) {
            if(self.vDidZoomOut == false){
                self.zoomOutResult()
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
        self.img_Result.zoomView(scale: 1, with: CGPoint.init(x: self.v_TmpDick.center.x, y: self.view.frame.height))
    }
    func hideDickResultViews(){
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
            self.actionDidZoomOut()
            self.isShowDefault = self.vDidZoomOut
            self.showDefaultAnimation()
        }
    }
    func actionDidZoomOut(){
        self.vDidZoomOut = true
        self.btn_Action.isEnabled = self.vDidZoomOut
        self.img_Result.isHidden = self.vDidZoomOut
        self.hideDickResultViews()
        self.showResultAnimation(isShow: false)
    }
}


extension String{
    func toCGFloat() -> CGFloat{
        let str = self
        if let n = NumberFormatter().number(from: str) {
            let f = CGFloat(n)
            return f
        }
        return 0.0
    }
}
