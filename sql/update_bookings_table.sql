USE voyastra;

-- Phase 7: Ensure all booking columns exist
ALTER TABLE bookings
    ADD COLUMN IF NOT EXISTS type            VARCHAR(50)  DEFAULT 'unknown',
    ADD COLUMN IF NOT EXISTS details         TEXT,
    ADD COLUMN IF NOT EXISTS booking_code    VARCHAR(100),
    ADD COLUMN IF NOT EXISTS travel_date     VARCHAR(50),
    ADD COLUMN IF NOT EXISTS num_adults      INT          DEFAULT 1,
    ADD COLUMN IF NOT EXISTS num_children    INT          DEFAULT 0,
    ADD COLUMN IF NOT EXISTS room_type       VARCHAR(100),
    ADD COLUMN IF NOT EXISTS pickup_city     VARCHAR(100),
    ADD COLUMN IF NOT EXISTS customer_name   VARCHAR(255),
    ADD COLUMN IF NOT EXISTS customer_email  VARCHAR(255),
    ADD COLUMN IF NOT EXISTS customer_phone  VARCHAR(50),
    ADD COLUMN IF NOT EXISTS special_requests TEXT,
    ADD COLUMN IF NOT EXISTS seat_class      VARCHAR(50)  DEFAULT 'economy',
    ADD COLUMN IF NOT EXISTS passengers      INT          DEFAULT 1;

-- Index for quick lookup by booking code (idempotent)
CREATE INDEX IF NOT EXISTS idx_booking_code ON bookings(booking_code);

-- Status constraint note:
-- Valid status values: PENDING | CONFIRMED | CANCELLED | REFUNDED
