pragma solidity ^0.5.0;

import "./openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";

interface ILendingPoolAddressesProvider {
    function getLendingPoolCore() external view returns (address payable);
    function getLendingPool() external view returns (address);
}

interface ILendingPool {
  function addressesProvider () external view returns ( address );
  function deposit ( address _reserve, uint256 _amount, uint16 _referralCode ) external payable;
  function redeemUnderlying ( address _reserve, address _user, uint256 _amount ) external;
  function borrow ( address _reserve, uint256 _amount, uint256 _interestRateMode, uint16 _referralCode ) external;
  function repay ( address _reserve, uint256 _amount, address _onBehalfOf ) external payable;
  function swapBorrowRateMode ( address _reserve ) external;
  function rebalanceFixedBorrowRate ( address _reserve, address _user ) external;
  function setUserUseReserveAsCollateral ( address _reserve, bool _useAsCollateral ) external;
  function liquidationCall ( address _collateral, address _reserve, address _user, uint256 _purchaseAmount, bool _receiveAToken ) external payable;
  function flashLoan ( address _receiver, address _reserve, uint256 _amount, bytes calldata _params ) external;
  function getReserveConfigurationData ( address _reserve ) external view returns ( uint256 ltv, uint256 liquidationThreshold, uint256 liquidationDiscount, address interestRateStrategyAddress, bool usageAsCollateralEnabled, bool borrowingEnabled, bool fixedBorrowRateEnabled, bool isActive );
  function getReserveData ( address _reserve ) external view returns ( uint256 totalLiquidity, uint256 availableLiquidity, uint256 totalBorrowsFixed, uint256 totalBorrowsVariable, uint256 liquidityRate, uint256 variableBorrowRate, uint256 fixedBorrowRate, uint256 averageFixedBorrowRate, uint256 utilizationRate, uint256 liquidityIndex, uint256 variableBorrowIndex, address aTokenAddress, uint40 lastUpdateTimestamp );
  function getUserAccountData ( address _user ) external view returns ( uint256 totalLiquidityETH, uint256 totalCollateralETH, uint256 totalBorrowsETH, uint256 availableBorrowsETH, uint256 currentLiquidationThreshold, uint256 ltv, uint256 healthFactor );
  function getUserReserveData ( address _reserve, address _user ) external view returns ( uint256 currentATokenBalance, uint256 currentUnderlyingBalance, uint256 currentBorrowBalance, uint256 principalBorrowBalance, uint256 borrowRateMode, uint256 borrowRate, uint256 liquidityRate, uint256 originationFee, uint256 variableBorrowIndex, uint256 lastUpdateTimestamp, bool usageAsCollateralEnabled );
  function getReserves () external view;
}

contract AaveDepositRedeem {

  function aaveDeposit(
    address _erc20Address,
    uint256 _amount,
    uint16 _referral
  ) external {
      /// Retrieve LendingPool address
      ILendingPoolAddressesProvider provider = ILendingPoolAddressesProvider(address(0x506B0B2CF20FAA8f38a4E2B524EE43e1f4458Cc5)); // kovan address, for other addresses: https://docs.aave.com/developers/developing-on-aave/deployed-contract-instances
      ILendingPool lendingPool = ILendingPool(provider.getLendingPool());
      address erc20Address = address(_erc20Address);
      uint256 amount = _amount * 1e18;
      uint16 referral = _referral;
      // Approve LendingPool contract to move your WBTC
      IERC20(erc20Address).approve(provider.getLendingPoolCore(), amount);
      // Deposit wbtcBought WBTC
      lendingPool.deposit(erc20Address, amount, referral);
    }
/*
  function aaveRedeem(uint256 _amount) external {
    /// Instantiation of the aToken address
    aToken aTokenInstance = AToken("0xCD5C52C7B30468D16771193C47eAFF43EFc47f5C"); // aWTBC address kovan testnet
    /// Input variables
    uint256 amount = _amount * 1e18;
    /// redeem method call
    aTokenInstance.redeem(amount);
  }
*/
}
