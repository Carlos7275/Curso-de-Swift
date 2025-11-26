import UIKit
import AVFoundation

class VideoCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    // MARK: - Player
    var player: AVPlayer?
    private var playerLayer = AVPlayerLayer()
    private var timeObserverToken: Any?
    var playbackEnded: (() -> Void)?

    // MARK: - UI
    private let loader: UIActivityIndicatorView = {
        let l = UIActivityIndicatorView(style: .large)
        l.color = .white
        l.hidesWhenStopped = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 20)
        label.numberOfLines = 2
        return label
    }()

    private let gradientLayer: CAGradientLayer = {
        let g = CAGradientLayer()
        g.colors = [UIColor.clear.cgColor,
                    UIColor.black.withAlphaComponent(0.9).cgColor]
        g.locations = [0.6, 1.0]
        return g
    }()

    private let pauseIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "pause.fill"))
        iv.tintColor = .white
        iv.alpha = 0
        iv.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        return iv
    }()


    private let progressContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        return view
    }()

    private let progressBar: UIProgressView = {
        let progress = UIProgressView(progressViewStyle: .default)
        progress.trackTintColor = UIColor.white.withAlphaComponent(0.3)
        progress.progressTintColor = .white
        progress.progress = 0
        return progress
    }()

    private let progressThumb: UIView = {
        let thumb = UIView()
        thumb.backgroundColor = .white
        thumb.layer.cornerRadius = 7.5
        thumb.isHidden = true
        return thumb
    }()

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.textAlignment = .center
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.isHidden = true
        return label
    }()

    private var isDraggingProgress = false

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupVideo()
        setupGradient()
        setupTitle()
        setupAnimationIcons()
        setupProgressBar()
        setupGestures()
        setupLoader()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
        gradientLayer.frame = bounds
        progressContainer.frame = CGRect(x: 0, y: bounds.height - 60, width: bounds.width, height: 50)
        progressThumb.center.y = progressBar.center.y
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        player?.pause()
        if let token = timeObserverToken {
            player?.removeTimeObserver(token)
            timeObserverToken = nil
        }
        NotificationCenter.default.removeObserver(self)
        progressBar.progress = 0
        pauseIcon.alpha = 0
        progressThumb.isHidden = true
        timeLabel.isHidden = true
        loader.stopAnimating()
        player = nil
        playbackEnded = nil
    }

    // MARK: - Setup UI
    private func setupVideo() {
        playerLayer.videoGravity = .resizeAspectFill
        layer.insertSublayer(playerLayer, at: 0)
    }

    private func setupGradient() {
        layer.addSublayer(gradientLayer)
    }

    private func setupTitle() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16)
        ])
    }

    private func setupAnimationIcons() {
        addSubview(pauseIcon)
        pauseIcon.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pauseIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
            pauseIcon.centerYAnchor.constraint(equalTo: centerYAnchor),
            pauseIcon.widthAnchor.constraint(equalToConstant: 90),
            pauseIcon.heightAnchor.constraint(equalToConstant: 90)
        ])

       
    }

    private func setupProgressBar() {
        addSubview(progressContainer)
        progressContainer.addSubview(progressBar)
        progressContainer.addSubview(progressThumb)
        progressContainer.addSubview(timeLabel)
        
        progressContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressContainer.leftAnchor.constraint(equalTo: leftAnchor),
            progressContainer.rightAnchor.constraint(equalTo: rightAnchor),
            progressContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            progressContainer.heightAnchor.constraint(equalToConstant: 50)
        ])

        progressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressBar.leftAnchor.constraint(equalTo: progressContainer.leftAnchor, constant: 16),
            progressBar.rightAnchor.constraint(equalTo: progressContainer.rightAnchor, constant: -16),
            progressBar.centerYAnchor.constraint(equalTo: progressContainer.centerYAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 3)
        ])
        
        // Thumb constraints
        progressThumb.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressThumb.widthAnchor.constraint(equalToConstant: 15),
            progressThumb.heightAnchor.constraint(equalToConstant: 15),
            progressThumb.centerYAnchor.constraint(equalTo: progressBar.centerYAnchor),
            progressThumb.leadingAnchor.constraint(equalTo: progressBar.leadingAnchor) // posición inicial
        ])
        
        // Time label constraints
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timeLabel.widthAnchor.constraint(equalToConstant: 120),
            timeLabel.heightAnchor.constraint(equalToConstant: 22),
            timeLabel.bottomAnchor.constraint(equalTo: progressBar.topAnchor, constant: -8),
            timeLabel.leadingAnchor.constraint(equalTo: progressThumb.leadingAnchor) // se moverá con el thumb
        ])

        let pan = UIPanGestureRecognizer(target: self, action: #selector(progressBarPanned(_:)))
        pan.delegate = self
        progressContainer.addGestureRecognizer(pan)
    }


    private func setupGestures() {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapPlayPause))
        addGestureRecognizer(tap)

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTapLike))
        doubleTap.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTap)
        tap.require(toFail: doubleTap)
    }

    private func setupLoader() {
        addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func tapPlayPause() {
        guard let player = player else { return }
        if player.timeControlStatus == .paused {
            player.play()
            resumeAnimation()
        } else {
            player.pause()
            pauseAnimation()
        }
    }

    @objc private func doubleTapLike(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: self)
      
    }

    @objc private func progressBarPanned(_ gesture: UIPanGestureRecognizer) {
        guard let player = player, let duration = player.currentItem?.duration else { return }
        let location = gesture.location(in: progressContainer)
        let clampedX = min(max(location.x, 0), progressContainer.bounds.width)
        let progress = clampedX / progressContainer.bounds.width
        let seconds = Double(progress) * CMTimeGetSeconds(duration)

        switch gesture.state {
        case .began, .changed:
            isDraggingProgress = true
            progressThumb.isHidden = false
            timeLabel.isHidden = false
            progressThumb.center.x = clampedX
            progressThumb.center.y = progressBar.center.y
            progressBar.progress = Float(progress)
            let currentTimeText = formatTime(seconds: seconds)
            let totalTimeText = formatTime(seconds: CMTimeGetSeconds(duration))
            timeLabel.text = "\(currentTimeText) / \(totalTimeText)"
            timeLabel.center = CGPoint(x: clampedX, y: progressBar.frame.minY - 20)
            let seekTime = CMTime(seconds: seconds, preferredTimescale: 600)
            player.seek(to: seekTime, toleranceBefore: .zero, toleranceAfter: .zero)
        case .ended, .cancelled:
            isDraggingProgress = false
            progressThumb.isHidden = true
            timeLabel.isHidden = true
        default: break
        }
    }

    private func formatTime(seconds: Double) -> String {
        let mins = Int(seconds) / 60
        let secs = Int(seconds) % 60
        return String(format: "%02d:%02d", mins, secs)
    }

    // MARK: - Player Control
    func configure(videoURL: URL, title: String, playbackEnd: @escaping () -> Void) {
        titleLabel.text = title
        playbackEnded = playbackEnd

        loader.startAnimating()
        let playerItem = AVPlayerItem(url: videoURL)
        player = AVPlayer(playerItem: playerItem)
        playerLayer.player = player
        player?.volume = 0.5

        // Observador para el estado de carga
        var statusObserver: NSKeyValueObservation?
        statusObserver = playerItem.observe(\.status, options: [.new, .initial]) { [weak self] item, _ in
            guard let self = self else { return }
            if item.status == .readyToPlay {
                DispatchQueue.main.async {
                    self.loader.stopAnimating()
                    self.addPeriodicTimeObserver()
                    self.addEndObserver()
                }
                statusObserver?.invalidate()
            }
        }

        // Posicionar progreso inicial
        progressBar.progress = 0
        progressThumb.center.x = 0
        progressThumb.center.y = progressBar.center.y
        timeLabel.center = CGPoint(x: 0, y: progressBar.frame.minY - 20)
        progressThumb.isHidden = true
        timeLabel.isHidden = true
    }

    func play() { player?.play() }
    func pause() { player?.pause() }

    // MARK: - Animations
    private func pauseAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            self.pauseIcon.alpha = 1
            self.pauseIcon.transform = .identity
        }
    }

    private func resumeAnimation() {
        UIView.animate(withDuration: 0.2) {
            self.contentView.transform = .identity
            self.pauseIcon.alpha = 0
            self.pauseIcon.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
        }
    }

  

    // MARK: - Progress Observer
    private func addPeriodicTimeObserver() {
        guard let player = player else { return }
        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserverToken = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self, let duration = player.currentItem?.duration else { return }
            guard !self.isDraggingProgress else { return }
            let totalSeconds = CMTimeGetSeconds(duration)
            if totalSeconds > 0 {
                let currentSeconds = CMTimeGetSeconds(time)
                let progress = Float(currentSeconds / totalSeconds)
                self.progressBar.progress = progress
                self.progressThumb.center.x = CGFloat(progress) * self.progressContainer.bounds.width
            }
        }
    }

    private func addEndObserver() {
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                               object: player?.currentItem,
                                               queue: .main) { [weak self] _ in
            self?.playbackEnded?()
        }
    }
}
