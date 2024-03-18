# README

### How to use:

#### Registration:
```
curl -XPOST -H "Content-type: application/json" -d '{"user": { "email": "test@email.com", "password": "123", "username": "test" }  }' 'http://localhost:3000/sign_up'
```

#### Verification (or button in verification email)
```
curl -XPOST -H "Content-type: application/json" -d '{"user": { "email": "test@email.com", "password": "123" }  }' 'http://localhost:3000/verification'
```

#### Login
```
curl -XPOST -H "Content-type: application/json" -d '{"user": { "email": "test@email.com", "password": "123" }  }' 'http://localhost:3000/sign_in'
```

#### List of customers
```
curl -XGET -H "Content-type: application/json" -H "Authorization: TOKEN" 'http://localhost:3000/customers'
```

#### List of products
```
curl -XGET -H "Content-type: application/json" -H "Authorization: TOKEN" 'http://localhost:3000/products'
```

####  List of orders
```
curl -XGET -H "Content-type: application/json" -H "Authorization: 567352a83d51b9c5470c5c45aed8b5a6" 'http://localhost:3000/orders'
```

####  Create a new order
```
curl -XPOST -H "Content-type: application/json" -H "Authorization: 567352a83d51b9c5470c5c45aed8b5a6" -d '{"order": { "customer_id": 2, "ordered_items": [{ "product_id": 2, "quantity": 123 }] }  }' 'http://localhost:3000/orders'
```

### What can be improved:
- Add rubocop/breakman, etc.
- Add more validation to incoming parameters
- Unify responses in all controllers
- Make al TODO's in project
