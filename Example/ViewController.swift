//
//  ViewController.swift
//
//  Created by magesh on 12/12/20.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var btnEdit: UIButton!
    
    var overlayManager: NTOverlayManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayManager = NTOverlayManager(context: self)
        overlayManager.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
            self.overlayManager.start()
            self.view.isUserInteractionEnabled = false
        }
    }
    
    
    func getMaskingRect(for maskingView: UIView) -> CGRect {
        if let maskingSuperView = maskingView.superview {
            return maskingSuperView.convert(maskingView.frame, to: view)
        }
        
        fatalError("Cannot find masking superview for \(maskingView)")
    }
}


extension ViewController: NTOverlayManagerDelegate {
    
    
    func numberOfOverlays() -> Int {
        return 1
    }
    
    func overlay(for index: Int) -> NTOverlayViewController {
        switch index {
        
        case 0:
            let overlay = EditBtnOverlay()
            overlay.maskingRect = getMaskingRect(for: btnEdit)
            return overlay
        default:
            fatalError("Overlay not implemented for index: \(index)")
        }
    }
        
    func overlayDidEnd() {
        view.isUserInteractionEnabled = true
        print("overlay did end")
    }
    
}
