# Overlay
 Overlay on view controller
 
 # How to use
 ViewController.swift
 
    
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var propertiesStackView: UIStackView!
    
    var overlayManager: NTOverlayManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overlayManager = NTOverlayManager(context: self)
        overlayManager.delegate = self
    }
    
    extension ViewController: NTOverlayManagerDelegate {
    
        func numberOfOverlays() -> Int {
            return 2
        }

        func overlay(for index: Int) -> NTOverlayViewController {
            switch index {
            case 0:
                let overlay = EditBtnOverlay()
                overlay.maskingRect = getMaskingRect(for: btnEdit)
                return overlay
            case 1:
                let overlay = HealthInformationOverlay()
                overlay.maskingRect = getMaskingRect(for: propertiesStackView)
                return overlay
            default:
                fatalError("Overlay not implemented for index: \(index)")
            }
        }

        func overlayDidEnd() {
            view.isUserInteractionEnabled = true
            print("My Profile overlay did end")
        }
    
    }
 EditBtnOverlay.swift
     
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
 <img src="https://github.com/Magesh-S1314/Overlay/blob/master/Example/Simulator%20Screen%20Shot%20-%20iPhone%20SE%20(2nd%20generation)%20-%202021-01-23%20at%2014.49.37.png" width="350"> <img src="https://github.com/Magesh-S1314/Overlay/blob/master/Example/Simulator%20Screen%20Shot%20-%20iPhone%20SE%20(2nd%20generation)%20-%202021-01-23%20at%2014.50.03.png" width="350">

