// ZoomImageView.swift
//
// Copyright (c) 2016 muukii
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import UIKit
@objc public protocol ZoomImageViewDelegate {
    @objc optional func didZoomOut(view: ZoomImageView)
    @objc optional func didZoomIn(view: ZoomImageView)
}
open class ZoomImageView : UIScrollView, UIScrollViewDelegate {
    
    public enum ZoomMode {
        case fit
        case fill
    }
    
    // MARK: - Properties
    let defaultSize = CGSize.init(width: UIScreen.main.bounds.width, height: 1.77*UIScreen.main.bounds.width)
    let gifManager = SwiftyGifManager(memoryLimit:100)
    var maxScale:CGFloat = 2.5
    open let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.allowsEdgeAntialiasing = true
        return imageView
    }()
    open var delegateZoomImageView:ZoomImageViewDelegate!
    public var zoomMode: ZoomMode = .fit {
        didSet {
            updateImageView()
            scrollToCenter()
        }
    }
    open var isNormalImage = false
    open var loopCount:Int = -1
    open var keepSetting = false
    open var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            let oldImage = imageView.image
            if(self.isNormalImage){
                imageView.image = newValue
            }else{
                if let value = newValue{
                    imageView.setGifImage(value, manager: gifManager, loopCount: loopCount)
                }
            }
            
            if oldImage?.size != newValue?.size {
                oldSize = nil
                updateImageView()
            }
            scrollToCenter()
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return imageView.intrinsicContentSize
    }
    
    private var oldSize: CGSize?
    
    // MARK: - Initializers
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public init(image: UIImage) {
        super.init(frame: CGRect.zero)
        self.image = image
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - Functions
    
    open func scrollToCenter() {
        
        let centerOffset = CGPoint(
            x: contentSize.width > defaultSize.width ? (contentSize.width / 2) - (defaultSize.width / 2) : 0,
            y: contentSize.height > defaultSize.height ? (contentSize.height / 2) - (defaultSize.height / 2) : 0
        )
        
        contentOffset = centerOffset
    }
    
    open func setup() {
        
        #if swift(>=3.2)
            if #available(iOS 11, *) {
                contentInsetAdjustmentBehavior = .never
            }
        #endif
        
        backgroundColor = UIColor.clear
        delegate = self
        imageView.contentMode = .scaleToFill
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        addSubview(imageView)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
    }
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if imageView.image != nil && oldSize != defaultSize {
            
            updateImageView()
            oldSize = defaultSize
        }
        
        if imageView.frame.width <= defaultSize.width {
            imageView.center.x = defaultSize.width * 0.5
        }
        
        if imageView.frame.height <= defaultSize.height {
            imageView.center.y = defaultSize.height * 0.5
        }
    }
    
    open override func updateConstraints() {
        super.updateConstraints()
        updateImageView()
    }
    
    private func updateImageView() {
        
        func fitSize(aspectRatio: CGSize, boundingSize: CGSize) -> CGSize {
            
            let widthRatio = (boundingSize.width / aspectRatio.width)
            let heightRatio = (boundingSize.height / aspectRatio.height)
            
            var boundingSize = boundingSize
            
            if widthRatio < heightRatio {
                boundingSize.height = boundingSize.width / aspectRatio.width * aspectRatio.height
            }
            else if (heightRatio < widthRatio) {
                boundingSize.width = boundingSize.height / aspectRatio.height * aspectRatio.width
            }
            return CGSize(width: ceil(boundingSize.width), height: ceil(boundingSize.height))
        }
        
        func fillSize(aspectRatio: CGSize, minimumSize: CGSize) -> CGSize {
            let widthRatio = (minimumSize.width / aspectRatio.width)
            let heightRatio = (minimumSize.height / aspectRatio.height)
            
            var minimumSize = minimumSize
            
            if widthRatio > heightRatio {
                minimumSize.height = minimumSize.width / aspectRatio.width * aspectRatio.height
            }
            else if (heightRatio > widthRatio) {
                minimumSize.width = minimumSize.height / aspectRatio.height * aspectRatio.width
            }
            return CGSize(width: ceil(minimumSize.width), height: ceil(minimumSize.height))
        }
        
        guard let image = imageView.image else { return }
        
        var size: CGSize
        
        switch zoomMode {
        case .fit:
            size = fitSize(aspectRatio: image.size, boundingSize: defaultSize)
        case .fill:
            size = fillSize(aspectRatio: image.size, minimumSize: defaultSize)
        }
        
        size.height = round(size.height)
        size.width = round(size.width)
        
        zoomScale = 1
        maximumZoomScale = maxScale
        imageView.bounds.size = defaultSize
        contentSize = size
        imageView.center = ZoomImageView.contentCenter(forBoundingSize: defaultSize, contentSize: contentSize)
        self.zoomView(scale: 1, with: self.center)
        
    }
    
    @objc private func handleDoubleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        if self.zoomScale == 1 {
            self.zoomView(scale: 3, with: gestureRecognizer.location(in: gestureRecognizer.view))
        } else {
            setZoomScale(0.1, animated: true)
        }
    }
    func zoomView(scale: CGFloat, with center: CGPoint){
        zoom(
            to: zoomRectFor(
                scale: scale,
                with: center),
            animated: true
        )
    }
    // This function is borrowed from: https://stackoverflow.com/questions/3967971/how-to-zoom-in-out-photo-on-double-tap-in-the-iphone-wwdc-2010-104-photoscroll
    private func zoomRectFor(scale: CGFloat, with center: CGPoint) -> CGRect {
        let center = imageView.convert(center, from: self)
        
        var zoomRect = CGRect()
        zoomRect.size.height = bounds.height / scale
        zoomRect.size.width = bounds.width / scale
        zoomRect.origin.x = center.x - zoomRect.width / 2.0
        zoomRect.origin.y = center.y - zoomRect.height / 2.0
        
        return zoomRect
    }
    
    
    // MARK: - UIScrollViewDelegate
    @objc dynamic public func scrollViewDidZoom(_ scrollView: UIScrollView) {
        imageView.center = ZoomImageView.contentCenter(forBoundingSize: bounds.size, contentSize: contentSize)
        if scrollView.zoomScale == scrollView.minimumZoomScale
        {
            self.delegateZoomImageView?.didZoomOut?(view: self)
        }
        if scrollView.zoomScale == maxScale
        {
            self.delegateZoomImageView?.didZoomIn!(view: self)
        }
    }
    
    @objc dynamic public func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        
    }
    
    @objc dynamic public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        
    }
    
    @objc dynamic public func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    @inline(__always)
    private static func contentCenter(forBoundingSize boundingSize: CGSize, contentSize: CGSize) -> CGPoint {
        
        /// When the zoom scale changes i.e. the image is zoomed in or out, the hypothetical center
        /// of content view changes too. But the default Apple implementation is keeping the last center
        /// value which doesn't make much sense. If the image ratio is not matching the screen
        /// ratio, there will be some empty space horizontaly or verticaly. This needs to be calculated
        /// so that we can get the correct new center value. When these are added, edges of contentView
        /// are aligned in realtime and always aligned with corners of scrollview.
        let horizontalOffest = (boundingSize.width > contentSize.width) ? ((boundingSize.width - contentSize.width) * 0.5): 0.0
        let verticalOffset = (boundingSize.height > contentSize.height) ? ((boundingSize.height - contentSize.height) * 0.5): 0.0
        
        return CGPoint(x: contentSize.width * 0.5 + horizontalOffest,  y: contentSize.height * 0.5 + verticalOffset)
    }
}

