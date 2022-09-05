//
//  ViewController.swift
//  Player
//
//  Created by Pavel Poddubotskiy on 4.09.22.
//

import UIKit
import CollectionViewPagingLayout
import AVFoundation

class PlayerViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
        }
    
    private var player: AVAudioPlayer?
    
    private var songs: [Song] = Song.songs
    
    private var currentPage = 0
    
    var currentProgress: Float = 0
    
    private var isPlaying: Bool = false
    
    var timer: Timer?
    
    private lazy var backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "background")
        return imageView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewPagingLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(MusicCell.self, forCellWithReuseIdentifier: MusicCell.reuseID)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var songLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private lazy var artistLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressTintColor = .systemPurple
        progressView.progress = currentProgress
        return progressView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 40
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var playPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let playImage = UIImage(systemName: "play.fill")
        button.setBackgroundImage(playImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapPlayPauseButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let forwardImage = UIImage(systemName: "forward.end")
        button.setBackgroundImage(forwardImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapNextButton(_:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let backwardImage = UIImage(systemName: "backward.end")
        button.setBackgroundImage(backwardImage, for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(didTapBackButton(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        configurePlayer()
    }
}

extension PlayerViewController {
    private func style() {
        view.addSubview(backgroundImage)
        view.addSubview(collectionView)
        view.addSubview(songLabel)
        view.addSubview(artistLabel)
        view.addSubview(progressView)
        view.addSubview(buttonsStackView)
        
        buttonsStackView.addArrangedSubview(backButton)
        buttonsStackView.addArrangedSubview(playPauseButton)
        buttonsStackView.addArrangedSubview(nextButton)
    }
    
    private func layout() {
        //backgroundImage
        backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //CollectionView
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1.0/2.5).isActive = true
        
        //songLabel
        songLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        songLabel.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 70).isActive = true
        songLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //artistLabel
        artistLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        artistLabel.topAnchor.constraint(equalTo: songLabel.bottomAnchor, constant: 7).isActive = true
        songLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        //progressView
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        progressView.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 42).isActive = true
        
        //buttonsStackView
        buttonsStackView.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 78).isActive = true
        buttonsStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //playButton
        playPauseButton.heightAnchor.constraint(equalTo: playPauseButton.widthAnchor).isActive = true
        playPauseButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //nextButton
        nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        //backButton
        backButton.heightAnchor.constraint(equalTo: backButton.widthAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func configurePlayer() {
        songLabel.text = songs[currentPage].name
        artistLabel.text = songs[currentPage].artist
        
        var urlString = Bundle.main.path(forResource: songs[currentPage].name, ofType: "mp3")
        urlString = urlString?.replacingOccurrences(of: " ", with: "%20")
        
        do {
            try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            
            guard let urlString = urlString,
                  let url = URL(string: urlString) else { return }
            
            player = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("AVAudioSession/AVAudioPlayer error occured")
        }
    }
    
    @objc private func didTapBackButton(_ sender: UIButton) {
        if currentPage > 0 {
            currentPage = currentPage - 1
            player?.stop()
            configurePlayer()
            currentProgress = 0
            if isPlaying {
                player?.play()
            }
            collectionView.setContentOffset(CGPoint(x: CGFloat(currentPage) * collectionView.bounds.size.width, y: 0), animated: true)
        }
    }
    
    @objc private func didTapNextButton(_ sender: UIButton) {
        if currentPage < songs.count - 1 {
            currentPage = currentPage + 1
            player?.stop()
            configurePlayer()
            currentProgress = 0
            if isPlaying {
                player?.play()
            }
            collectionView.setContentOffset(CGPoint(x: CGFloat(currentPage) * collectionView.bounds.size.width, y: 0), animated: true)

        }
    }
    
    @objc private func didTapPlayPauseButton(_ sender: UIButton) {
        if player?.isPlaying == true {
            player?.pause()
            isPlaying = false
            timer?.invalidate()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
        } else {
            player?.play()
            isPlaying = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        }
    }
    
    @objc private func fireTimer() {
        currentProgress += 1
        let progress: Float = Float(currentProgress) / Float(songs[currentPage].length)
        progressView.setProgress(progress, animated: true)
    }
}

extension PlayerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicCell.reuseID, for: indexPath) as? MusicCell else { return UICollectionViewCell() }
        cell.imageView.image = songs[indexPath.item].image
        return cell
    }
}

extension PlayerViewController: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let scrollingPage = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        if currentPage == scrollingPage {
            return
        }
        currentPage = scrollingPage
        configurePlayer()
        currentProgress = 0
        if isPlaying {
            player?.play()
        }
    }
}

