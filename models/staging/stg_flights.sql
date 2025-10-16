-- models/staging/stg_flights.sql

WITH raw_data AS (
    -- Dùng hàm source() để tham chiếu đến nguồn đã khai báo trong file schema.yml
    SELECT
        raw_data AS flight_json,
        loaded_at
    FROM {{ source('raw_flights', 'flights_raw') }}
)

SELECT
    -- Trích xuất các trường từ cột JSON và chuyển đổi kiểu dữ liệu
    -- Ký hiệu '::' là cách của Snowflake để ép kiểu dữ liệu
    flight_json:icao24::STRING AS icao24,
    flight_json:callsign::STRING AS callsign,
    flight_json:origin_country::STRING AS origin_country,
    flight_json:longitude::FLOAT AS longitude,
    flight_json:latitude::FLOAT AS latitude,
    flight_json:baro_altitude::FLOAT AS altitude_meters,
    flight_json:velocity::FLOAT AS velocity_mps, -- (đơn vị: mét/giây)
    flight_json:true_track::FLOAT AS true_track_degrees, -- (hướng bay theo độ)
    flight_json:vertical_rate::FLOAT AS vertical_rate_mps, -- (tốc độ lên/xuống)
    flight_json:on_ground::BOOLEAN AS is_on_ground,

    -- Chuyển đổi Unix timestamp (số giây) thành kiểu dữ liệu thời gian
    TO_TIMESTAMP_NTZ(flight_json:time_position::INT) AS position_timestamp,
    loaded_at AS loaded_at_timestamp
FROM
    raw_data
WHERE
    longitude IS NOT NULL AND latitude IS NOT NULL -- Chỉ lấy các chuyến bay có thông tin vị trí