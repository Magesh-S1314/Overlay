//
//  NTOverlayManager.swift
//
//  Created by magesh on 01/12/20.
//

import UIKit

protocol NTOverlayManagerDelegate: AnyObject {
    
    func numberOfOverlays() -> Int
    func overlay(for index: Int) -> NTOverlayViewController
    func overlayDidEnd()
    
}

extension NTOverlayManagerDelegate {
    func overlayDidStart() {}
}

class NTOverlayManager {

    weak var context: UIViewController?
    weak var delegate: NTOverlayManagerDelegate?
    
    var overlays = [NTOverlayViewController]()
    private var nextOverlay = 0
    var isRunning = false
    private var currentPresentingOverlay: NTOverlayViewController?

        
    init(context: UIViewController) {
        self.context = context
    }
    
    func start(){
        guard let totalOverlays = delegate?.numberOfOverlays(), totalOverlays > 0 else { return }
        nextOverlay = 0
        presentOverlay(at: nextOverlay)
        isRunning = true
    }
    
    func presentOverlay(at index: Int){
        guard let context = context, let delegate = delegate else { return }
        currentPresentingOverlay?.dismiss(animated: true, completion: nil)
        let vc = delegate.overlay(for: index)
        vc.manager = self
        currentPresentingOverlay = vc
        context.present(vc, animated: true, completion: nil)
        nextOverlay += 1
    }
    
    func next(){
        guard isRunning, let delegate = delegate else { return }
        if nextOverlay < delegate.numberOfOverlays() {
            presentOverlay(at: nextOverlay)
        }else {
            end()
        }
    }
    
    func end(){
        guard let totalOverlays = delegate?.numberOfOverlays(), totalOverlays > 0 else { return }
        currentPresentingOverlay?.dismiss(animated: true, completion: nil)
        nextOverlay = 0
        isRunning = false
        delegate?.overlayDidEnd()
    }

}
