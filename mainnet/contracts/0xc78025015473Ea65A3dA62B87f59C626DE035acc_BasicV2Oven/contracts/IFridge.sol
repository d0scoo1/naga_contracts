interface IFridge {
    function valuate(uint256 ethAmount) external returns (uint256 tokenValue);
    function updatePrice() external;
}