# Decentralized Marketplace Smart Contract

## Overview

This project implements a decentralized marketplace smart contract facilitating secure buying and selling of products with an integrated escrow system. The contract is written in Clarity for the Stacks blockchain.

## Features
1. Product Listing

This feature allows sellers to add products to the marketplace. Here's how it works:

- Sellers can call the `add-product` function to list a new product.
- Each product is assigned a unique `product-id` (u256 type).
- Product details include:
  - Name (string-ascii 256)
  - Price (u128)
  - Quantity available (u256)
- The contract stores this information in separate maps:
  - `product-names`
  - `product-prices`
  - `product-quantities`
- This separation allows for efficient updates and retrieval of product information.

2. Order Placement

This feature enables buyers to place orders for listed products:

- Buyers use the `place-order` function, specifying the `product-id` and desired `quantity`.
- The contract checks if the requested quantity is available.
- If available, the order is recorded in the following maps:
  - `order-buyers`: Records who placed the order
  - `order-quantities`: Records the quantity ordered
  - `order-delivered`: Initially set to false
- The available product quantity is reduced accordingly.
- If the order can't be fulfilled (e.g., insufficient quantity), the transaction fails with an error message.

3. Delivery Confirmation

This step allows sellers to confirm that they've delivered the product:

- The seller calls the `confirm-delivery` function with the `product-id`.
- The contract checks if:
  - The order exists
  - It hasn't been delivered yet
  - The caller (tx-sender) is the authorized seller
- If conditions are met, the contract:
  - Marks the order as delivered in the `order-delivered` map
  - Calculates the total amount (price * quantity)
  - Records this information in the escrow maps

4. Secure Fund Release via Escrow

This feature ensures that funds are securely held and only released upon confirmation:

- When an order is placed, funds are not immediately transferred to the seller.
- After delivery confirmation, funds are held in escrow, recorded in:
  - `escrow-sellers`: Maps the product to the seller who should receive the funds
  - `escrow-amounts`: Records the amount held in escrow
- The buyer can then call the `release-funds` function to release the funds to the seller.
- The contract verifies that:
  - The order exists
  - There are funds in escrow
  - The caller (tx-sender) is the original buyer
- If all checks pass, the contract:
  - Transfers the funds from the buyer to the seller using `stx-transfer?`
  - Clears the escrow records for this transaction

This escrow system adds a layer of security, ensuring that:
- Sellers are motivated to deliver the product, as they don't receive funds until after delivery.
- Buyers have control over fund release, protecting them from non-delivery.
- The smart contract acts as a trusted intermediary, holding funds securely until conditions are met.

These features work together to create a trustless environment for e-commerce transactions, leveraging the security and transparency of blockchain technology.

## Smart Contract Structure

### Data Maps

1. **Products**
   - `product-names`: Maps product ID to name
   - `product-prices`: Maps product ID to price
   - `product-quantities`: Maps product ID to available quantity

2. **Orders**
   - `order-buyers`: Maps product ID to buyer's principal
   - `order-quantities`: Maps product ID to ordered quantity
   - `order-delivered`: Maps product ID to delivery status

3. **Escrow**
   - `escrow-sellers`: Maps product ID to seller's principal
   - `escrow-amounts`: Maps product ID to amount in escrow

### Public Functions

1. `add-product`: Add a new product to the marketplace
2. `place-order`: Place an order for a product
3. `confirm-delivery`: Confirm delivery of an order
4. `release-funds`: Release funds from escrow to the seller

### Read-Only Functions

1. `get-product`: Retrieve product details
2. `get-order`: Retrieve order details
3. `get-escrow`: Retrieve escrow details

## Usage

### Adding a Product

```clarity
(add-product product-id name price quantity)
```

### Placing an Order

```clarity
(place-order product-id quantity)
```

### Confirming Delivery

```clarity
(confirm-delivery product-id)
```

### Releasing Funds

```clarity
(release-funds product-id)
```

### Retrieving Information

```clarity
(get-product product-id)
(get-order product-id)
(get-escrow product-id)
```

## Security Considerations

- The contract includes checks for product availability and order validity.
- Escrow system ensures funds are held securely until delivery is confirmed.
- Only the buyer can release funds, preventing unauthorized transfers.

## Development and Testing

To test this contract:

1. Set up a Clarity development environment.
2. Deploy the contract to a testnet.
3. Use the provided functions to interact with the contract.
4. Verify each step of the buying and selling process.

## Future Improvements

- Implement a rating system for buyers and sellers.
- Add support for multiple currency types.
- Introduce a dispute resolution mechanism.

## Contributing

Contributions are welcome! Please fork the repository and submit a pull request with your proposed changes.

## License

This project is licensed under the MIT License. 