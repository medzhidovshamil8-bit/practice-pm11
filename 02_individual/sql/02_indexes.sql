-- Два дополнительных индекса; автоматические индексы UNIQUE не учитываются.
CREATE INDEX idx_departure_date ON departure(start_date);
CREATE INDEX idx_booking_client_date ON booking(client_id, booked_on);
