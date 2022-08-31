//
//  PhotoCollectionViewCell.swift
//  DAY03
//
//  Created by Zuleykha Pavlichenkova on 12.08.2022.
//

import UIKit

// модель ячейки
class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "PhotoCollectionViewCell"
    // тут хранятся таски на каждую загрузку и урл (пригодятся ниже)
    var imageDownloadTask: URLSessionDataTask?
    var imageURL: URL?
    
    // в каждой ячейке будет по объекту UIImageView
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    // spinner
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    // во время инита будет построен UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        imageView.image = nil
    }
    
    // MARK: Set up UI
    
    func setUpUI() {
        // сначала нужно положить картинку
        contentView.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
        // а на картинку верхним слоем спиннер
        contentView.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: contentView.topAnchor),
            activityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            activityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    // MARK: Configure cell
    
    func configureCell(with url: URL, errorHandler: @escaping (URL) -> Void) {
        
        //чтобы не появилась старая картинка
        imageDownloadTask?.cancel()
        
        //чтобы работать именно с тем урл, который передали
        self.imageURL = url
        
        //начинаем скачивать
        imageDownloadTask = URLSession.shared.dataTask(
            with: url,
            // в качестве комплишен хендлера передается кложур, на параметры которой слабая ссылка (чтобы не было цикла удержания)
            completionHandler: { [weak self] data, urlResponse, error in
                guard let self = self
                else { return }
                
                //перевести данные на главный поток, потому что с UI можно работать только с главного потока
                DispatchQueue.main.async {
                    
                    //остановить крутилку после завершения загрузки картинки
                    self.activityIndicator.stopAnimating()
                    //если дата есть и картинка из даты есть...
                    guard let data = data,
                          let image = UIImage(data: data)
                    else {
                        // иначе показываем алерт и системную картинку и выходим
                        errorHandler(url)
                        self.imageView.image = UIImage(systemName: "xmark.octagon")
                        return
                    }
                    //...показываем картинку
                    self.imageView.image = image
                    DefaultImageCache.shared.setImage(image, key: url.absoluteString)
                }
            })
        //запустить крутилку
        activityIndicator.startAnimating()
        //начать загрузку картинки
        imageDownloadTask?.resume()
        
    }
    
    
    
}
