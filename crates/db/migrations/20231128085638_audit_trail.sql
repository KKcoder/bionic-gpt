-- migrate:up
CREATE TYPE audit_access_type AS ENUM (
    'API', 
    'UserInterface'
);

CREATE TYPE audit_action AS ENUM (
    'CreateMember', 
    'DeleteMember', 
    'CreateInvite',
    'CreateTeam',
    'DeleteTeam',
    'CreateAPIKey',
    'DeleteAPIKey',
    'CreatePipelineKey',
    'DeletePipelineKey',
    'TextGeneration'
);

CREATE TABLE audit_trail (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
    user_id INT NOT NULL, 
    team_id INT, 
    access_type audit_access_type NOT NULL,
    action audit_action NOT NULL,

    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),

    CONSTRAINT fk_team
        FOREIGN KEY(team_id) 
        REFERENCES teams(id)
        ON DELETE CASCADE
);

CREATE TABLE audit_trail_text_generation (
    id int GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY, 
    audit_id INT NOT NULL, 
    chat_id INT NOT NULL, 
    tokens_sent INT NOT NULL,
    tokens_received INT NOT NULL,
    time_taken INT NOT NULL,

    CONSTRAINT fk_chat
        FOREIGN KEY(chat_id) 
        REFERENCES chats(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_audit
        FOREIGN KEY(audit_id) 
        REFERENCES audit_trail(id)
        ON DELETE CASCADE
);

COMMENT ON TABLE audit_trail IS 'Log all accesses to the system';
COMMENT ON COLUMN audit_trail.user_id IS 'The user that accessed the system';
COMMENT ON COLUMN audit_trail.team_id IS 'The team the user was working on';
COMMENT ON COLUMN audit_trail.access_type IS 'How was the system accessed i.e. by the CLI or web interface etc.';
COMMENT ON COLUMN audit_trail.action IS 'The action committed. i.e. deleting a secret etc.';


COMMENT ON TABLE audit_trail_text_generation IS 'For text generation we capture extra information';

-- Grant access
GRANT SELECT, INSERT ON audit_trail, audit_trail_text_generation TO ft_application;
GRANT USAGE, SELECT ON audit_trail_id_seq, audit_trail_text_generation_id_seq TO ft_application;

GRANT SELECT ON audit_trail, audit_trail_text_generation TO ft_readonly;
GRANT SELECT ON audit_trail_id_seq, audit_trail_text_generation_id_seq TO ft_readonly;

-- migrate:down
DROP TABLE audit_trail_text_generation;
DROP TABLE audit_trail;
DROP TYPE audit_access_type;
DROP TYPE audit_action;

