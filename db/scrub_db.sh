#!/bin/bash

heroku pg:backups capture
curl -o latest.dump `heroku pg:backups public-url`
pg_restore --verbose --clean --no-acl --no-owner -h localhost -d progress_visualizer_development latest.dump

psql -h localhost -d progress_visualizer_development -c "delete from users where id<>2;"
psql -h localhost -d progress_visualizer_development -c "delete from user_profiles where user_id <> 2;"
psql -h localhost -d progress_visualizer_development -c "delete from burn_ups where user_profile_id not in (select id from user_profiles);"
psql -h localhost -d progress_visualizer_development -c "delete from done_stories where user_profile_id not in (select id from user_profiles);"
psql -h localhost -d progress_visualizer_development -c "delete from webhooks where user_profile_id not in (select id from user_profiles);"

rm latest.dump
