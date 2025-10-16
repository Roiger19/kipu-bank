// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title KipuBank
 * @author Juan Pablo Soto Roig
 * @notice A bank vault contract that allows users to deposit and withdraw ETH
 * @dev Implements withdrawal limits per transaction and a global deposit cap.
 * Corrections applied based on feedback regarding modifiers, state access, and unchecked blocks.
 */
contract KipuBank {
    
    // STATE VARIABLES
    

    /// @notice Maximum withdrawal limit per transaction (0.1 ETH)
    /// @dev Immutable variable set in the constructor
    uint256 public immutable MAX_WITHDRAW_AMOUNT;

    /// @notice Global deposit cap that the bank can hold
    /// @dev Immutable variable set in the constructor
    uint256 public immutable BANK_CAP;

    /// @notice Mapping that stores the balance of each user
    /// @dev Maps user address to their balance in wei
    mapping(address => uint256) private clientFunds;

    /// @notice Total counter of deposits made
    uint256 public depositCount;

    /// @notice Total counter of withdrawals made
    uint256 public totalTransactionsOut;

    
    // EVENTS
    

    /// @notice Emitted when a user makes a successful deposit
    /// @param user Address of the user who deposited
    /// @param amount Amount deposited in wei
    /// @param newBalance New balance of the user after the deposit
    event Deposit(address indexed user, uint256 amount, uint256 newBalance);

    /// @notice Emitted when a user makes a successful withdrawal
    /// @param user Address of the user who withdrew
    /// @param amount Amount withdrawn in wei
    /// @param newBalance New balance of the user after the withdrawal
    event Withdrawal(address indexed user, uint256 amount, uint256 newBalance);

    
    // CUSTOM ERRORS
    

    /// @notice Error when the deposit or withdrawal amount is zero
    error ZeroAmount();

    /// @notice Error when the deposit would exceed the bank's global cap
    /// @param attempted Amount that was attempted to deposit
    /// @param available Available space in the bank
    error BankCapExceeded(uint256 attempted, uint256 available);

    /// @notice Error when the user tries to withdraw more than their balance
    /// @param requested Amount requested for withdrawal
    /// @param available User's available balance
    error InsufficientBalance(uint256 requested, uint256 available);

    /// @notice Error when the withdrawal exceeds the limit per transaction
    /// @param requested Amount requested for withdrawal
    /// @param limit Maximum limit allowed
    error WithdrawalLimitExceeded(uint256 requested, uint256 limit);

    /// @notice Error when the ETH transfer fails
    error TransferFailed();

    
    // MODIFIERS
    

    /// @notice Verifies that an amount is greater than zero
    /// @param _amount Amount to verify
    modifier requireValidAmount(uint256 _amount) {
        if (_amount == 0) revert ZeroAmount();
        _;
    }

    /// @notice Checks if a deposit would exceed the bank's total capacity
    modifier withinBankCap() {
        // address(this).balance ya incluye el msg.value de la transacción actual
        uint256 currentBalance = address(this).balance;
        if (currentBalance > BANK_CAP) {
            revert BankCapExceeded(msg.value, BANK_CAP - (currentBalance - msg.value));
        }
        _;
    }

    /// @notice Checks if the user has enough balance for a withdrawal
    /// @param _amount The amount to be withdrawn
    modifier hasSufficientBalance(uint256 _amount) {
        uint256 userBalance = clientFunds[msg.sender];
        if (_amount > userBalance) {
            revert InsufficientBalance(_amount, userBalance);
        }
        _;
    }

    /// @notice Checks if a withdrawal amount is within the allowed limit
    /// @param _amount The amount to be withdrawn
    modifier withinWithdrawalLimit(uint256 _amount) {
        if (_amount > MAX_WITHDRAW_AMOUNT) {
            revert WithdrawalLimitExceeded(_amount, MAX_WITHDRAW_AMOUNT);
        }
        _;
    }

    
    // CONSTRUCTOR
    

    /// @notice Initializes the contract with the established limits
    /// @param _withdrawalLimit Maximum withdrawal limit per transaction
    /// @param _bankCap Global deposit cap of the bank
    constructor(uint256 _withdrawalLimit, uint256 _bankCap) {
        MAX_WITHDRAW_AMOUNT = _withdrawalLimit;
        BANK_CAP = _bankCap;
    }

    
    // EXTERNAL FUNCTIONS
    

    /// @notice Allows users to deposit ETH into their personal vault
    /// @dev Verifies that the bank's global cap is not exceeded
    function addFunds() external payable requireValidAmount(msg.value) withinBankCap {
        // Effects
        uint256 currentBalance = clientFunds[msg.sender];
        uint256 newBalance;

        // Unchecked block to save gas, as cap check implicitly helps prevent overflow
        unchecked {
            newBalance = currentBalance + msg.value;
        }

        clientFunds[msg.sender] = newBalance;
        depositCount++;

        // Interactions
        emit Deposit(msg.sender, msg.value, newBalance);
    }

    /// @notice Allows users to withdraw ETH from their personal vault
    /// @param amount Amount to withdraw in wei
    /// @dev Verifies that the user has sufficient balance and respects the withdrawal limit
    function withdraw(uint256 amount)
        external
        requireValidAmount(amount)
        hasSufficientBalance(amount)
        withinWithdrawalLimit(amount)
    {
        // Effects
        uint256 currentBalance = clientFunds[msg.sender];
        uint256 newBalance;

        // Unchecked block to save gas since hasSufficientBalance modifier prevents underflow
        unchecked {
            newBalance = currentBalance - amount;
        }

        clientFunds[msg.sender] = newBalance;
        totalTransactionsOut++;

        // Interactions
        _transferETH(msg.sender, amount);

        emit Withdrawal(msg.sender, amount, newBalance);
    }

    /// @notice Gets the balance of a specific user
    /// @param user User's address
    /// @return User's balance in wei
    function getBalance(address user) external view returns (uint256) {
        return clientFunds[user];
    }

    /// @notice Gets the balance of the caller
    /// @return User's balance in wei
    function checkMyFunds() external view returns (uint256) {
        return clientFunds[msg.sender];
    }

    /// @notice Gets the total balance of the contract
    /// @return Total bank balance in wei
    function getBankBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @notice Gets the available space in the bank for new deposits
    /// @return Available space in wei
    function getAvailableCapacity() external view returns (uint256) {
        uint256 currentBalance = address(this).balance;
        if (currentBalance >= BANK_CAP) return 0;
        return BANK_CAP - currentBalance;
    }


    // PRIVATE FUNCTIONS


    /// @notice Safely transfers ETH to an address
    /// @param to Recipient address
    /// @param amount Amount to transfer in wei
    /// @dev Reverts if the transfer fails
    function _transferETH(address to, uint256 amount) private {
        (bool success, ) = to.call{value: amount}("");
        if (!success) revert TransferFailed();
    }
}

