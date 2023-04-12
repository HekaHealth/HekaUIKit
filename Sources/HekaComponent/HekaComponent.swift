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
    static let buttonHeight: CGFloat = 40
  }
  
  private let imageView = UIImageView()
  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let button = UIButton(type: .system)
  private var titleStackView = UIStackView(frame: .zero)

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
    layer.shadowColor = UIColor.lightGray.cgColor
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
    imageView.layer.masksToBounds = true
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
  
  func prepareTitleStack() -> [NSLayoutConstraint] {
    titleStackView.axis = .vertical
    titleStackView.spacing = Constant.padding
    
    titleLabel.text = "Apple HealthKit"
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    titleLabel.textColor = .darkGray
    titleLabel.numberOfLines = 1
    
    subtitleLabel.font = UIFont.systemFont(ofSize: 12)
    subtitleLabel.textColor = .lightText
    subtitleLabel.numberOfLines = 1

    titleStackView.addArrangedSubview(titleLabel)
    titleStackView.addArrangedSubview(subtitleLabel)

    addSubview(titleStackView)
    return [
      titleStackView.leadingAnchor.constraint(
        equalTo: imageView.trailingAnchor, constant: Constant.padding
      ),
      titleStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
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
      button.leadingAnchor.constraint(
        greaterThanOrEqualTo: titleStackView.trailingAnchor,
        constant: Constant.padding
      ),
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
//    allConstraings.append(contentsOf: prepareTitleStack())
//    allConstraings.append(contentsOf: prepareActionButton())
    NSLayoutConstraint.activate(allConstraings)
  }
}
