  //
  //  HekaComponent.swift
  //
  //
  //  Created by Gaurav Tiwari on 12/04/23.
  //

import UIKit

public final class HekaComponent: UIView {
  
  struct Constant {
    static let padding: CGFloat = 8
    static let containerHeight: CGFloat = 80
    static let imageSize: CGFloat = 25
    static let buttonWidth: CGFloat = 100
    static let buttonHeight: CGFloat = 100
  }
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let button = UIButton(type: .system)
  
  var viewModel: ComponentViewModel
  
  public init(uuid: String, apiKey: String) {
    viewModel = ComponentViewModel(uuid: uuid, apiKey: apiKey)
    super.init(frame: .zero)
    setupSubviews()
  }
  
  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
    // MARK: - Lifecycle
  public override func layoutSubviews() {
    super.layoutSubviews()
    layer.shadowPath = UIBezierPath(
      roundedRect: bounds, cornerRadius: layer.cornerRadius
    ).cgPath
  }
  
  public override func didMoveToSuperview() {
    viewModel.checkConnectionStatus()
  }
  
    // MARK: - Actions
  @objc private func buttonTapped() {
    switch viewModel.currentConnectionState {
      case .notConnected:
        viewModel.checkHealthKitPermissions()
      case .syncing:
        break
      case .connected:
          // TODO: - Maybe add some sort of confirmation
        viewModel.disconnectFromServer()
    }
  }
}

  //MARK: - Configurations
private extension HekaComponent {
  func prepareView() {
    backgroundColor = .systemBackground
    layer.cornerRadius = 8
    layer.shadowRadius = 8
    layer.shadowOpacity = 1
    layer.shadowOffset = .zero
    layer.shadowColor = UIColor.black.cgColor
    layer.masksToBounds = false
    clipsToBounds = false
    isUserInteractionEnabled = true
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  func prepareAppleImageView() -> [NSLayoutConstraint] {
    imageView.image = UIImage(
      named: "appleHealthKit", in: HekaResources.resourceBundle, compatibleWith: nil
    )
    imageView.contentMode = .scaleAspectFit
    imageView.backgroundColor = .red
    imageView.layer.masksToBounds = true
    imageView.layer.cornerRadius = 25 / 2
    addSubview(imageView)
    return [
      imageView.leadingAnchor.constraint(
        equalTo: leadingAnchor, constant: Constant.padding
      ),
      imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
      imageView.widthAnchor.constraint(equalToConstant: Constant.imageSize),
      imageView.heightAnchor.constraint(equalToConstant: Constant.imageSize)
    ]
  }
  
  func prepareTitleLabel() -> [NSLayoutConstraint] {
    titleLabel.text = "Apple HealthKit"
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    addSubview(titleLabel)
    return [
      titleLabel.leadingAnchor.constraint(
        equalTo: imageView.trailingAnchor, constant: Constant.padding
      ),
      titleLabel.topAnchor.constraint(
        equalTo: topAnchor, constant: Constant.padding
      ),
      titleLabel.trailingAnchor.constraint(
        equalTo: button.leadingAnchor, constant: -Constant.padding
      )
    ]
  }
  
  func prepareSubTitleLabel() -> [NSLayoutConstraint] {
    subtitleLabel.font = UIFont.systemFont(ofSize: 12)
    subtitleLabel.textColor = .gray
    addSubview(subtitleLabel)
    return [
      subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      subtitleLabel.topAnchor.constraint(
        equalTo: titleLabel.bottomAnchor, constant: Constant.padding
      ),
      subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
    ]
  }
  
  func prepareActionButton() -> [NSLayoutConstraint] {
    button.setTitle(viewModel.buttonTitle, for: .normal)
    button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    button.layer.cornerRadius = Constant.buttonHeight/2
    button.backgroundColor = .secondarySystemBackground
    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    button.setTitleColor(.darkText, for: .normal)
    addSubview(button)
    return [
      button.trailingAnchor.constraint(
        equalTo: trailingAnchor, constant: -Constant.padding
      ),
      button.centerYAnchor.constraint(equalTo: centerYAnchor),
      button.widthAnchor.constraint(equalToConstant: Constant.buttonWidth),
      button.heightAnchor.constraint(equalToConstant: Constant.buttonHeight)
    ]
  }
  
  func setupSubviews() {
    prepareView()
    var allConstraings = [
      heightAnchor.constraint(equalToConstant: Constant.containerHeight)
    ]
    allConstraings.append(contentsOf: prepareAppleImageView())
    allConstraings.append(contentsOf: prepareTitleLabel())
    allConstraings.append(contentsOf: prepareSubTitleLabel())
    allConstraings.append(contentsOf: prepareActionButton())
    NSLayoutConstraint.activate(allConstraings)
  }
}
