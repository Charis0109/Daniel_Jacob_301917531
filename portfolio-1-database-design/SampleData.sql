
-- MIT 8103 Portfolio 1
-- Hotel Reservation System Sample Data

BEGIN;

-- Insert guests
INSERT INTO public.guest (full_name, email, phone)
VALUES
    ('Ada James', 'ada.james@example.com', '08030000001'),
    ('Ben Cole', 'ben.cole@example.com', '08030000002'),
    ('Grace Miller', 'grace.miller@example.com', '08030000003');

-- Insert rooms
INSERT INTO public.room (room_number, room_type, room_status)
VALUES
    ('101', 'Single', 'Available'),
    ('102', 'Double', 'Available'),
    ('103', 'Suite', 'Available'),
    ('104', 'Single', 'Maintenance');

-- Insert reservations
INSERT INTO public.reservation (
    guest_id, room_id, check_in_date,
    check_out_date, status, checked_in_at, checked_out_at
)
VALUES
(
    (SELECT guest_id FROM public.guest
     WHERE email = 'ada.james@example.com'),
    (SELECT room_id FROM public.room WHERE room_number = '102'),
    '2026-11-15', '2026-11-17', 'Pending', NULL, NULL
),
(
    (SELECT guest_id FROM public.guest
     WHERE email = 'ben.cole@example.com'),
    (SELECT room_id FROM public.room WHERE room_number = '103'),
    '2026-11-20', '2026-11-22', 'Confirmed', NULL, NULL
),
(
    (SELECT guest_id FROM public.guest
     WHERE email = 'grace.miller@example.com'),
    (SELECT room_id FROM public.room WHERE room_number = '101'),
    '2026-11-10', '2026-11-12',
    'Checked-in', '2026-11-10 09:00:00+00', NULL
),
(
    (SELECT guest_id FROM public.guest
     WHERE email = 'ada.james@example.com'),
    (SELECT room_id FROM public.room WHERE room_number = '104'),
    '2026-10-20', '2026-10-22', 'Checked-out',
    '2026-10-20 09:00:00+00',
    '2026-10-22 11:00:00+00'
),
(
    (SELECT guest_id FROM public.guest
     WHERE email = 'ben.cole@example.com'),
    (SELECT room_id FROM public.room WHERE room_number = '101'),
    '2026-11-25', '2026-11-27', 'Cancelled', NULL, NULL
);

COMMIT;
