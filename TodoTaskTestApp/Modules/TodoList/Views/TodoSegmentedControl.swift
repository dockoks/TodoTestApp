import UIKit

protocol SegmentedControlDelegate: AnyObject {
    func segmentedControl(_ segmentedControl: SegmentedControl, didSelect option: FilterOption)
}

final class SegmentedControl: UIView {
    weak var delegate: SegmentedControlDelegate?
    
    private let separatorView = UIView()
    private let allButton = SegmentedControlButton(style: .all)
    private let openButton = SegmentedControlButton(style: .open)
    private let closedButton = SegmentedControlButton(style: .closed)
    
    private var buttons: [SegmentedControlButton] = []
    private(set) var selectedOption: FilterOption = .all
    
    init(allCount: Int = 0, openCount: Int = 0, closedCount: Int = 0) {
        super.init(frame: .zero)
        
        allButton.updateCount(allCount)
        openButton.updateCount(openCount)
        closedButton.updateCount(closedCount)
        
        buttons = [allButton, openButton, closedButton]
        
        buttons.forEach {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(buttonTapped))
            $0.addGestureRecognizer(tapGesture)
        }
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.backgroundColor = ColorPalette.Outline.light
        
        let stackView = UIStackView()
        stackView.addArrangedSubview(allButton)
        stackView.addArrangedSubview(separatorView)
        stackView.addArrangedSubview(openButton)
        stackView.addArrangedSubview(closedButton)
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            separatorView.widthAnchor.constraint(equalToConstant: 2),
            separatorView.heightAnchor.constraint(equalToConstant: 24),
            
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        updateSelectedOption(animated: false)
    }
    
    private func updateSelectedOption(animated: Bool) {
        UIView.animate(withDuration: animated ? 0.3 : 0) { [weak self] in
            self?.buttons.forEach {
                $0.isSelected = $0.tag == self?.selectedOption.tag
            }
        }
    }
    
    @objc private func buttonTapped(_ sender: UITapGestureRecognizer) {
        guard let button = sender.view as? SegmentedControlButton,
              let option = FilterOption(tag: button.tag)
        else { return }
        selectedOption = option
        updateSelectedOption(animated: true)
        delegate?.segmentedControl(self, didSelect: selectedOption)
    }
    
    func updateCounts(all: Int, open: Int, closed: Int) {
        allButton.updateCount(all)
        openButton.updateCount(open)
        closedButton.updateCount(closed)
    }
    
    func selectSegment(option: FilterOption) {
        selectedOption = option
        updateSelectedOption(animated: true)
    }
}
