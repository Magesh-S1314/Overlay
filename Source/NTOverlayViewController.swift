//
//  NTOverlayViewController.swift
//
//  Created by magesh on 30/11/20.
//

import UIKit

class NTOverlayViewController: UIViewController {

    var manager: NTOverlayManager?
    
    var maskingRect = CGRect.zero
    let btnClose = UIButton()
    let lblTitle = UILabel()
    let lblSubTitle = UILabel()
    let btnGotIt = UIButton()
    let contentStackView = UIStackView()
    var arrow = UIView()
    
    let blurVisualEffectView = UIVisualEffectView(effect: nil)
    var propertyAnimator: UIViewPropertyAnimator?
    
    var btnGotItWidthMultiplier: CGFloat = 0.3
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurVisualEffectView.effect = nil
        propertyAnimator = UIViewPropertyAnimator(duration: 0.7, curve: .easeIn) {
            self.blurVisualEffectView.effect = UIBlurEffect(style: .regular)
            self.blurVisualEffectView.contentView.backgroundColor = #colorLiteral(red: 0.0431372549, green: 0.1725490196, blue: 0.1215686275, alpha: 1).withAlphaComponent(0.8)
        }
        
        maskingRect = maskingRect.inset(by: maskingInset())
        let path = CGMutablePath()
        path.addRect(self.view.bounds)
        path.addRoundedRect(in: maskingRect, cornerWidth: 5, cornerHeight: 5)
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.red.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        maskLayer.anchorPoint = CGPoint(x: 0, y: 0)
        view.layer.mask = maskLayer
        
        arrow = Arrow(frame: arrowFrame(maskingRect: maskingRect))
        view.addSubview(arrow)
        arrow.backgroundColor = .clear
        
        let contentRect = contentFrame(maskingRect: maskingRect)
        contentStackView.frame = contentRect
        contentStackView.axis = .vertical
        contentStackView.distribution = .equalSpacing
        contentStackView.spacing = 10
        contentStackView.alignment = .fill
        self.view.addSubview(contentStackView)
        
        
        lblTitle.text = "Title"
        lblTitle.font = .systemFont(ofSize: 12, weight: .bold)
        lblTitle.textColor = .white
        contentStackView.addArrangedSubview(lblTitle)
        
        lblSubTitle.text = "SubTitle"
        lblSubTitle.font = .systemFont(ofSize: 12)
        lblSubTitle.numberOfLines = 0
        lblSubTitle.textColor = .white
        contentStackView.addArrangedSubview(lblSubTitle)
        
        btnGotIt.setTitle("Got it!", for: .normal)
        btnGotIt.layer.cornerRadius = 5
        btnGotIt.layer.borderWidth = 1
        btnGotIt.layer.borderColor = UIColor.white.cgColor
        btnGotIt.titleLabel?.font = .systemFont(ofSize: 12)
        btnGotIt.addTarget(self, action: #selector(gotItButtonTapped), for: .touchUpInside)
        btnGotIt.setTitleColor(UIColor.white, for: .normal)
        btnGotIt.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        let btnGotItHolder = UIView()
        btnGotItHolder.addSubview(btnGotIt)
        btnGotIt.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            btnGotIt.topAnchor.constraint(equalTo: btnGotItHolder.topAnchor),
            btnGotIt.leadingAnchor.constraint(equalTo: btnGotItHolder.leadingAnchor),
            btnGotIt.widthAnchor.constraint(equalTo: btnGotItHolder.widthAnchor, multiplier: btnGotItWidthMultiplier),
            btnGotIt.heightAnchor.constraint(equalTo: btnGotItHolder.heightAnchor)
        ])
        contentStackView.addArrangedSubview(btnGotItHolder)
        
        contentStackView.subviews.forEach { (view) in
            view.transform = .init(translationX: 0, y: 150)
            view.layer.opacity = 0
        }
        
        btnClose.frame = closeButtonFrame(maskingRect: maskingRect)
        btnClose.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        btnClose.setTitle("Close", for: .normal)
        btnClose.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        btnClose.setTitleColor(UIColor.white, for: .normal)
        btnClose.setTitleColor(UIColor.white.withAlphaComponent(0.5), for: .highlighted)
        view.addSubview(btnClose)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        propertyAnimator?.startAnimation()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(180)) {
            self.propertyAnimator?.pauseAnimation()
        }
        
        UIView.animate(withDuration: 0.5) {
            self.contentStackView.subviews.forEach { (view) in
                view.transform = .identity
                view.layer.opacity = 1
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        propertyAnimator?.stopAnimation(true)
    }
    
    @objc func gotItButtonTapped(){
        if let manager = manager {
            manager.next()
        }
    }
    
    @objc func closeButtonTapped(){
        if let manager = manager {
            manager.end()
            AppDefaults.isFirstOverlayCompleteOrNot = true
            AppDefaults.isSecondOverlayShown = true
        }
    }
    
    func closeButtonFrame(maskingRect: CGRect = .zero) -> CGRect {
        let width: CGFloat = 50
        let rightPadding: CGFloat = 16
        let calculatedX = view.frame.width - width - rightPadding
        var calculatedY: CGFloat = 0
        if #available(iOS 11.0, *) {
            calculatedY = view.safeAreaInsets.top + 63
        } else {
            // Fallback on earlier versions
            calculatedY = topLayoutGuide.length + 63
        }
        return CGRect(x: calculatedX, y: calculatedY, width: width, height: 50)
    }
    
    func arrowFrame(maskingRect: CGRect) -> CGRect {
        fatalError("Arrow Frame not overriden :[\(#file):\(#line)]")
    }

    func contentFrame(maskingRect: CGRect) -> CGRect {
        fatalError("Content Frame not overriden :[\(#file):\(#line)]")
    }
    
    func maskingInset() -> UIEdgeInsets {
        UIEdgeInsets(top: -8, left: -8, bottom: -8, right: -8)
    }

}


