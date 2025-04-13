CREATE TABLE interval_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(4) NOT NULL CHECK (name IN ('hour', 'day')),
    max_value INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE interval_settings (
    id SERIAL PRIMARY KEY,
    interval_type_id INTEGER NOT NULL,
    interval INTEGER NOT NULL CHECK (interval >= 1),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (interval_type_id) REFERENCES interval_types(id),
);

CREATE OR REPLACE FUNCTION validate_interval_setting()
RETURNS TRIGGER AS $$
DECLARE
    type_name VARCHAR;
    max_val INTEGER;
BEGIN
    SELECT name, max_value 
    INTO type_name, max_val
    FROM interval_types 
    WHERE id = NEW.interval_type_id;

    IF NEW.interval > max_val THEN
        RAISE EXCEPTION 'interval value % exceeds maximum allowed value % for type %',
            NEW.interval, max_val, type_name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_interval_setting
    BEFORE INSERT OR UPDATE ON interval_settings
    FOR EACH ROW
    EXECUTE FUNCTION validate_interval_setting();

CREATE TABLE clients (
    id SERIAL PRIMARY KEY,
    slack_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE representatives (
    id SERIAL PRIMARY KEY,
    slack_id VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    content VARCHAR(1000) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE reminds (
    id SERIAL PRIMARY KEY,
    content VARCHAR(1000) NOT NULL,
    done BOOLEAN NOT NULL DEFAULT FALSE,
    client_id INTEGER NOT NULL,
    representative_id INTEGER NOT NULL,
    task_id INTEGER NOT NULL,
    interval_setting_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (client_id) REFERENCES clients(id),
    FOREIGN KEY (representative_id) REFERENCES representatives(id),
    FOREIGN KEY (task_id) REFERENCES tasks(id),
    FOREIGN KEY (interval_setting_id) REFERENCES interval_settings(id)
);

