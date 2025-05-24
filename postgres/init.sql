-- Create schemas
CREATE SCHEMA IF NOT EXISTS n8n;
CREATE SCHEMA IF NOT EXISTS n8n_workflows;

-- Remove public access from n8n schema
REVOKE ALL ON SCHEMA n8n FROM PUBLIC;

-- Create dedicated user for workflows
DO $$
BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = '{{ N8N_POSTGRES_USER }}') THEN
        CREATE USER {{ N8N_POSTGRES_USER }} WITH PASSWORD '{{ N8N_POSTGRES_PASSWORD }}';
    END IF;
END$$;

-- Grant all privileges on n8n_workflows schema to the new user
GRANT USAGE, CREATE ON SCHEMA n8n_workflows TO {{ N8N_POSTGRES_USER }};

-- Create a sample table in n8n_workflows
CREATE TABLE IF NOT EXISTS n8n_workflows.example_workflow (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Grant all privileges on all tables in n8n_workflows to the new user
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA n8n_workflows TO {{ N8N_POSTGRES_USER }};
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA n8n_workflows TO {{ N8N_POSTGRES_USER }};

-- Ensure the user cannot access the n8n schema
REVOKE ALL ON SCHEMA n8n FROM {{ N8N_POSTGRES_USER }};
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA n8n FROM {{ N8N_POSTGRES_USER }};
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA n8n FROM {{ N8N_POSTGRES_USER }};
