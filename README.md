# Decentralized Marketplace Smart Contract

## Overview

This project implements a decentralized marketplace smart contract facilitating secure buying and selling of products with an integrated escrow system. The contract is written in Clarity for the Stacks blockchain.

## Features

- Product listing
- Order placement
- Delivery confirmation
- Secure fund release via escrow

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