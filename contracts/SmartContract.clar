;; title: contractSecurity
;; version: 1.0
;; summary: A secure e-commerce smart contract for product listings, orders, and escrow.
;; description: This Clarity contract allows users to add products, place orders, confirm deliveries, and release funds securely within an e-commerce ecosystem.


(define-map product-names u256 (string-ascii 500))
(define-map product-prices u256 u128)
(define-map product-quantities u256 u256)

(define-map order-buyers u256 principal)
(define-map order-quantities u256 u128)
(define-map order-delivered u256 bool)

(define-map escrow-sellers u256 principal)
(define-map escrow-amounts u256 u128)

(define-public (add-product
                 (product-id u256)
                 (name (string-ascii 256))
                 (price u128)
                 (quantity u256))
  (begin
    (map-set product-names product-id name)
    (map-set product-prices product-id price)
    (map-set product-quantities product-id quantity)
    (ok u"Product added successfully")))

(define-public (place-order
                 (product-id u256)
                 (quantity u128))
  (let ((buyer tx-sender)
        (current-quantity (default-to u0 (map-get? product-quantities product-id))))
    (if (>= current-quantity quantity)
        (begin
          (map-set order-buyers product-id buyer)
          (map-set order-quantities product-id quantity)
          (map-set order-delivered product-id false)
          (map-set product-quantities product-id (- current-quantity quantity))
          (ok u"Order placed successfully"))
        (err u"Product not available or insufficient quantity"))))

(define-public (confirm-delivery
                 (product-id u256))
  (let ((seller tx-sender)
        (is-delivered (default-to false (map-get? order-delivered product-id)))
        (price (default-to u0 (map-get? product-prices product-id)))
        (quantity (default-to u0 (map-get? order-quantities product-id))))
    (if (and (not is-delivered) 
             (> quantity u0)
             (is-eq seller (default-to tx-sender (map-get? escrow-sellers product-id))))
        (begin
          (map-set order-delivered product-id true)
          (map-set escrow-sellers product-id seller)
          (map-set escrow-amounts product-id (* price quantity))
          (ok u"Delivery confirmed; funds held in escrow"))
        (err u"Invalid order, unauthorized seller, or already confirmed delivery"))))

(define-public (release-funds
                 (product-id u256))
  (let ((buyer tx-sender)
        (order-buyer (map-get? order-buyers product-id))
        (escrow-amount (map-get? escrow-amounts product-id))
        (escrow-seller (map-get? escrow-sellers product-id)))
    (if (and (is-some order-buyer) 
             (is-some escrow-amount)
             (is-some escrow-seller)
             (is-eq (unwrap-panic order-buyer) buyer))
        (begin
          (try! (stx-transfer? 
                 (unwrap-panic escrow-amount)
                 tx-sender
                 (unwrap-panic escrow-seller)))
          (map-delete escrow-amounts product-id)
          (map-delete escrow-sellers product-id)
          (ok u"Funds released to seller"))
        (err u"Invalid order or unauthorized release"))))

(define-read-only (get-product
                    (product-id u256))
  (tuple 
   (name (map-get? product-names product-id))
   (price (map-get? product-prices product-id))
   (quantity (map-get? product-quantities product-id))))

(define-read-only (get-order
                    (product-id u256))
  (tuple
   (buyer (map-get? order-buyers product-id))
   (quantity (map-get? order-quantities product-id))
   (delivered (map-get? order-delivered product-id))))

(define-read-only (get-escrow
                    (product-id u256))
  (tuple
   (seller (map-get? escrow-sellers product-id))
   (amount (map-get? escrow-amounts product-id))))