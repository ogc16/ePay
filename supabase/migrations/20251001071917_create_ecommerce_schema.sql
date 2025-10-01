/*
  # Epay Ecommerce Database Schema

  1. New Tables
    - `categories`
      - `id` (uuid, primary key)
      - `name` (text, unique)
      - `description` (text)
      - `image_url` (text)
      - `created_at` (timestamptz)
    
    - `products`
      - `id` (uuid, primary key)
      - `category_id` (uuid, foreign key to categories)
      - `name` (text)
      - `description` (text)
      - `price` (decimal)
      - `image_url` (text)
      - `stock` (integer, default 0)
      - `created_at` (timestamptz)
    
    - `cart_items`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to auth.users)
      - `product_id` (uuid, foreign key to products)
      - `quantity` (integer, default 1)
      - `created_at` (timestamptz)
    
    - `orders`
      - `id` (uuid, primary key)
      - `user_id` (uuid, foreign key to auth.users)
      - `total_amount` (decimal)
      - `status` (text, default 'pending')
      - `shipping_address` (text)
      - `created_at` (timestamptz)
    
    - `order_items`
      - `id` (uuid, primary key)
      - `order_id` (uuid, foreign key to orders)
      - `product_id` (uuid, foreign key to products)
      - `quantity` (integer)
      - `price` (decimal)
      - `created_at` (timestamptz)

  2. Security
    - Enable RLS on all tables
    - Categories and products are publicly readable
    - Cart items are only accessible by the owner
    - Orders and order items are only accessible by the owner
*/

-- Categories table
CREATE TABLE IF NOT EXISTS categories (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text UNIQUE NOT NULL,
  description text DEFAULT '',
  image_url text DEFAULT '',
  created_at timestamptz DEFAULT now()
);

ALTER TABLE categories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Categories are publicly readable"
  ON categories FOR SELECT
  TO public
  USING (true);

-- Products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  category_id uuid REFERENCES categories(id) ON DELETE SET NULL,
  name text NOT NULL,
  description text DEFAULT '',
  price decimal(10,2) NOT NULL,
  image_url text DEFAULT '',
  stock integer DEFAULT 0,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE products ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Products are publicly readable"
  ON products FOR SELECT
  TO public
  USING (true);

-- Cart items table
CREATE TABLE IF NOT EXISTS cart_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE CASCADE NOT NULL,
  quantity integer DEFAULT 1,
  created_at timestamptz DEFAULT now(),
  UNIQUE(user_id, product_id)
);

ALTER TABLE cart_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own cart items"
  ON cart_items FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own cart items"
  ON cart_items FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own cart items"
  ON cart_items FOR UPDATE
  TO authenticated
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own cart items"
  ON cart_items FOR DELETE
  TO authenticated
  USING (auth.uid() = user_id);

-- Orders table
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  total_amount decimal(10,2) NOT NULL,
  status text DEFAULT 'pending',
  shipping_address text NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE orders ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own orders"
  ON orders FOR SELECT
  TO authenticated
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own orders"
  ON orders FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = user_id);

-- Order items table
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid REFERENCES orders(id) ON DELETE CASCADE NOT NULL,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  quantity integer NOT NULL,
  price decimal(10,2) NOT NULL,
  created_at timestamptz DEFAULT now()
);

ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own order items"
  ON order_items FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own order items"
  ON order_items FOR INSERT
  TO authenticated
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM orders
      WHERE orders.id = order_items.order_id
      AND orders.user_id = auth.uid()
    )
  );

-- Insert sample categories
INSERT INTO categories (name, description, image_url) VALUES
  ('Electronics', 'Latest gadgets and electronics', 'https://images.pexels.com/photos/356056/pexels-photo-356056.jpeg'),
  ('Fashion', 'Trendy clothing and accessories', 'https://images.pexels.com/photos/1926769/pexels-photo-1926769.jpeg'),
  ('Home & Garden', 'Everything for your home', 'https://images.pexels.com/photos/1350789/pexels-photo-1350789.jpeg'),
  ('Sports', 'Sports equipment and gear', 'https://images.pexels.com/photos/3764011/pexels-photo-3764011.jpeg')
ON CONFLICT (name) DO NOTHING;

-- Insert sample products
INSERT INTO products (category_id, name, description, price, image_url, stock) VALUES
  ((SELECT id FROM categories WHERE name = 'Electronics'), 'Wireless Headphones', 'Premium noise-cancelling headphones', 129.99, 'https://images.pexels.com/photos/3587478/pexels-photo-3587478.jpeg', 50),
  ((SELECT id FROM categories WHERE name = 'Electronics'), 'Smart Watch', 'Fitness tracking smart watch', 199.99, 'https://images.pexels.com/photos/393047/pexels-photo-393047.jpeg', 30),
  ((SELECT id FROM categories WHERE name = 'Electronics'), 'Laptop', 'High-performance laptop', 899.99, 'https://images.pexels.com/photos/18105/pexels-photo.jpg', 20),
  ((SELECT id FROM categories WHERE name = 'Fashion'), 'Designer Sunglasses', 'Stylish UV protection sunglasses', 79.99, 'https://images.pexels.com/photos/701877/pexels-photo-701877.jpeg', 100),
  ((SELECT id FROM categories WHERE name = 'Fashion'), 'Leather Jacket', 'Premium leather jacket', 249.99, 'https://images.pexels.com/photos/1346187/pexels-photo-1346187.jpeg', 25),
  ((SELECT id FROM categories WHERE name = 'Home & Garden'), 'Coffee Maker', 'Automatic coffee brewing machine', 89.99, 'https://images.pexels.com/photos/324028/pexels-photo-324028.jpeg', 40),
  ((SELECT id FROM categories WHERE name = 'Home & Garden'), 'Indoor Plant Set', 'Beautiful decorative plant collection', 34.99, 'https://images.pexels.com/photos/1005058/pexels-photo-1005058.jpeg', 60),
  ((SELECT id FROM categories WHERE name = 'Sports'), 'Yoga Mat', 'Non-slip exercise yoga mat', 29.99, 'https://images.pexels.com/photos/4327024/pexels-photo-4327024.jpeg', 80),
  ((SELECT id FROM categories WHERE name = 'Sports'), 'Running Shoes', 'Comfortable athletic running shoes', 119.99, 'https://images.pexels.com/photos/2529148/pexels-photo-2529148.jpeg', 45);