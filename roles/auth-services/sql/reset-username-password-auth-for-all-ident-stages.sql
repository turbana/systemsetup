-- This will add back in username and password identification prompts for *all*
-- identification stages. Use this if you disable username/password
-- authentication and are locked out of the Authentik admin console.

update authentik_stages_identification_identificationstage
set user_fields = '{"username"}';
