//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IFraktalNFT.sol";
import "./FraktalNFT.sol";
import "./FraktalMarket.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

/**
 * @title PaymentSplitter
 * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
 * that the Ether will be split in this way, since it is handled transparently by the contract.
 *
 * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
 * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
 * an amount proportional to the percentage of total shares they were assigned.
 *
 * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
 * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
 * function.
 */
contract PaymentSplitterUpgradeable is Initializable, ContextUpgradeable {
  event PayeeAdded(address account, uint256 shares);
  event PaymentReleased(address to, uint256 amount);
  event PaymentReceived(address from, uint256 amount);

  uint256 private _totalShares;
  uint256 private _totalReleased;

  mapping(address => uint256) private _shares;
  mapping(address => uint256) private _released;
  address[] private _payees;

  address tokenParent;
  uint256 fraktionsIndex;
  bool public buyout;
  address marketContract;

  /**
   * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
   * the matching position in the `shares` array.
   *
   * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
   * duplicates in `payees`.
   */
  function init(address[] memory payees, uint256[] memory shares_, address _marketContract)
    external
    initializer
  {
    __PaymentSplitter_init(payees, shares_);
    tokenParent = _msgSender();
    fraktionsIndex = FraktalNFT(_msgSender()).fraktionsIndex();
    buyout = FraktalNFT(_msgSender()).sold();
    marketContract = _marketContract;
  }

  function __PaymentSplitter_init(
    address[] memory payees,
    uint256[] memory shares_
  ) internal {
    __Context_init_unchained();
    __PaymentSplitter_init_unchained(payees, shares_);
  }

  function __PaymentSplitter_init_unchained(
    address[] memory payees,
    uint256[] memory shares_
  ) internal {
    require(
      payees.length == shares_.length,
      "PaymentSplitter: payees and shares length mismatch"
    );
    require(payees.length > 0, "PaymentSplitter: no payees");

    for (uint256 i = 0; i < payees.length; i++) {
      _addPayee(payees[i], shares_[i]);
    }
  }

  /**
   * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
   * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
   * reliability of the events, and not the actual splitting of Ether.
   *
   * To learn more about this see the Solidity documentation for
   * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
   * functions].
   */
  receive() external payable virtual {
    emit PaymentReceived(_msgSender(), msg.value);
  }

  /**
   * @dev Getter for the total shares held by payees.
   */
  function totalShares() external view returns (uint256) {
    return _totalShares;
  }

  /**
   * @dev Getter for the total amount of Ether already released.
   */
  function totalReleased() external view returns (uint256) {
    return _totalReleased;
  }

  /**
   * @dev Getter for the amount of shares held by an account.
   */
  function shares(address account) external view returns (uint256) {
    return _shares[account];
  }

  /**
   * @dev Getter for the amount of Ether already released to a payee.
   */
  function released(address account) external view returns (uint256) {
    return _released[account];
  }

  /**
   * @dev Getter for the address of the payee number `index`.
   */
  function payee(uint256 index) external view returns (address) {
    return _payees[index];
  }

  /**
   * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
   * total shares and their previous withdrawals.
   */
  function release() external virtual {
    address payable operator = payable(_msgSender());
    require(_shares[operator] > 0, "PaymentSplitter: account has no shares");
    if (buyout) {
      // uint256 bal = IFraktalNFT(tokenParent).getFraktions(_msgSender());
      uint256 bal = FraktalNFT(tokenParent).balanceOf(_msgSender(),FraktalNFT(tokenParent).fraktionsIndex());
      IFraktalNFT(tokenParent).soldBurn(_msgSender(), fraktionsIndex, bal);
    }

    uint256 totalReceived = address(this).balance + _totalReleased;
    uint256 payment = (totalReceived * _shares[operator]) /
      _totalShares -
      _released[operator];

    require(payment != 0, "PaymentSplitter: operator is not due payment");

    _released[operator] = _released[operator] + payment;
    _totalReleased = _totalReleased + payment;

    address payable marketPayable = payable(marketContract);
    uint16 marketFee = FraktalMarket(marketPayable).fee();

    uint256 forMarket = (payment * marketFee )/ 10000;
    uint256 forOperator = payment - forMarket;

    AddressUpgradeable.sendValue(operator, forOperator);
    AddressUpgradeable.sendValue(marketPayable, forMarket);
    emit PaymentReleased(operator, payment);
  }

  /**
   * @dev Add a new payee to the contract.
   * @param account The address of the payee to add.
   * @param shares_ The number of shares owned by the payee.
   */
  function _addPayee(address account, uint256 shares_) private {
    require(
      account != address(0),
      "PaymentSplitter: account is the zero address"
    );
    require(shares_ > 0, "PaymentSplitter: shares are 0");
    require(
      _shares[account] == 0,
      "PaymentSplitter: account already has shares"
    );

    _payees.push(account);
    _shares[account] = shares_;
    _totalShares = _totalShares + shares_;
    emit PayeeAdded(account, shares_);
  }

  uint256[45] private __gap;
}
