CHANGE REPLICATION SOURCE TO SOURCE_HOST='master_db',SOURCE_USER='repl',SOURCE_PASSWORD='replpass',SOURCE_AUTO_POSITION=1,SOURCE_CONNECT_RETRY=10;
STOP REPLICA;
RESET REPLICA;
START REPLICA;