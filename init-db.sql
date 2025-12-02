-- Create databases for development
CREATE DATABASE sath_gym_development;
CREATE DATABASE sath_gym_test;

-- Create databases for production (Rails 8 Solid adapters)
CREATE DATABASE sath_gym_production;
CREATE DATABASE sath_gym_production_cache;
CREATE DATABASE sath_gym_production_queue;
CREATE DATABASE sath_gym_production_cable;

-- Grant privileges
GRANT ALL PRIVILEGES ON DATABASE sath_gym_development TO sath_gym;
GRANT ALL PRIVILEGES ON DATABASE sath_gym_test TO sath_gym;
GRANT ALL PRIVILEGES ON DATABASE sath_gym_production TO sath_gym;
GRANT ALL PRIVILEGES ON DATABASE sath_gym_production_cache TO sath_gym;
GRANT ALL PRIVILEGES ON DATABASE sath_gym_production_queue TO sath_gym;
GRANT ALL PRIVILEGES ON DATABASE sath_gym_production_cable TO sath_gym;