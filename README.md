# P2P Security Smart Contract

## Overview

This project implements a Peer-to-Peer (P2P) security smart contract using Clarity, the smart contract language for the Stacks blockchain. The contract facilitates the secure buying and selling of products, ensuring that funds are held in escrow until the delivery is confirmed by the buyer. The key features of the contract include adding products, placing orders, confirming delivery, and releasing funds.

## Contract Functions

### Data Variables

- `products`: A map that stores product details (name, price, quantity) against a product ID.
- `orders`: A map that stores order details (buyer, quantity, delivery status) against a product ID.
- `escrow`: A map that stores escrow details (seller, amount) against a product ID.

### Public Functions

1. **add-product**
   ```clarity
   (add-product (product-id u256) (name text) (price u128) (quantity u256))
   ```
   Adds a new product to the `products` map.

   **Parameters:**
   - `product-id`: Unique identifier for the product.
   - `name`: Name of the product.
   - `price`: Price of the product.
   - `quantity`: Available quantity of the product.

   **Returns:**
   - A success message if the product is added successfully.

2. **place-order**
   ```clarity
   (place-order (product-id u256) (quantity u128))
   ```
   Places an order for a specified quantity of a product.

   **Parameters:**
   - `product-id`: Unique identifier for the product.
   - `quantity`: Quantity to order.

   **Returns:**
   - A success message if the order is placed successfully.
   - An error message if the product is not available or there is insufficient quantity.

3. **confirm-delivery**
   ```clarity
   (confirm-delivery (product-id u256))
   ```
   Confirms the delivery of an ordered product by the buyer.

   **Parameters:**
   - `product-id`: Unique identifier for the product.

   **Returns:**
   - A success message if the delivery is confirmed and funds are held in escrow.
   - An error message if the order is invalid or delivery is already confirmed.

4. **release-funds**
   ```clarity
   (release-funds (product-id u256))
   ```
   Releases funds from escrow to the seller once the buyer confirms the delivery.

   **Parameters:**
   - `product-id`: Unique identifier for the product.

   **Returns:**
   - A success message if the funds are released to the seller.
   - An error message if the order is invalid or the release is unauthorized.

### Read-Only Functions

1. **get-product**
   ```clarity
   (get-product (product-id u256))
   ```
   Retrieves the details of a product.

   **Parameters:**
   - `product-id`: Unique identifier for the product.

   **Returns:**
   - Product details if found.

2. **get-order**
   ```clarity
   (get-order (product-id u256))
   ```
   Retrieves the details of an order.

   **Parameters:**
   - `product-id`: Unique identifier for the product.

   **Returns:**
   - Order details if found.

3. **get-escrow**
   ```clarity
   (get-escrow (product-id u256))
   ```
   Retrieves the escrow details for a product.

   **Parameters:**
   - `product-id`: Unique identifier for the product.

   **Returns:**
   - Escrow details if found.

## Usage

1. **Add a Product**
   ```clarity
   (add-product product-id name price quantity)
   ```
   Example:
   ```clarity
   (add-product u1 "Laptop" u1000 u10)
   ```

2. **Place an Order**
   ```clarity
   (place-order product-id quantity)
   ```
   Example:
   ```clarity
   (place-order u1 u2)
   ```

3. **Confirm Delivery**
   ```clarity
   (confirm-delivery product-id)
   ```
   Example:
   ```clarity
   (confirm-delivery u1)
   ```

4. **Release Funds**
   ```clarity
   (release-funds product-id)
   ```
   Example:
   ```clarity
   (release-funds u1)
   ```

## Error Handling

The contract functions use error handling to ensure that invalid operations are not executed. For example, if an order is placed for a quantity greater than available, the contract returns an error message indicating insufficient quantity.

## License

This project is licensed under the MIT License. See the LICENSE file for more details.
