//
//  EditBtnOverlay.swift
//  NTrust
//
//  Created by magesh on 12/12/20.
//

import UIKit

final class EditBtnOverlay: NTOverlayViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblTitle.text = "Edit your profile:"
        lblSubTitle.text = "Update personal information, conditions, family history and personal activities for better care"
        arrow.transform = CGAffineTransform(rotationAngle: .degrees(180))
    }
        
    override func arrowFrame(maskingRect: CGRect) -> CGRect {
        return CGRect(x: maskingRect.minX - 70, y: maskingRect.maxY + 12, width: 200, height: 100)
    }
    
    override func contentFrame(maskingRect: CGRect) -> CGRect {
        let arrowRect = arrowFrame(maskingRect: maskingRect)
        return CGRect(x: arrowRect.minX - 100, y: arrowRect.maxY - 12, width: 260, height: 120)
    }
    
    override func closeButtonFrame(maskingRect: CGRect) -> CGRect {
        let height: CGFloat = 60
        return CGRect(x: maskingRect.minX, y: maskingRect.minY - height, width: maskingRect.width, height: height)
    }
}
