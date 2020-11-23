/* Copyright (c) Koninklijke Philips N.V., 2019
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import PhilipsUIKitDLS
import AFNetworking

class MECProductImageViewController: UIViewController {

    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var imageDownloadIndicator: UIDProgressIndicator!

    var index: Int = 0
    var shouldDisplayError = false
    var imageHeight: Int?
    var imageWidth: Int?
    var imageUrlString: String?
    fileprivate var defaultImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIAppearance()
        guard false == shouldDisplayError else {
            showDefaultImage()
            return
        }
        downloadProductImage()
    }
}

extension MECProductImageViewController {

    func configureUIAppearance() {
        productImageView.contentMode = .scaleAspectFill
        imageDownloadIndicator.progressIndicatorStyle = .indeterminate
        imageDownloadIndicator.isHidden = true
        defaultImage = UIImage(named: "no_image_icon", in: MECUtility.getBundle(), compatibleWith: nil)
    }

    func downloadProductImage() {
        if let imageURLString = imageUrlString {
            let imageURLSizedString = String(format: imageURLString, "\(imageWidth ?? 0)", "\(imageHeight ?? 0)")
            if let imageURL = URL(string: imageURLSizedString) {
                imageDownloadIndicator.isHidden = false
                imageDownloadIndicator.startAnimating()
                AFImageDownloader.defaultInstance().sessionManager
                    .responseSerializer
                    .acceptableContentTypes?
                    .insert(MECImageDownloadSpecialFormats.MECJP2Format)
                let imageDownloadRequest = URLRequest(url: imageURL)
                productImageView.setImageWith(imageDownloadRequest,
                                              placeholderImage: nil,
                                              success: { [weak self] (_, _, image) in
                    self?.imageDownloadIndicator.stopAnimating()
                    self?.productImageView.image = image
                }, failure: { [weak self] (_, _, _) in
                    self?.imageDownloadIndicator.stopAnimating()
                    self?.showDefaultImage()
                })
            }
        }
    }

    func showDefaultImage() {
        productImageView.contentMode = .center
        productImageView.image = defaultImage
    }
}
