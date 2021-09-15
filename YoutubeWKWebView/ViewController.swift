//
//  ViewController.swift
//  YoutubeWKWebView
//
//  Created by 坂本龍哉 on 2021/09/15.
//

import UIKit
import WebKit

final class ViewController: UIViewController {

    @IBOutlet private weak var youtubeWebView: WKWebView!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupWebView()
        setupThumbnail { results in
            switch results {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let data):
                DispatchQueue.main.async {
                    self.thumbnailImageView.image = UIImage(data: data)
                }
            }
        }
    }

    private func setupWebView() {
        if let url = URL(string: "https://www.youtube.com/watch?v=rzKcrJ77wBY") {
            youtubeWebView.load(URLRequest(url: url))
        }
    }
    
    private func setupThumbnail(completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: "http://img.youtube.com/vi/rzKcrJ77wBY/sddefault.jpg") {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                }
                
                guard let data = data else { return }
                completion(.success(data))
            }
            task.resume()
        }
    }
    
}

