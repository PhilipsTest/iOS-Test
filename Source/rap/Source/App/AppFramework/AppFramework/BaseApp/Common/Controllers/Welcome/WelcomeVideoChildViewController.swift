/* Copyright (c) Koninklijke Philips N.V., 2016
 * All rights are reserved. Reproduction or dissemination
 * in whole or in part is prohibited without the prior written
 * consent of the copyright holder.
 */

import AVKit
import AVFoundation
import UIKit
import PhilipsUIKitDLS
import AppInfra

class WelcomeVideoChildViewController: WelcomeChildViewController {
    //MARK: Default methods

    @IBOutlet weak var imgPlay: UIImageView!
    @IBOutlet weak var videoView: UIImageView!
    var player: AVPlayer?
    var playerLayer:AVPlayerLayer?
    @IBOutlet weak var scrollView: UIScrollView!
    
    // By default this method is delegated to the AppInfra Rest client
    // It can be overridden in specific unit tests by a simple code block, without having to stub the complete AIRESTClientProtocol
    var isInternetReachable: () -> Bool = WelcomeVideoChildViewController.defaultInternetReachabilityCheck

    // By default this method is delegated to service discovery
    // It can be overridden in specific unit tests by a simple code block, without having to stub the complete AIServiceDiscoveryProtocol
    var getVideoUrl = WelcomeVideoChildViewController.defaultGetVideoUrl

    override func viewDidLoad() {
        super.viewDidLoad()
        loadVideo()
        configureUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        pauseVideo()
    }

    fileprivate static func defaultInternetReachabilityCheck() -> Bool {
        return (AppInfraSharedInstance.sharedInstance.appInfraHandler?.restClient.isInternetReachable())!
    }

    fileprivate static func defaultGetVideoUrl(withCountryPreference videoId: String, withCompletionHandler completionHandler: ((String?, Error?) -> Swift.Void)!) {
    AppInfraSharedInstance.sharedInstance.appInfraHandler?.serviceDiscovery.getServicesWithCountryPreference([videoId], withCompletionHandler: { (dictionary, error) in
            if let serviceURL:AISDService = dictionary?[videoId]{
                completionHandler(serviceURL.url,nil)
            }else{
                completionHandler(nil,error)
            }
        }, replacement: nil)
    }
}

//MARK: Helper methods

extension WelcomeVideoChildViewController {

    override func configureUI() {
        super.configureUI()

        if let videoThumbnailId = (screenDict![Constants.WELCOME_VIDEO_THUMBNAIL_KEY]) as! String? {
            videoView.image = UIImage(named: videoThumbnailId)
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.togglePlayingState(_:)))
        videoView.addGestureRecognizer(tap)
        imgPlay.isHidden = false
    }

    func loadVideo(){
        guard isInternetReachable() else {
            let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: "Internet seems to be unavailable. Please Check your internet Connection ", buttonAction: [alertAction], usingController: nil)
            return
        }

        guard let videoId = (screenDict![Constants.WELCOME_VIDEO_ID_KEY]) as! String? else {
            return
        }

        getVideoUrl(videoId){ [weak self] (value, error) in
            guard value != nil else {
                AppInfraSharedInstance.sharedInstance.loggingForAppFramework?.log(.error, eventId: "ErrorWhileGettingURLfromServiceDiscovery", message: "\(String(describing: error))")
                return
            }

            let videoURL = URL(string: value!)
            self?.player = AVPlayer(url: videoURL!)
            self?.configureVideo()
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self?.player?.currentItem, queue: nil) { notification in
                self?.player?.seek(to: CMTime.zero)
                self?.pauseVideo()
            }
        }
    }

    fileprivate func configureVideo() {
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        if let playerLayerNew = playerLayer {
            videoView.layer.addSublayer(playerLayerNew)
        }
        view.bringSubviewToFront(imgPlay)
        imgPlay.isHidden = false
    }

    func playVideo() {
        player?.play()
        imgPlay.isHidden = true
    }

    func pauseVideo() {
        player?.pause()
        imgPlay.isHidden = false
    }

    @objc func togglePlayingState(_ sender: UITapGestureRecognizer) {
        self.checkVideoStatus()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoView.setNeedsLayout()
        videoView.layoutIfNeeded()
        deviceRotated()
    }
    
    func deviceRotated() {
        playerLayer?.frame = videoView.bounds
        playerLayer?.videoGravity = AVLayerVideoGravity.resizeAspect
        if let playerLayerNew = playerLayer {
            videoView.layer.addSublayer(playerLayerNew)
        }
        view.bringSubviewToFront(imgPlay)
        self.pauseVideo()
        let screenSize = UIScreen.main.bounds
        let widthOfView = screenSize.width
        let heightOfView = screenSize.height
        let heightOfDescriptionLabel = self.lblDescription.frame.origin.y
        
        if UIDevice.current.orientation.isLandscape {
            scrollView.contentSize.height = heightOfView + (heightOfDescriptionLabel - heightOfView) + (CGFloat(Constants.DLS_WELCOME_SCREEN_SCROLL_HEIGHT))
        } else if UIDevice.current.orientation.isPortrait {
            scrollView.contentSize.height = heightOfView
        }
        scrollView.contentSize.width = widthOfView
    }
    
    func checkVideoStatus() {
        guard isInternetReachable() else {
            let alertAction = UIDAction(title:Constants.OK_TEXT, style: .primary)
            Utilites.showDLSAlert(withTitle: Constants.APPFRAMEWORK_TEXT, withMessage: "Internet seems to be unavailable. Please Check your internet Connection ", buttonAction: [alertAction], usingController: nil)
            return
        }
        if (player?.rate != 0) {
            pauseVideo()
        } else {
            playVideo()
        }
    }
}
