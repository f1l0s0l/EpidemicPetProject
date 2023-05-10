//
//  ConfigurationViewController.swift
//  EpidemicTestProject_issidorik
//
//  Created by Илья Сидорик on 05.05.2023.
//

import UIKit

final class ConfigurationViewController: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: IConfigurationViewModelProtocol
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var groupSizeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var infectionFactorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var timeIntervalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        return stackView
    }()
    
    private lazy var groupSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Количество людей в моделируемой группе"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var groupSizeValueTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray3
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private lazy var infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.text = "Количество людей, которое может быть заражено одним человеком при контакте"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var infectionFactorValueTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.backgroundColor = .systemGray3
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private lazy var timeIntervalLabel: UILabel = {
        let label = UILabel()
        label.text = "Период перерасчета количества зараженных людей"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var timeIntervalValueTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray3
        textField.keyboardType = .numberPad
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    private lazy var startSimulationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Next", for: .normal) // Start simulation
        button.backgroundColor = .blue
        button.addTarget(self, action: #selector(self.didTapStartSimulationButton), for: .touchUpInside)
        return button
    }()
    
    
    // MARK: - Lifecycles
    
    init(viewModel: IConfigurationViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupConstraints()
        self.setupGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didShowKeyboard(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil
        )
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(didHideKeyboard(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil
        )
    }

    
    // MARK: - Private methods
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.setupAddSubviews()
    }

    private func setupAddSubviews() {
        self.view.addSubview(self.scrollView)
        self.scrollView.addSubview(self.mainStackView)
        self.scrollView.addSubview(self.startSimulationButton)
        
        self.mainStackView.addArrangedSubview(self.groupSizeStackView)
        self.mainStackView.addArrangedSubview(self.infectionFactorStackView)
        self.mainStackView.addArrangedSubview(self.timeIntervalStackView)

        self.groupSizeStackView.addArrangedSubview(self.groupSizeLabel)
        self.groupSizeStackView.addArrangedSubview(self.groupSizeValueTextField)

        self.infectionFactorStackView.addArrangedSubview(self.infectionFactorLabel)
        self.infectionFactorStackView.addArrangedSubview(self.infectionFactorValueTextField)

        self.timeIntervalStackView.addArrangedSubview(self.timeIntervalLabel)
        self.timeIntervalStackView.addArrangedSubview(self.timeIntervalValueTextField)
    }
    
    private func setupGestureRecognizer() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapToSuperView))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    
    @objc
    private func didTapStartSimulationButton() {
        self.viewModel.didTabStartButton(
            groupSizeValue: self.groupSizeValueTextField.text,
            infectionFactorValue: self.infectionFactorValueTextField.text,
            timeIntervalValue: self.timeIntervalValueTextField.text
        )
        self.dismiss(animated: true)
    }
    
    @objc
    private func didHideKeyboard(_ notification: Notification) {
        self.scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
    
    @objc
    private func didShowKeyboard(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {

            let keyboardHeight = keyboardFrame.cgRectValue.height
            
            let buttonBottomPointY = self.startSimulationButton.frame.origin.y + self.startSimulationButton.frame.height
            let keyboardOriginY = self.scrollView.frame.height - keyboardHeight
            
            let yOffset = keyboardOriginY < buttonBottomPointY ? buttonBottomPointY - keyboardOriginY + 20 : 0
            
            self.scrollView.contentOffset = CGPoint(x: 0, y: yOffset)
        }
    }
    
    @objc
    private func didTapToSuperView() {
        self.view.endEditing(true)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            self.scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.mainStackView.centerYAnchor.constraint(equalTo: self.scrollView.centerYAnchor),
            self.mainStackView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.mainStackView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),

            self.startSimulationButton.topAnchor.constraint(equalTo: self.mainStackView.bottomAnchor, constant: 10),
            self.startSimulationButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10),
            self.startSimulationButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10),
            self.startSimulationButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

}


