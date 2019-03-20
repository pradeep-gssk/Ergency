//
//  EGShowImageViewController.swift
//  Ergency
//
//  Created by Guduru, Pradeep(AWF) on 1/14/19.
//  Copyright © 2019 Guduru, Pradeep(AWF). All rights reserved.
//

import UIKit

class EGShowImageViewController: UIViewController {

    var drive: EGGoogleDrive?
    var fileId: String?
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    private let driveImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageScrollView.addSubview(self.driveImageView)
        self.imageScrollView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.downloadImage()
    }
    
    func downloadImage() {
        guard let fileId = self.fileId else {
            //TODO: Show error
            return
        }
        
        self.drive?.download(fileId, onCompleted: { (data, error) in
            if let error = error {
                //TODO: Show error
                print(error)
            }
            else if let data = data, let image = UIImage(data: data) {
                print(image)
                self.setZoomScale(image)
            }
            else {
                //TODO: Show error
                print("Not image")
            }
        })
    }
    
    func setZoomScale(_ image: UIImage) {
        self.driveImageView.image = image
        self.driveImageView.sizeToFit()
        
        self.imageScrollView.contentSize = self.driveImageView.frame.size
        let widthScale = self.imageScrollView.frame.size.width / self.driveImageView.frame.size.width
        let heightScale = self.imageScrollView.frame.size.height / self.driveImageView.frame.size.height
        let minScale = min(widthScale, heightScale)
        self.imageScrollView.minimumZoomScale = minScale
        self.imageScrollView.zoomScale = minScale
    }
}

extension EGShowImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.driveImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = self.driveImageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        let verticalInset = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalInset = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        scrollView.contentInset = UIEdgeInsets(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }
}
