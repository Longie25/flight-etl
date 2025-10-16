# Sử dụng image Python làm nền
FROM python:3.9-slim

# Cài đặt git, cần thiết cho dbt để cài các package
RUN apt-get update && apt-get install -y git

# Cài đặt các thư viện dbt
RUN pip install dbt-core dbt-snowflake

# Sao chép toàn bộ project dbt vào container
COPY . .

# Thiết lập đường dẫn để dbt tìm thấy file profiles.yml
ENV DBT_PROFILES_DIR=.

# Lệnh mặc định (sẽ bị Airflow ghi đè)
CMD ["dbt", "--help"]