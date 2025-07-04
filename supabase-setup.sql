-- Create properties table for KING AYMAN's holiday deals
CREATE TABLE IF NOT EXISTS properties (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL,
    beach_distance VARCHAR(100) NOT NULL,
    bedrooms INTEGER NOT NULL,
    sleeps VARCHAR(50) NOT NULL,
    features TEXT[],
    price_per_week DECIMAL(10, 2) NOT NULL,
    image_url TEXT,
    booking_url TEXT NOT NULL,
    badge VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create index for faster queries
CREATE INDEX idx_properties_price ON properties(price_per_week);
CREATE INDEX idx_properties_location ON properties(location);

-- Insert initial properties data
INSERT INTO properties (title, location, beach_distance, bedrooms, sleeps, features, price_per_week, image_url, booking_url, badge) VALUES
('Sunny Beach Apartment - Torrevieja', 'Costa Blanca, Alicante', '15 min to beach', 2, '4', ARRAY['Pool', 'Air Con'], 385.00, 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400', 'https://www.booking.com/searchresults.html?ss=Torrevieja&checkin=2025-08-02&checkout=2025-08-16&group_adults=2&group_children=2', 'BEST VALUE'),
('Family Villa - Alhaurín el Grande', 'Costa del Sol, Málaga', '30 min to beach', 2, '4-5', ARRAY['Private Pool', 'Parking'], 450.00, 'https://images.unsplash.com/photo-1580587771525-78b9dba3b914?w=400', 'https://www.airbnb.com/s/Alhaurin-el-Grande--Spain/homes?checkin=2025-08-02&checkout=2025-08-16&adults=2&children=2', NULL),
('Beach Resort Apartment - San Javier', 'Murcia Region', '10 min to beach', 2, '4', ARRAY['Resort Pool', 'Tennis Court'], 420.00, 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?w=400', 'https://www.vrbo.com/search?destination=San%20Javier%2C%20Murcia%2C%20Spain&startDate=2025-08-02&endDate=2025-08-16&adults=2&children=2', 'GREAT DEAL'),
('Coastal Apartment - Lloret de Mar', 'Costa Brava, Girona', '20 min walk', 2, '4', ARRAY['Full Kitchen', 'WiFi + TV'], 475.00, 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?w=400', 'https://www.booking.com/searchresults.html?ss=Lloret+de+Mar&checkin=2025-08-09&checkout=2025-08-23&group_adults=2&group_children=2', NULL),
('Beach Town Apartment - Gandia', 'Valencia Region', '25 min to beach', 2, '4', ARRAY['Community Pool', 'Near Shops'], 410.00, 'https://images.unsplash.com/photo-1493809842364-78817add7ffb?w=400', 'https://www.homeaway.com/search?q=Gandia%2C%20Spain&arrival=2025-08-02&departure=2025-08-16&adults=2&children=2', NULL),
('Beachside Flat - Roquetas de Mar', 'Almería, Andalusia', '5 min walk', 2, '4', ARRAY['Beach Access', 'Near Aquarium'], 495.00, 'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400', 'https://www.airbnb.com/s/Roquetas-de-Mar--Spain/homes?checkin=2025-08-02&checkout=2025-08-16&adults=2&children=2', 'FAMILY FAVORITE');

-- Create a view for easy property queries
CREATE VIEW available_properties AS
SELECT 
    id,
    title,
    location,
    beach_distance,
    bedrooms,
    sleeps,
    features,
    price_per_week,
    price_per_week * 2 as price_two_weeks,
    image_url,
    booking_url,
    badge
FROM properties
WHERE price_per_week <= 500
ORDER BY price_per_week ASC;

-- Create function to update timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for updated_at
CREATE TRIGGER update_properties_updated_at BEFORE UPDATE
    ON properties FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
